From: Andreas Philipp <philipp.andreas@gmail.com>
Subject: Re: [PATCH][btrfs progs] Update/clean up btrfs help and man page
Date: Sat, 09 Oct 2010 15:46:28 +0200
Message-ID: <4CB07234.1080102@gmail.com>
References: <201009132124.09118.kreijack@libero.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: kreijack@libero.it
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <201009132124.09118.kreijack@libero.it>
List-ID: <linux-btrfs.vger.kernel.org>


-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1
 
Hi,

Today I pulled btrfs-progs-unstable from
git://git.kernel.org/pub/scm/linux/kernel/git/mason/btrfs-progs-unstable.git
and I found the patch from below still not applied. Is there a reason
for this?

Regards,
Andreas Philipp

On 13.09.2010 21:23, Goffredo Baroncelli wrote:
> Hi all,
>
> enclose you can find a patch which improve the help of the btrfs
> commands and its man page. Regarding the help of the btrfs
> command: - moved the "subvolume set-default" command in the
> "subvolume" commands group - removed a wrong new line
>
> Regarding the btrfs command man page: - renaming the command
> "device balance" in "filesystem balance" (thanks to Andrea Phillipp
> to highlight that) - adding the entry "subvolume find-new"
>
> Chris, you can pull the patch from the branch "help_cleanup" of the
> following repository.
>
> http://cassiopea.homelinux.net/git/btrfs-progs-unstable-all.git
>
> The patch is very simple: only update the man page and move some
> lines in the help of btrfs command. Comments are welcome.
>
> Regards G.Baroncelli
>
>
> diff --git a/btrfs.c b/btrfs.c index ab5e57f..1816597 100644 ---
> a/btrfs.c +++ b/btrfs.c @@ -61,6 +61,11 @@ static struct Command
> commands[] = { { do_subvol_list, 1, "subvolume list", "<path>\n"
> "List the snapshot/subvolume of a filesystem." }, + {
> do_set_default_subvol, 2, + "subvolume set-default", "<id>
> <path>\n" + "Set the subvolume of the filesystem <path> which will
> be mounted\n" + "as default." + }, { do_find_newer, 2, "subvolume
> find-new", "<path> <last_gen>\n" "List the recently modified files
> in a filesystem." }, @@ -68,11 +73,6 @@ static struct Command
> commands[] = { "filesystem defragment", "[-vcf] [-s start] [-l len]
> [-t size] <file>|<dir> [<file>|<dir>...]\n" "Defragment a file or a
> directory." }, - { do_set_default_subvol, 2, - "subvolume
> set-default", "<id> <path>\n" - "Set the subvolume of the
> filesystem <path> which will be mounted\n" - "as default." - }, {
> do_fssync, 1, "filesystem sync", "<path>\n" "Force a sync on the
> filesystem <path>." @@ -89,7 +89,7 @@ static struct Command
> commands[] = { }, { do_df_filesystem, 1, "filesystem df",
> "<path>\n" - "Show space usage information for a mount point\n." +
> "Show space usage information for a mount point." }, { do_balance,
> 1, "filesystem balance", "<path>\n" diff --git a/man/btrfs.8.in
> b/man/btrfs.8.in index 26ef982..249426c 100644 ---
> a/man/btrfs.8.in +++ b/man/btrfs.8.in @@ -15,6 +15,10 @@ btrfs \-
> control a btrfs filesystem .PP \fBbtrfs\fP \fBsubvolume
> set-default\fP\fI <id> <path>\fP .PP +\fBbtrfs\fP \fBsubvolume
> find-new\fP\fI <subvolume> <last_gen>\fP +.PP +\fBbtrfs\fP
> \fBfilesystem balance\fP\fI <path> \fP +.PP \fBbtrfs\fP
> \fBfilesystem defrag\fP\fI <file>|<dir> [<file>|<dir>...]\fP .PP
> \fBbtrfs\fP \fBfilesystem sync\fP\fI <path> \fP @@ -25,8 +29,6 @@
> btrfs \- control a btrfs filesystem .PP \fBbtrfs\fP \fBdevice
> show\fP\fI <dev>|<label> [<dev>|<label>...]\fP .PP -\fBbtrfs\fP
> \fBdevice balance\fP\fI <path> \fP -.PP \fBbtrfs\fP \fBdevice
> add\fP\fI <dev> [<dev>..] <path> \fP .PP \fBbtrfs\fP \fBdevice
> delete\fP\fI <dev> [<dev>..] <path> \fP] @@ -102,6 +104,10 @@ Set
> the subvolume of the filesystem \fI<path>\fR which is mounted as is
> returned by the \fBsubvolume list\fR command. .TP
>
> +\fBsubvolume find-new\fR\fI <subvolume> <last_gen>\fR +List the
> recently modified files in a subvolume, after \fI<last_gen>\fR ID.
> +.TP + \fBfilesystem defragment\fP\fI <file>|<dir>
> [<file>|<dir>...]\fR Defragment files and/or directories. .TP @@
> -143,7 +149,7 @@ Show the btrfs filesystem with some additional
> info. If no UUID or label is passed, \fBbtrfs\fR show info of all
> the btrfs filesystem. .TP
>
> -\fBdevice balance\fR \fI<path>\fR +\fBfilesystem balance\fR
> \fI<path>\fR Balance the chunks of the filesystem identified by
> \fI<path>\fR across the devices. .TP
>
>
>
>
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (MingW32)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/
 
iQIcBAEBAgAGBQJMsHIyAAoJEJIcBJ3+XkgiF5kQAIg4h4g6Nbo41zFo1VRxFmbA
Ba2894xl+UOQ1u+4w3D0mIzqRq55aJ0XsC1s7hMXAPO73N18epmG//I/im29h0Pj
0tOKWlVaGq+2k9zNp2nvdnD4/FCTjdrLngRVj/QRbfnADHPqMz2vXRl1pPUNY19E
Z/WHKwRmgz/ZX1xeT2A2633sR61yYjA09XOS6Zmnh4PL6KRFZzVoDo6ciOtmdJRD
faHkLbLsxkpyA/0KPAOibDSV/uRRCMqJlBmGhbv8/QIYRvRpSiTuxT6a5B+WuFLm
1nfUsZC/NupDA1iG7T3o8gPnXCClh2Z689qq/MRHXM9N9uRhY4XDaf2GzwDMCL6q
A6ciYc1SQBHR9t/ZbUbZda8/6DAviqxIjTg4+/2G9hD8EZEqxd27B27U3Jc4AJTa
HYRxvZIeZBwrGj68RAJadU6OnkgMLvPhZ+lIODEZmEeSKlyrQQOE4gIT5YELw2+J
xz51nmfgSgMpccb8vo1edZcqA8jAuO3oJPL2h9NT78D0tCYjJWzp57HTCV8v2mBR
+fmxl0fiE82NBnCbQXeqnDkAkJPAvWBIGplCk3ScoerPFeW70QbiaQiSyrH8iOaI
9GIJFT5vt9FNyclp734nWvC9AdojS4w+lGoqIVoIehpcQfBbVa4abr2BjSvTmz/h
gzep5nPQpPH7i7btDaw1
=zs3e
-----END PGP SIGNATURE-----

