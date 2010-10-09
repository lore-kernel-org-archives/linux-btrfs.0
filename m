From: Andreas Philipp <philipp.andreas@gmail.com>
Subject: Re: [PATCH][btrfs progs] Update/clean up btrfs help and man page
Date: Sat, 09 Oct 2010 22:12:31 +0200
Message-ID: <4CB0CCAF.6080905@gmail.com>
References: <201009132124.09118.kreijack@libero.it> <4CB07234.1080102@gmail.com> <AANLkTin_Onxqeu2cnj7zCk879hEBTxAe-4eh-i1DvsB9@mail.gmail.com> <201010092133.32474.kreijack@libero.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs@vger.kernel.org,
	=?ISO-8859-1?Q?J=E9r=F4me_Poulin?= <jeromepoulin@gmail.com>
To: kreijack@libero.it
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <201010092133.32474.kreijack@libero.it>
List-ID: <linux-btrfs.vger.kernel.org>


-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1
=20
Hi all,

I tried the patch and found a few more things one might to
update/clean up.
Regarding the INSTALL file:
- - There are three example lines for snapshot creation while two can
show the same things.

Regarding the help of the btrfs command:
- - The line breaks in the source code for the help lines about the
btrfs scan command were different from all other commands.
- - The optional argument of the "scan" command was written in a strang=
e
way.
- - Mixed usage of <device> and <dev>. I changed it to <device>.
- - The "filesystem show" command accepts also the argument type <devic=
e>.
- - Sometimes there were just two dots instead of three.

Regarding the btrfs command man page:
- - Changed the example for ambiguous commands since "btrfs device show=
"
no longer exists.
- - The optional argument of the "scan" command was written in a strang=
e
way.
- - Mixed usage of <device> and <dev>. I changed it to <device>.
- - The "filesystem show" command accepts also the argument type <devic=
e>.
- - Sometimes there were just two dots instead of three.
- - In the summary, there was "filesystem defrag" instead of "filesyste=
m
defragment".

My patch applies on top of the changes from Goffredo Baroncelli.

Kind Regards,
Andreas Philipp

diff --git a/INSTALL b/INSTALL
index 2c9cf1c..3840148 100644
- --- a/INSTALL
+++ b/INSTALL
@@ -35,9 +35,7 @@ btrfs: control program to create snapshots and
subvolumes:
=20
     # snapshot of a subvolume
     btrfs subvolume snapshot /mnt/default /mnt/snapshot_of_default
- -    btrfs subvolume snapshot /mnt/new_subvol_name \
- -        /mnt/snapshot_of_new_subvol
- -    btrfs subvolume snapshot /mnt/snapshot_of_new_subvol \
+    btrfs subvolume snapshot /mnt/snapshot_of_default \
         /mnt/snapshot_of_a_snapshot
=20
     # list of the subvolumes
diff --git a/btrfs.c b/btrfs.c
index a607786..1b1adb7 100644
- --- a/btrfs.c
+++ b/btrfs.c
@@ -84,7 +84,7 @@ static struct Command commands[] =3D {
         "the id of the device which grown or will shrink."
     },
     { do_show_filesystem, 999,
- -      "filesystem show", "[<uuid>|<label>]\n"
+      "filesystem show", "[<device>|<uuid>|<label>]\n"
         "Show the info of a btrfs filesystem. If no <uuid> or <label>\=
n"
         "is passed, info of all the btrfs filesystem are shown."
     },
@@ -96,17 +96,17 @@ static struct Command commands[] =3D {
       "filesystem balance", "<path>\n"
         "Balance the chunks across the device."
     },
- -    { do_scan,
- -      999, "device scan", "[<device> [<device>..]\n"
+    { do_scan, 999,
+      "device scan", "[<device>...]\n"
         "Scan all device for or the passed device for a btrfs\n"
         "filesystem."
     },
     { do_add_volume, -2,
- -      "device add", "<dev> [<dev>..] <path>\n"
+      "device add", "<device> [<device>...] <path>\n"
         "Add a device to a filesystem."
     },
     { do_remove_volume, -2,
- -      "device delete", "<dev> [<dev>..] <path>\n"
+      "device delete", "<device> [<device>...] <path>\n"
         "Remove a device from a filesystem."
     },
     /* coming soon
diff --git a/man/btrfs.8.in b/man/btrfs.8.in
index 1997aa8..6caee8b 100644
- --- a/man/btrfs.8.in
+++ b/man/btrfs.8.in
@@ -19,19 +19,19 @@ btrfs \- control a btrfs filesystem
 .PP
 \fBbtrfs\fP \fBfilesystem balance\fP\fI <path> \fP
 .PP
- -\fBbtrfs\fP \fBfilesystem defrag\fP\fI [-vcf] [-s start] [-l len] [-=
t
size] <file>|<dir> [<file>|<dir>...]\fP
+\fBbtrfs\fP \fBfilesystem defragment\fP\fI [-vcf] [-s start] [-l len]
[-t size] <file>|<dir> [<file>|<dir>...]\fP
 .PP
 \fBbtrfs\fP \fBfilesystem sync\fP\fI <path> \fP
 .PP
 \fBbtrfs\fP \fBfilesystem resize\fP\fI
[<devid>:][+/\-]<size>[gkm]|max <filesystem>\fP
 .PP
- -\fBbtrfs\fP \fBdevice scan\fP\fI [<device> [<device>..]]\fP
+\fBbtrfs\fP \fBdevice scan\fP\fI [<device>...]\fP
 .PP
- -\fBbtrfs\fP \fBdevice show\fP\fI <dev>|<label> [<dev>|<label>...]\fP
+\fBbtrfs\fP \fBdevice show\fP\fI [<device>|<uuid>|<label>]\fP
 .PP
- -\fBbtrfs\fP \fBdevice add\fP\fI <dev> [<dev>..] <path> \fP
+\fBbtrfs\fP \fBdevice add\fP\fI <device> [<device>...] <path> \fP
 .PP
- -\fBbtrfs\fP \fBdevice delete\fP\fI <dev> [<dev>..] <path> \fP]
+\fBbtrfs\fP \fBdevice delete\fP\fI [<device>...] <path> \fP]
=20
 .PP
 \fBbtrfs\fP \fBhelp|\-\-help|\-h \fP\fI\fP
@@ -49,11 +49,11 @@ For example: it is possible to run
 instead of
 .I btrfs subvolume snapshot.
 But
- -.I btrfs dev s
+.I btrfs dev a
 is not allowed, because
- -.I dev s
+.I dev a
 may be interpreted both as
- -.I device show
+.I device add
 and as
 .I device scan.
 In this case
@@ -119,7 +119,7 @@ If the switch \fB-t\fR is passed, any extent
bigger than \fB<size>\fR is
 considered already defragged.
 .TP
=20
- -\fBdevice scan\fR \fI[<device> [<device>..]]\fR
+\fBdevice scan\fR \fI[<device>...]\fR
 Scan devices for a btrfs filesystem. If no devices are passed,
\fBbtrfs\fR scans
 all the block devices.
 .TP
@@ -154,9 +154,9 @@ partition after reducing the size of the filesystem=
=2E
 To know the ID of a device use the command \fBbtrfs filesystem show\fR=
=2E
 .TP
=20
- -\fBfilesystem show\fR [<uuid>|<label>]\fR
+\fBfilesystem show\fR [<device>|<uuid>|<label>]\fR
 Show the btrfs filesystem with some additional info. If no UUID or
label is
- -passed, \fBbtrfs\fR show info of all the btrfs filesystem.
+passed, \fBbtrfs\fR shows info of all the btrfs filesystems.
 .TP
=20
 \fBfilesystem balance\fR \fI<path>\fR
@@ -164,11 +164,11 @@ Balance the chunks of the filesystem identified
by \fI<path>\fR
 across the devices.
 .TP
=20
- -\fBdevice add\fR\fI <dev> [<dev>..] <path>\fR
+\fBdevice add\fR\fI <device> [<device>...] <path>\fR
 Add device(s) to the filesystem identified by \fI<path>\fR.
 .TP
=20
- -\fBdevice delete\fR\fI <dev> [<dev>..] <path>\fR
+\fBdevice delete\fR\fI <device> [<device>...] <path>\fR
 Remove device(s) from a filesystem identified by \fI<path>\fR.
=20
 If the devices are used in RAID mode, it is not possible to reduce the


On 09.10.2010 21:33, Goffredo Baroncelli wrote:
> Hi all,
>
> enclose you can find a patch which improves the help of the btrfs com=
mands,
> updates the INSTALL file and the btrfs (command) man page.
>
> Regarding the help of the btrfs command:
> - moved the "subvolume set-default" command in the "subvolume" comman=
ds
group
> - removed a wrong new line
>
> Regarding the btrfs command man page:
> - renaming the command "device balance" in "filesystem balance" (than=
ks to
> Andrea Phillipp to highlight that)
> - adding the entry "subvolume find-new"
> - document the switches of the command "filesystem defrag"
> - document the <devid> facility of the command "filesystem resize"
>
> Regarding the INSTALL file, which was very old, I removed the referen=
ce
of the
> old btrfsctl utility and changed the examples using the btrfs command=
=2E
> I removed the old (and now wrong) statement about the inability to
delete a
> subvolume/snapshot
>
> Chris, you can pull the patch from the branch "help_cleanup" of the
following
> repository.
>
> http://cassiopea.homelinux.net/git/btrfs-progs-unstable-all.git
>
> The patch is very simple: only updates the man page, the INSTALL file=
 and
> moves some lines in the qhelp of btrfs command. Comments are welcome.
>
> Regards
> G.Baroncelli
>
> INSTALL | 31 ++++++++++++++++++++++---------
> btrfs.c | 17 +++++++++--------
> man/btrfs.8.in | 36 +++++++++++++++++++++++++++++-------
> 3 files changed, 60 insertions(+), 24 deletions(-)
>
>
>
> diff --git a/INSTALL b/INSTALL
> index 16b45a5..2c9cf1c 100644
> --- a/INSTALL
> +++ b/INSTALL
> @@ -22,23 +22,34 @@ in the e2fsprogs sources, and is usually availabl=
e
as libuuid or
> e2fsprogs-devel from various distros.
>
> Building the utilities is just make ; make install. The programs go
> -into /usr/local/bin. The commands available are:
> +into /usr/local/bin. The mains commands available are:
>
> mkfs.btrfs: create a filesystem
>
> -btrfsctl: control program to create snapshots and subvolumes:
> -
> +btrfs: control program to create snapshots and subvolumes:
> + # mount a btrfs filesystem
> mount /dev/sda2 /mnt
> - btrfsctl -s new_subvol_name /mnt
> - btrfsctl -s snapshot_of_default /mnt/default
> - btrfsctl -s snapshot_of_new_subvol /mnt/new_subvol_name
> - btrfsctl -s snapshot_of_a_snapshot /mnt/snapshot_of_new_subvol
> +
> + # create a subvolume
> + btrfs subvolume create /mnt/new_subvol_name
> +
> + # snapshot of a subvolume
> + btrfs subvolume snapshot /mnt/default /mnt/snapshot_of_default
> + btrfs subvolume snapshot /mnt/new_subvol_name \
> + /mnt/snapshot_of_new_subvol
> + btrfs subvolume snapshot /mnt/snapshot_of_new_subvol \
> + /mnt/snapshot_of_a_snapshot
> +
> + # list of the subvolumes
> ls /mnt
> default snapshot_of_a_snapshot snapshot_of_new_subvol
> new_subvol_name snapshot_of_default
>
> - Snapshots and subvolumes cannot be deleted right now, but you can
> - rm -rf all the files and directories inside them.
> + # removal of a subvolume or a snapshot
> + btrfs subvolume delete /mn/snapshot_of_a_snapshot
> +
> + # look a the btrfs man page for further information
> + man btrfs
>
> btrfsck: do a limited check of the FS extent trees.</li>
>
> @@ -46,3 +57,5 @@ debug-tree: print all of the FS metadata in text
form. Example:
>
> debug-tree /dev/sda2 >& big_output_file
>
> +
> +
> diff --git a/btrfs.c b/btrfs.c
> index 46314cf..a607786 100644
> --- a/btrfs.c
> +++ b/btrfs.c
> @@ -61,6 +61,11 @@ static struct Command commands[] =3D {
> { do_subvol_list, 1, "subvolume list", "<path>\n"
> "List the snapshot/subvolume of a filesystem."
> },
> + { do_set_default_subvol, 2,
> + "subvolume set-default", "<id> <path>\n"
> + "Set the subvolume of the filesystem <path> which will be mounted\n=
"
> + "as default."
> + },
> { do_find_newer, 2, "subvolume find-new", "<path> <last_gen>\n"
> "List the recently modified files in a filesystem."
> },
> @@ -68,19 +73,15 @@ static struct Command commands[] =3D {
> "filesystem defragment", "[-vcf] [-s start] [-l len] [-t size]
<file>|<dir> [<file>|<dir>...]\n"
> "Defragment a file or a directory."
> },
> - { do_set_default_subvol, 2,
> - "subvolume set-default", "<id> <path>\n"
> - "Set the subvolume of the filesystem <path> which will be mounted\n=
"
> - "as default."
> - },
> { do_fssync, 1,
> "filesystem sync", "<path>\n"
> "Force a sync on the filesystem <path>."
> },
> { do_resize, 2,
> - "filesystem resize", "[+/-]<newsize>[gkm]|max <filesystem>\n"
> + "filesystem resize", "[<devid>:][+/-]<newsize>[gkm]|max <filesystem=
>\n"
> "Resize the file system. If 'max' is passed, the filesystem\n"
> - "will occupe all available space on the device."
> + "will occupe all available space on the device. <devid> is\n"
> + "the id of the device which grown or will shrink."
> },
> { do_show_filesystem, 999,
> "filesystem show", "[<uuid>|<label>]\n"
> @@ -89,7 +90,7 @@ static struct Command commands[] =3D {
> },
> { do_df_filesystem, 1,
> "filesystem df", "<path>\n"
> - "Show space usage information for a mount point\n."
> + "Show space usage information for a mount point."
> },
> { do_balance, 1,
> "filesystem balance", "<path>\n"
> diff --git a/man/btrfs.8.in b/man/btrfs.8.in
> index 26ef982..1997aa8 100644
> --- a/man/btrfs.8.in
> +++ b/man/btrfs.8.in
> @@ -15,18 +15,20 @@ btrfs \- control a btrfs filesystem
> .PP
> \fBbtrfs\fP \fBsubvolume set-default\fP\fI <id> <path>\fP
> .PP
> -\fBbtrfs\fP \fBfilesystem defrag\fP\fI <file>|<dir> [<file>|<dir>...=
]\fP
> +\fBbtrfs\fP \fBsubvolume find-new\fP\fI <subvolume> <last_gen>\fP
> +.PP
> +\fBbtrfs\fP \fBfilesystem balance\fP\fI <path> \fP
> +.PP
> +\fBbtrfs\fP \fBfilesystem defrag\fP\fI [-vcf] [-s start] [-l len] [-=
t
size] <file>|<dir> [<file>|<dir>...]\fP
> .PP
> \fBbtrfs\fP \fBfilesystem sync\fP\fI <path> \fP
> .PP
> -\fBbtrfs\fP \fBfilesystem resize\fP\fI [+/\-]<size>[gkm]|max
<filesystem>\fP
> +\fBbtrfs\fP \fBfilesystem resize\fP\fI [<devid>:][+/\-]<size>[gkm]|m=
ax
<filesystem>\fP
> .PP
> \fBbtrfs\fP \fBdevice scan\fP\fI [<device> [<device>..]]\fP
> .PP
> \fBbtrfs\fP \fBdevice show\fP\fI <dev>|<label> [<dev>|<label>...]\fP
> .PP
> -\fBbtrfs\fP \fBdevice balance\fP\fI <path> \fP
> -.PP
> \fBbtrfs\fP \fBdevice add\fP\fI <dev> [<dev>..] <path> \fP
> .PP
> \fBbtrfs\fP \fBdevice delete\fP\fI <dev> [<dev>..] <path> \fP]
> @@ -102,8 +104,19 @@ Set the subvolume of the filesystem \fI<path>\fR
which is mounted as
> is returned by the \fBsubvolume list\fR command.
> .TP
>
> -\fBfilesystem defragment\fP\fI <file>|<dir> [<file>|<dir>...]\fR
> +\fBsubvolume find-new\fR\fI <subvolume> <last_gen>\fR
> +List the recently modified files in a subvolume, after
\fI<last_gen>\fR ID.
> +.TP
> +
> +\fBfilesystem defragment\fP\fI [-vcf] [-s <start>] [-l <lenght>] [-t
<size>] <file>|<dir> [<file>|<dir>...]\fR
> Defragment files and/or directories.
> +The switch \fB-v\fR turns on the verbose mode.
> +The switch \fB-c\fR sets the flag compress on.
> +The switch \fB-f\fR turns on the flushing of the data.
> +The switch \fB-s\fR sets the beginning of the range to defrag.
> +The switch \fB-l\fR sets the length of the range to defrag.
> +If the switch \fB-t\fR is passed, any extent bigger than \fB<size>\f=
R is
> +considered already defragged.
> .TP
>
> \fBdevice scan\fR \fI[<device> [<device>..]]\fR
> @@ -119,7 +132,7 @@ Force a sync for the filesystem identified by
\fI<path>\fR.
> .\" Some wording are extracted by the resize2fs man page
> .\"
>
> -\fBfilesystem resize\fR\fI [+/\-]<size>[gkm]|max <path>\fR
> +\fBfilesystem resize\fR\fI [<devid>:][+/\-]<size>[gkm]|max <path>\fR
> Resize a filesystem identified by \fI<path>\fR.
> The \fI<size>\fR parameter specifies the new size of the filesystem.
> If the prefix \fI+\fR or \fI\-\fR is present the size is increased or
decreased
> @@ -136,6 +149,9 @@ The \fBresize\fR command \fBdoes not\fR manipulat=
e
the size of underlying
> partition. If you wish to enlarge/reduce a filesystem, you must make
sure you
> can expand the partition before enlarging the filesystem and shrink t=
he
> partition after reducing the size of the filesystem.
> +
> +<devid> is the ID of the device which was enlarged or which will be
reduced.
> +To know the ID of a device use the command \fBbtrfs filesystem show\=
fR.
> .TP
>
> \fBfilesystem show\fR [<uuid>|<label>]\fR
> @@ -143,7 +159,7 @@ Show the btrfs filesystem with some additional
info. If no UUID or label is
> passed, \fBbtrfs\fR show info of all the btrfs filesystem.
> .TP
>
> -\fBdevice balance\fR \fI<path>\fR
> +\fBfilesystem balance\fR \fI<path>\fR
> Balance the chunks of the filesystem identified by \fI<path>\fR
> across the devices.
> .TP
> @@ -154,6 +170,12 @@ Add device(s) to the filesystem identified by
\fI<path>\fR.
>
> \fBdevice delete\fR\fI <dev> [<dev>..] <path>\fR
> Remove device(s) from a filesystem identified by \fI<path>\fR.
> +
> +If the devices are used in RAID mode, it is not possible to reduce t=
he
> +number of the device less than the minimun number (2 devices for RAD=
I1,
> +4 devices for RAID10 ...). In this case to replace a failed device, =
it
> +is necessary first add a new one.
> +
> .PP
>
> .SH EXIT STATUS
>
>
>
>
> On Saturday, 09 October, 2010, J=E9r=F4me Poulin wrote:
>> On 13.09.2010 21:23, Goffredo Baroncelli wrote:
>>> Hi all,
>>>
>>> enclose you can find a patch which improve the help of the btrfs
>>> commands and its man page. Regarding the help of the btrfs
>>> command: - moved the "subvolume set-default" command in the
>>> "subvolume" commands group - removed a wrong new line
>>>
>>> Regarding the btrfs command man page: - renaming the command
>>> "device balance" in "filesystem balance" (thanks to Andrea Phillipp
>>> to highlight that) - adding the entry "subvolume find-new"
>>>
>>
>> Could you also document the defragment switches? At the moment, they
>> are only documented in the code, -c to compress, -f to force and -v
>> for verbose (even if verbose does not add any output other than the
>> version).
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-btrf=
s" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at http://vger.kernel.org/majordomo-info.html
>>
>
>
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (MingW32)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/
=20
iQIcBAEBAgAGBQJMsMyrAAoJEJIcBJ3+XkgilTMP/jl6ca9DEJhAbnHGUzcKYG+7
3Uywwml2LziCrj5d976HUG4QydOpW0BexPbJTNwoOKNhCBJzjUM5lhzGRAq+qtKG
+xujeLfdMKeMzs1s3J9bRvgycDwU2cPyZCF2Rp8Fc7hjK93u7mI8wWieZJ8x7kwS
PefMmG7McWiiL3whzkcAEhAukmSMIkAhFgcjBk5BbNay/7WxUKNj5aBWj8knQnNc
/1aySo/JFtd69pyvt2kNNIODIiWNdQPnvGNUNBuw0ZCsGLxk8WIZ0G+rXuv4rsS5
2apek/ZQcYQG7RlNI500E1eSk/EoC7qGiV71Z0yhFT7xVYZEtnR9vq2cMjr1e4l4
wq5DCSwtO84dUVKCV5PZYto23mq2WXyPIpTPGx0sHW+Hn6Yc+3FbBd36l5VT2DEx
A034EcxVc8yRI5GoY4tGpM2yXuW4I7zmpEyvnTH8Xj8s9gdPbr2OFyvAUD1YdjLG
X2e6g4LsfjL1gBPCYHPpzV5j+jctqCaht3xemuFZYFfvzS9DCoGSyQdQOqdQl4sf
n85fImcqJ9JdT0qROUtR6jhXJHiY9k3EffnqES2iDCAlua1MzysfibAiAMgzAPwy
=46alYbbbeC4M4r6i1O1UFDUpIePdb74ImAMqhXg+C3X3dHXdDhdvaxCcaHqasz1mN
QMVbEb0IY+KvJU+8s+uQ
=3DgJuQ
-----END PGP SIGNATURE-----

--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
