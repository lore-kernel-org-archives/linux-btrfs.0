From: David Nicol <davidnicol@gmail.com>
Subject: revised ioctl#21 btrfsprogs patch
Date: Wed, 15 Dec 2010 16:18:50 -0600
Message-ID: <AANLkTikHZZuk+Z4+CUsiHyeL2zba6EYV4Wo2EqQnDCwm@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: BTRFS MAILING LIST <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

the below is against 70c6c10134b502fa69955746554031939b85fb0c which is
the head of the "next" branch.
1: absolute-sized fields in the interface object
2: now getting error from errno instead of the return value of ioctl(2)


---------- Forwarded message ----------
=46rom: project user
Date: Wed, Dec 15, 2010 at 4:15 PM
Subject: btrfsprogs revised ioctl#21 patch


diff --git a/Makefile b/Makefile
index d65f6a2..b8ef1f2 100644
--- a/Makefile
+++ b/Makefile
@@ -37,12 +37,13 @@ all: version $(progs) manpages
=C2=A0version:
=C2=A0 =C2=A0 =C2=A0 =C2=A0bash version.sh

-btrfs: $(objects) btrfs.o btrfs_cmds.o
- =C2=A0 =C2=A0 =C2=A0 gcc $(CFLAGS) -o btrfs btrfs.o btrfs_cmds.o \
+btrfs: $(objects) btrfs.o btrfs_cmds.o iso8601toms.o
+ =C2=A0 =C2=A0 =C2=A0 gcc $(CFLAGS) -o btrfs btrfs.o btrfs_cmds.o iso8=
601toms.o \
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0$(objects) $(LDF=
LAGS) $(LIBS)

-btrfsctl: $(objects) btrfsctl.o
- =C2=A0 =C2=A0 =C2=A0 gcc $(CFLAGS) -o btrfsctl btrfsctl.o $(objects) =
$(LDFLAGS) $(LIBS)
+btrfsctl: $(objects) btrfsctl.o iso8601toms.o
+ =C2=A0 =C2=A0 =C2=A0 gcc $(CFLAGS) -o btrfsctl btrfsctl.o iso8601toms=
=2Eo \
+ =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 $(objects) $(LDFLAGS=
) $(LIBS)

=C2=A0btrfs-vol: $(objects) btrfs-vol.o
=C2=A0 =C2=A0 =C2=A0 =C2=A0gcc $(CFLAGS) -o btrfs-vol btrfs-vol.o $(obj=
ects) $(LDFLAGS) $(LIBS)
diff --git a/btrfs.c b/btrfs.c
index 46314cf..6b3ebf6 100644
--- a/btrfs.c
+++ b/btrfs.c
@@ -29,6 +29,7 @@ struct Command {
=C2=A0 =C2=A0 =C2=A0 =C2=A0CommandFunction func; =C2=A0 /* function whi=
ch implements the command */
=C2=A0 =C2=A0 =C2=A0 =C2=A0int =C2=A0 =C2=A0 nargs; =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0/* if =3D=3D 999, any number of arguments
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if >=3D 0, number of argu=
ments,
+ =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if > 1000, 1000 more t=
han the
_maximum_ number of arguments,
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if < 0, _minimum_ number =
of arguments */
=C2=A0 =C2=A0 =C2=A0 =C2=A0char =C2=A0 =C2=A0*verb; =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0/* verb */
=C2=A0 =C2=A0 =C2=A0 =C2=A0char =C2=A0 =C2=A0*help; =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0/* help lines; form the 2nd onward they are
@@ -73,14 +74,19 @@ static struct Command commands[] =3D {
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0"Set the subvolu=
me of the filesystem <path> which will
be mounted\n"
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0"as default."
=C2=A0 =C2=A0 =C2=A0 =C2=A0},
- =C2=A0 =C2=A0 =C2=A0 { do_fssync, 1,
- =C2=A0 =C2=A0 =C2=A0 =C2=A0 "filesystem sync", "<path>\n"
- =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 "Force a sync on the=
 filesystem <path>."
+ =C2=A0 =C2=A0 =C2=A0 { do_fssync, 1002,
+ =C2=A0 =C2=A0 =C2=A0 =C2=A0 "filesystem sync", "[-dq] <path>\n"
+ =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 "Force a sync on the=
 filesystem <path>, defaulting to '.'."
+ =C2=A0 =C2=A0 =C2=A0 },
+ =C2=A0 =C2=A0 =C2=A0 { do_wait4clean, 1002, /* require at most two ar=
gs */
+ =C2=A0 =C2=A0 =C2=A0 =C2=A0 "filesystem reclaim", "[path [timeout]] \=
n"
+ =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 "Wait for cleanup of=
 deleted subvolumes. Path defaults to .\n"
+ =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 "Timeout in seconds,=
 or add m for minutes.\n"
=C2=A0 =C2=A0 =C2=A0 =C2=A0},
=C2=A0 =C2=A0 =C2=A0 =C2=A0{ do_resize, 2,
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0"filesystem resize", "[+/-]<newsize>[=
gkm]|max <filesystem>\n"
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0"Resize the file=
 system. If 'max' is passed, the filesystem\n"
- =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 "will occupe all ava=
ilable space on the device."
+ =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 "will occupy all ava=
ilable space on the device."
=C2=A0 =C2=A0 =C2=A0 =C2=A0},
=C2=A0 =C2=A0 =C2=A0 =C2=A0{ do_show_filesystem, 999,
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0"filesystem show", "[<uuid>|<label>]\=
n"
@@ -349,6 +355,15 @@ static int parse_args(int argc, char **argv,
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return -2;

=C2=A0 =C2=A0 =C2=A0 =C2=A0/* check the number of argument */
+
+ =C2=A0 =C2=A0 =C2=A0 if(matchcmd->nargs > 1000 ){
+ =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if ( matchcmd->nargs < (1000 + *nar=
gs_)){
+ =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 fprintf(stderr, "ERR=
OR: '%s' requires only %d or fewer
arg(s)\n",
+ =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 matchcmd->verb, matchcmd->nargs - 1000 );
+ =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 return -2;
+ =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0}
+ =C2=A0 =C2=A0 =C2=A0 } else {
+
=C2=A0 =C2=A0 =C2=A0 =C2=A0if (matchcmd->nargs < 0 && matchcmd->nargs <=
 -*nargs_ ){
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0fprintf(stderr, =
"ERROR: '%s' requires minimum %d arg(s)\n",
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0matchcmd->verb, -matchcmd->nargs);
@@ -359,7 +374,7 @@ static int parse_args(int argc, char **argv,
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0matchcmd->verb, matchcmd->nargs);
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0return -2;
=C2=A0 =C2=A0 =C2=A0 =C2=A0}
-
+ =C2=A0 =C2=A0 =C2=A0 }
=C2=A0 =C2=A0 =C2=A0 =C2=A0 if (prepare_args( nargs_, args_, prgname, m=
atchcmd )){
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 fprintf(stderr,=
 "ERROR: not enough memory\\n");
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return -20;
diff --git a/btrfs_cmds.c b/btrfs_cmds.c
index 8031c58..89f1f22 100644
--- a/btrfs_cmds.c
+++ b/btrfs_cmds.c
@@ -507,15 +507,37 @@ int do_create_subvol(int argc, char **argv)
=C2=A0int do_fssync(int argc, char **argv)
=C2=A0{
=C2=A0 =C2=A0 =C2=A0 =C2=A0int fd, res;
- =C2=A0 =C2=A0 =C2=A0 char =C2=A0 =C2=A0*path =3D argv[1];
-
+ =C2=A0 =C2=A0 =C2=A0 =C2=A0int cleanup=3D1, quiet=3D0;
+ =C2=A0 =C2=A0 =C2=A0 char =C2=A0 =C2=A0*path =3D ".", *p; /* [-dq] [<=
path>] */
+ =C2=A0 =C2=A0 =C2=A0 =C2=A0struct btrfs_ioctl_cleaner_wait_args w4c_a=
rg;
+
+ =C2=A0 =C2=A0 =C2=A0 =C2=A0if (argc > 1){
+ =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (argv[1][0] =3D=3D '-'){
+ =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 for (p=3D&argv[1][1]; *p; p=
++) switch (*p){
+ =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0case 'q': quie=
t++; break;
+ =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0case 'd': clea=
nup++; break;
+ =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0default:
+ =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 fprint=
f(stderr,
+ =C2=A0 =C2=A0 "ERROR: unknown flag '%c' in '%s'\n", *p,argv[1]);
+ =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return =
12;
+ =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 };
+ =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (argc > 2)
+ =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 path =3D argv=
[2];
+
+ =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 }else{
+ =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0path =3D argv[1];
+
+ =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 };
+
+ =C2=A0 =C2=A0 =C2=A0 =C2=A0};
+ =C2=A0 =C2=A0while (cleanup--){ /* cleanup starts at 1 */
=C2=A0 =C2=A0 =C2=A0 =C2=A0fd =3D open_file_or_dir(path);
=C2=A0 =C2=A0 =C2=A0 =C2=A0if (fd < 0) {
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0fprintf(stderr, =
"ERROR: can't access to '%s'\n", path);
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return 12;
=C2=A0 =C2=A0 =C2=A0 =C2=A0}

- =C2=A0 =C2=A0 =C2=A0 printf("FSSync '%s'\n", path);
+ =C2=A0 =C2=A0 =C2=A0 if (!quiet) printf("FSSync '%s'\n", path);
=C2=A0 =C2=A0 =C2=A0 =C2=A0res =3D ioctl(fd, BTRFS_IOC_SYNC);
=C2=A0 =C2=A0 =C2=A0 =C2=A0close(fd);
=C2=A0 =C2=A0 =C2=A0 =C2=A0if( res < 0 ){
@@ -523,6 +545,56 @@ int do_fssync(int argc, char **argv)
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return 16;
=C2=A0 =C2=A0 =C2=A0 =C2=A0}

+ =C2=A0 =C2=A0 =C2=A0 =C2=A0if (cleanup){
+ =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 w4c_arg.ms =3D 0x00000000;
+ =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 w4c_arg.flags =3D 0x00000000;
+ =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0fd =3D open_file_or_dir(path);
+ =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (fd < 0) {
+ =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 fprintf(stderr, "ERR=
OR: can't access to '%s'\n", path);
+ =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return 12;
+ =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0}
+ =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (!quiet) printf("reclaim: '%s'\n=
", path);
+ =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0res =3D ioctl(fd, BTRFS_IOC_CLEANER=
_WAIT, &w4c_arg);
+ =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0close(fd);
+ =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if( res !=3D 0 ){
+ =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 fprintf(stderr, "%s:=
error #%i:%s\n",
+ =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0path, errno,strerror(errno));
+ =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return errno;
+ =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0}
+ =C2=A0 =C2=A0 =C2=A0 =C2=A0}
+ =C2=A0 =C2=A0};
+ =C2=A0 =C2=A0 =C2=A0 return 0;
+}
+
+#include "iso8601toms.h"
+
+int do_wait4clean(int argc, char **argv)
+{
+ =C2=A0 =C2=A0 =C2=A0 int fd, res;
+ =C2=A0 =C2=A0 =C2=A0 =C2=A0struct btrfs_ioctl_cleaner_wait_args w4c_a=
rg;
+
+ =C2=A0 =C2=A0 =C2=A0 char =C2=A0 =C2=A0*path =3D ".";
+ =C2=A0 =C2=A0 =C2=A0 =C2=A0w4c_arg.ms =3D 0x00000000;
+ =C2=A0 =C2=A0 =C2=A0 =C2=A0w4c_arg.flags =3D 0x00000000;
+
+ =C2=A0 =C2=A0 =C2=A0 =C2=A0if (argc > 1)
+ =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0path =3D argv[1];
+ =C2=A0 =C2=A0 =C2=A0 =C2=A0if (argc > 2)
+ =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 w4c_arg.ms =3D iso8601toms(=
argv[2]);
+
+ =C2=A0 =C2=A0 =C2=A0 fd =3D open_file_or_dir(path);
+ =C2=A0 =C2=A0 =C2=A0 if (fd < 0) {
+ =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 fprintf(stderr, "ERR=
OR: can't open file or dir '%s'\n", path);
+ =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return 12;
+ =C2=A0 =C2=A0 =C2=A0 }
+ =C2=A0 =C2=A0 =C2=A0 res =3D ioctl(fd, BTRFS_IOC_CLEANER_WAIT, &w4c_a=
rg);
+ =C2=A0 =C2=A0 =C2=A0 close(fd);
+ =C2=A0 =C2=A0 =C2=A0 if( res !=3D 0 ){
+ =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 fprintf(stderr, "%s:=
error #%i:%s\n",
+ =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0path, errno,strerror(errno));
+ =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return errno;
+ =C2=A0 =C2=A0 =C2=A0 }
+
=C2=A0 =C2=A0 =C2=A0 =C2=A0return 0;
=C2=A0}

diff --git a/btrfs_cmds.h b/btrfs_cmds.h
index 7bde191..c958338 100644
--- a/btrfs_cmds.h
+++ b/btrfs_cmds.h
@@ -19,6 +19,7 @@ int do_clone(int nargs, char **argv);
=C2=A0int do_delete_subvolume(int nargs, char **argv);
=C2=A0int do_create_subvol(int nargs, char **argv);
=C2=A0int do_fssync(int nargs, char **argv);
+int do_wait4clean(int nargs, char **argv);
=C2=A0int do_defrag(int argc, char **argv);
=C2=A0int do_show_filesystem(int nargs, char **argv);
=C2=A0int do_add_volume(int nargs, char **args);
diff --git a/btrfsctl.c b/btrfsctl.c
index 92bdf39..cf7f69a 100644
--- a/btrfsctl.c
+++ b/btrfsctl.c
@@ -34,6 +34,7 @@
=C2=A0#include "ctree.h"
=C2=A0#include "transaction.h"
=C2=A0#include "utils.h"
+#include "iso8601toms.h"
=C2=A0#include "version.h"

=C2=A0#ifdef __CHECKER__
@@ -57,6 +58,7 @@ static void print_usage(void)
=C2=A0 =C2=A0 =C2=A0 =C2=A0printf("\t-a: scans all devices for Btrfs fi=
lesystems\n");
=C2=A0 =C2=A0 =C2=A0 =C2=A0printf("\t-c: forces a single FS sync\n");
=C2=A0 =C2=A0 =C2=A0 =C2=A0printf("\t-D: delete snapshot\n");
+ =C2=A0 =C2=A0 =C2=A0 printf("\t-C [timeout [directory]]: wait for sna=
pshot space
recovery\n");
=C2=A0 =C2=A0 =C2=A0 =C2=A0printf("\t-m [tree id] directory: set the de=
fault mounted subvolume"
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 " to the [tree id] or =
the directory\n");
=C2=A0 =C2=A0 =C2=A0 =C2=A0printf("%s\n", BTRFS_BUILD_VERSION);
@@ -96,7 +98,7 @@ int main(int ac, char **av)
=C2=A0 =C2=A0 =C2=A0 =C2=A0char *fname =3D NULL;
=C2=A0 =C2=A0 =C2=A0 =C2=A0char *snap_location =3D NULL;
=C2=A0 =C2=A0 =C2=A0 =C2=A0int snap_fd =3D 0;
- =C2=A0 =C2=A0 =C2=A0 int fd;
+ =C2=A0 =C2=A0 =C2=A0 int fd =3D -999; /* silence a warning */
=C2=A0 =C2=A0 =C2=A0 =C2=A0int ret;
=C2=A0 =C2=A0 =C2=A0 =C2=A0struct btrfs_ioctl_vol_args args;
=C2=A0 =C2=A0 =C2=A0 =C2=A0char *name =3D NULL;
@@ -106,6 +108,7 @@ int main(int ac, char **av)
=C2=A0 =C2=A0 =C2=A0 =C2=A0char *pos;
=C2=A0 =C2=A0 =C2=A0 =C2=A0char *fullpath;
=C2=A0 =C2=A0 =C2=A0 =C2=A0u64 objectid =3D 0;
+ =C2=A0 =C2=A0 =C2=A0 =C2=A0struct btrfs_ioctl_cleaner_wait_args CWarg=
s;

=C2=A0 =C2=A0 =C2=A0 =C2=A0if (ac =3D=3D 2 && strcmp(av[1], "-a") =3D=3D=
 0) {
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0fprintf(stderr, =
"Scanning for Btrfs filesystems\n");
@@ -186,6 +189,11 @@ int main(int ac, char **av)
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0fprintf(stderr, "-D size too long=
\n");
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0exit(1);
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0}
+ =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 } else if (strcmp(av=
[i], "-C") =3D=3D 0) {
+ =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 command =3D BTRFS_IOC_CLEANER_WAIT;
+ =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0CWargs.ms =3D ( ac > (i+1) ?
iso8601toms(av[i+1]) : 0x00000000 );
+ =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0CWargs.flags =3D 0x00000000;
+ =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 name =3D ( ac > ( i+2 ) ? av[i + 2] : "." );
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0} else if (strcm=
p(av[i], "-A") =3D=3D 0) {
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0if (i >=3D ac - 1) {
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0fprintf(stderr, "-A requires an a=
rg\n");
@@ -232,7 +240,7 @@ int main(int ac, char **av)
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0exit(1);
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0}
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0name =3D fname;
- =C2=A0 =C2=A0 =C2=A0 =C2=A0} else {
+ =C2=A0 =C2=A0 =C2=A0 } else if (command !=3D BTRFS_IOC_CLEANER_WAIT) =
{
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0fd =3D open_file=
_or_dir(fname);
=C2=A0 =C2=A0 =C2=A0 =C2=A0 }

@@ -247,6 +255,9 @@ int main(int ac, char **av)
=C2=A0 =C2=A0 =C2=A0 =C2=A0} else if (command =3D=3D BTRFS_IOC_DEFAULT_=
SUBVOL) {
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0printf("objectid=
 is %llu\n", objectid);
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0ret =3D ioctl(fd=
, command, &objectid);
+ =C2=A0 =C2=A0 =C2=A0 } else if (command =3D=3D BTRFS_IOC_CLEANER_WAIT=
) {
+ =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 fd =3D open_file_or_=
dir(name);
+ =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 ret =3D ioctl(fd, co=
mmand, &CWargs);
=C2=A0 =C2=A0 =C2=A0 =C2=A0} else
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0ret =3D ioctl(fd=
, command, &args);
=C2=A0 =C2=A0 =C2=A0 =C2=A0if (ret < 0) {
diff --git a/ioctl.h b/ioctl.h
index 776d7a9..dc3f2fb 100644
--- a/ioctl.h
+++ b/ioctl.h
@@ -169,4 +169,11 @@ struct btrfs_ioctl_space_args {
=C2=A0#define BTRFS_IOC_DEFAULT_SUBVOL _IOW(BTRFS_IOCTL_MAGIC, 19, u64)
=C2=A0#define BTRFS_IOC_SPACE_INFO _IOWR(BTRFS_IOCTL_MAGIC, 20, \
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0struct btrfs_ioctl_=
space_args)
+struct btrfs_ioctl_cleaner_wait_args{
+ =C2=A0 =C2=A0 =C2=A0 =C2=A0__u32 ms;
+ =C2=A0 =C2=A0 =C2=A0 =C2=A0__u32 flags; /* controls what to wait for,=
 and stricture.
Zero waits for subvol deletions. */
+};
+#define BTRFS_IOC_CLEANER_WAIT _IOW(BTRFS_IOCTL_MAGIC, 21, \
+ =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 struct btrfs_ioctl_cl=
eaner_wait_args)
=C2=A0#endif
+
diff --git a/man/btrfs.8.in b/man/btrfs.8.in
index 26ef982..a62f02b 100644
--- a/man/btrfs.8.in
+++ b/man/btrfs.8.in
@@ -17,7 +17,9 @@ btrfs \- control a btrfs filesystem
=C2=A0.PP
=C2=A0\fBbtrfs\fP \fBfilesystem defrag\fP\fI <file>|<dir> [<file>|<dir>=
=2E..]\fP
=C2=A0.PP
-\fBbtrfs\fP \fBfilesystem sync\fP\fI <path> \fP
+\fBbtrfs\fP \fBfilesystem sync\fP\fI [-dq] [<path>] \fP
+.PP
+\fBbtrfs\fP \fBfilesystem reclaim\fP\fI [path [timeout]] \fP
=C2=A0.PP
=C2=A0\fBbtrfs\fP \fBfilesystem resize\fP\fI [+/\-]<size>[gkm]|max <fil=
esystem>\fP
=C2=A0.PP
@@ -111,8 +113,22 @@ Scan devices for a btrfs filesystem. If no
devices are passed, \fBbtrfs\fR scans
=C2=A0all the block devices.
=C2=A0.TP

-\fBfilesystem sync\fR\fI <path> \fR
-Force a sync for the filesystem identified by \fI<path>\fR.
+\fBfilesystem sync\fR \fI[-dq] [<path>]\fR
+Force a sync for the filesystem identified by \fI<path>\fR, which defa=
ults
+to the current directory. Use the \fI-d\fR switch to wait for the dele=
ted
+subvolume cleaner thread to finish, and the \fI-q\fR switch to suppres=
s
+informational output.
+.TP
+
+\fBfilesystem reclaim\fR\fI [path [timeout]] \fR
+Wait for recovery of space from deleted
+subvolumes on the filesystem containing \fIpath\fR,
+which defaults to the current working directory, to complete.
+The optional timeout parameter is a series of number[.number][letter]
+components where the letter is one of wdhms for weeks, days, hours, mi=
nutes,
+seconds, defaulting to seconds. The default timeout is zero which mean=
s
+no timeout. 90, 1.5m, and PT1.5M all mean ninety seconds.
+
=C2=A0.TP

=C2=A0.\"
diff --git a/man/btrfsctl.8.in b/man/btrfsctl.8.in
index c2d4488..890c625 100644
--- a/man/btrfsctl.8.in
+++ b/man/btrfsctl.8.in
@@ -10,6 +10,7 @@ btrfsctl \- control a btrfs filesystem
=C2=A0[ \fB \-A\fP\fI device\fP ]
=C2=A0[ \fB \-a\fP ]
=C2=A0[ \fB \-c\fP ]
+[ \fB \-C\fP\fI [timeout [directory]]\fP ]
=C2=A0.SH DESCRIPTION
=C2=A0.B btrfsctl
=C2=A0is used to control the filesystem and the files and directories
stored. It is the tool to create a new snapshot for the filesystem.
@@ -35,6 +36,13 @@ Scans all devices present in the system for btrfs fi=
lesystem.
=C2=A0.TP
=C2=A0\fB\-c\fR
=C2=A0Forces a filesystem sync.
+.TP
+\fB\-C\fR \fI[timeout [directory]]\fR
+Wait until all the space from all deleted snapshots has been recovered=
=2E
+The optional timeout parameter is seconds[.subseconds], or append "m"
+for minutes[.subminutes]. "90", "90.000s", "T1.5M", and "1m30" all mea=
n
+the same thing. The default timeout is zero, which means do not time o=
ut.
+The optional directory parameter defaults to the current directory.
=C2=A0.SH AVAILABILITY
=C2=A0.B btrfsctl
=C2=A0is part of btrfs-progs. Btrfs is currently under heavy developmen=
t,



--=20
=E2=80=9CThe aeroplane is fatally defective. It is merely a toy=E2=80=94=
a sporting
play-thing. =C2=A0It can never become commercially practical." -- Nikol=
a
Tesla
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
