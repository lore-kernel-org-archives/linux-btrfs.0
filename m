From: Alexandre Oliva <oliva@lsd.ic.unicamp.br>
Subject: Re: Introduce option to rebalance only metadata
Date: Thu, 10 Nov 2011 17:42:51 -0200
Message-ID: <ormxc3pxvo.fsf@livre.localdomain>
References: <orr51fpxyv.fsf@livre.localdomain>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-=-="
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <orr51fpxyv.fsf@livre.localdomain> (Alexandre Oliva's message of
	"Thu, 10 Nov 2011 17:40:56 -0200")
List-ID: <linux-btrfs.vger.kernel.org>

--=-=-=

On Nov 10, 2011, Alexandre Oliva <oliva@lsd.ic.unicamp.br> wrote:

> Experimental patch to be able to compact only the metadata after
> clustered allocation allocated lots of unnecessary metadata block
> groups.  It's also useful to measure performance differences between
> -o cluster and -o nocluster.

> I guess it should be implemented as a balance option rather than a
> separate ioctl, but this was good enough for me to try it.

And here's a corresponding patch for the btrfs program, on a (probably
very old) btrfs-progs tree.


--=-=-=
Content-Type: text/x-diff
Content-Disposition: inline;
 filename=0001-Introduce-balance-md-to-balance-metadata-only.patch

>From 8765d64f95966eec28cad83bd870fc2270afaebd Mon Sep 17 00:00:00 2001
From: Alexandre Oliva <lxoliva@fsfla.org>
Date: Thu, 10 Nov 2011 17:35:29 -0200
Subject: [PATCH] Introduce balance-md to balance metadata only.

Patch for btrfs to use a separate experimental IOCTL to rebalance
only metadata block groups.

Signed-off-by: Alexandre Oliva <oliva@lsd.ic.unicamp.br>
---
 btrfs.c      |    4 ++++
 btrfs_cmds.c |   25 +++++++++++++++++++++++++
 btrfs_cmds.h |    1 +
 ioctl.h      |    3 +++
 4 files changed, 33 insertions(+), 0 deletions(-)

diff --git a/btrfs.c b/btrfs.c
index 46314cf..9edaebe 100644
--- a/btrfs.c
+++ b/btrfs.c
@@ -95,6 +95,10 @@ static struct Command commands[] = {
 	  "filesystem balance", "<path>\n"
 		"Balance the chunks across the device."
 	},
+	{ do_balance_md, 1,
+	  "filesystem balance-md", "<path>\n"
+		"Balance the chunks across the device."
+	},
 	{ do_scan,
 	  999, "device scan", "[<device> [<device>..]\n"
 		"Scan all device for or the passed device for a btrfs\n"
diff --git a/btrfs_cmds.c b/btrfs_cmds.c
index 8031c58..b8f4c05 100644
--- a/btrfs_cmds.c
+++ b/btrfs_cmds.c
@@ -776,6 +776,31 @@ int do_balance(int argc, char **argv)
 	}
 	return 0;
 }
+
+int do_balance_md(int argc, char **argv)
+{
+
+	int	fdmnt, ret=0;
+	struct btrfs_ioctl_vol_args args;
+	char	*path = argv[1];
+
+	fdmnt = open_file_or_dir(path);
+	if (fdmnt < 0) {
+		fprintf(stderr, "ERROR: can't access to '%s'\n", path);
+		return 12;
+	}
+
+	memset(&args, 0, sizeof(args));
+	ret = ioctl(fdmnt, BTRFS_IOC_BALANCE_METADATA, &args);
+	close(fdmnt);
+	if(ret<0){
+		fprintf(stderr, "ERROR: balancing '%s'\n", path);
+
+		return 19;
+	}
+	return 0;
+}
+
 int do_remove_volume(int nargs, char **args)
 {
 
diff --git a/btrfs_cmds.h b/btrfs_cmds.h
index 7bde191..96cab6d 100644
--- a/btrfs_cmds.h
+++ b/btrfs_cmds.h
@@ -23,6 +23,7 @@ int do_defrag(int argc, char **argv);
 int do_show_filesystem(int nargs, char **argv);
 int do_add_volume(int nargs, char **args);
 int do_balance(int nargs, char **argv);
+int do_balance_md(int nargs, char **argv);
 int do_remove_volume(int nargs, char **args);
 int do_scan(int nargs, char **argv);
 int do_resize(int nargs, char **argv);
diff --git a/ioctl.h b/ioctl.h
index 776d7a9..5210c0b 100644
--- a/ioctl.h
+++ b/ioctl.h
@@ -169,4 +169,7 @@ struct btrfs_ioctl_space_args {
 #define BTRFS_IOC_DEFAULT_SUBVOL _IOW(BTRFS_IOCTL_MAGIC, 19, u64)
 #define BTRFS_IOC_SPACE_INFO _IOWR(BTRFS_IOCTL_MAGIC, 20, \
 				    struct btrfs_ioctl_space_args)
+
+#define BTRFS_IOC_BALANCE_METADATA _IOW(BTRFS_IOCTL_MAGIC, 37, \
+					struct btrfs_ioctl_vol_args)
 #endif
-- 
1.7.4.4


--=-=-=



-- 
Alexandre Oliva, freedom fighter    http://FSFLA.org/~lxoliva/
You must be the change you wish to see in the world. -- Gandhi
Be Free! -- http://FSFLA.org/   FSF Latin America board member
Free Software Evangelist      Red Hat Brazil Compiler Engineer

--=-=-=--
