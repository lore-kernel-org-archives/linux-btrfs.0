From: David Nicol <davidnicol@gmail.com>
Subject: Re: IOCTL #21 part two: btrfs progs patch, including iso 8601 timeout support
Date: Thu, 7 Oct 2010 12:38:36 -0500
Message-ID: <AANLkTinv9+9-4Q22a=10A8OYDLTr6o0EYTi_uH=hwHHd@mail.gmail.com>
References: <AANLkTim0NC5QRs_z=tA8R5R4J07aQ7LS-Ls17t2Qvd7p@mail.gmail.com> <201010070810.42505.kreijack@libero.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-btrfs@vger.kernel.org
To: unlisted-recipients:; (no To-header on input)
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <201010070810.42505.kreijack@libero.it>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Oct 7, 2010 at 1:10 AM, Goffredo Baroncelli <kreijack@libero.it> wrote:
> Please the next time put your patch inline or it is more difficult to
> highlight a suggestion.

* drop support for years and months, except as identified usage errors

* lower-case 'm' now minutes

* escalate syntax warnings to fatal exits


diff --git a/iso8601toms.c b/iso8601toms.c
index a1ee9bd..f982d34 100644
--- a/iso8601toms.c
+++ b/iso8601toms.c
@@ -25,6 +25,8 @@

     accept a non-integer as the last numeric component

+    always treats "m" as minutes
+
  it silently accepts:

     out of order duration type letters
@@ -35,10 +37,12 @@

     non-integers in any position

- it warns on:
+ it halts and catches fire on:

     P or p appearing somewhere besides the beginning of the string

+    Attempts to use Years or Months
+
     unrecognized characters


@@ -53,7 +57,6 @@ unsigned long iso8601toms(char *P){
     char *ptr;
     char *endptr;
     short M_min = 0;
-
     ms = 0UL;
     ptr = P;
     for(;;){
@@ -62,18 +65,13 @@ unsigned long iso8601toms(char *P){
        {
           case 'P': /* anchor */ case 'p':
              if (ptr > P)
-                fprintf(stderr, "ignoring non-initial P "
-                         "in ISO8601 duration string %s\n", P);
-             break;
-          case 'Y': /* years */ case 'y':
-             component *= 12;
-          BIGM:
-             /* average days in a gregorian month */
-             component *= (365.2425 / 12.0);
-             /* ms in a day */
-             component *= ( 24 * 3600 * 1000 );
-             ms += component;
-             break;
+                fprintf(stderr, "non-initial P "
+                         "in duration string %s\n", P);
+                 exit (-1);
+          case 'Y': /* year */ case 'y':
+                fprintf(stderr, "Years are not supported "
+                         "in duration string %s\n", P);
+                 exit (-1);
           case 'T': /* Time (not date) anchor */ case 't':
              M_min = 1;
              break;
@@ -84,9 +82,15 @@ unsigned long iso8601toms(char *P){
           case 'H': /* hour */ case 'h':
              component *= 60;
              M_min = 1;
-          case 'M': /* month, or minute */ case 'm':
-             if (!M_min++)
-                 goto BIGM;
+          case 'M': /* month, or minute */
+             if (M_min == 0 ){
+                fprintf(stderr, "Months are not supported "
+                         "in duration string %s\n"
+                         "use 'm' instead or prefix a 'T'\n"
+                         , P);
+                 exit (-1);
+             };
+          case 'm': /* minute */
              component *= 60;
           case 'S': /* second */ case 's':
           case '\0': /* default to second */
@@ -96,10 +100,11 @@ unsigned long iso8601toms(char *P){

           default:
             fprintf(stderr,
-                "ignoring unexpected char [%c] "
-                "in iso8601 duration string %s\n",
+                "unexpected char [%c] in duration string %s\n"
+                "valid designators are [WwDdHhMmSs] with implied
trailing S.\n",
                 *endptr, P
              );
+             exit (-1);
        };
        if (!*endptr)
           return (ms);
