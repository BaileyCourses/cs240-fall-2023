int factorial(int n)
{
  if (n == 0)
    return 1;
  return n * factorial(n - 1);
}

int min(int x, int y) {
  if (x < y)
    return x;
  else
    return y;
}
