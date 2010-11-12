From: Hugo Mills <hugo-lkml@carfax.org.uk>
Subject: Re: [PATCH v2 2/2] Cancel filesystem balance.
Date: Fri, 12 Nov 2010 17:59:36 +0000
Message-ID: <20101112175936.GA2339@selene>
References: <cover.1289522188.git.hugo@carfax.org.uk>
 <9b18b334410714aba2867f96e949f19243536ddc.1289522188.git.hugo@carfax.org.uk>
 <4CDC9971.6080903@cn.fujitsu.com>
 <4CDCC258.1050402@csamuel.org>
 <20101112113655.GA2377@selene>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ZGiS0Q5IWpPtfppv"
To: Chris Samuel <chris@csamuel.org>, Li Zefan <lizf@cn.fujitsu.com>,
	linux-btrfs@vger.kernel.org,
	Goffredo Baroncelli <kreijack@libero.it>,
	Chris Mason <chris.mason@oracle.com>,
	liubo <
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20101112113655.GA2377@selene>
List-ID: <linux-btrfs.vger.kernel.org>


--ZGiS0Q5IWpPtfppv
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Nov 12, 2010 at 11:36:55AM +0000, Hugo Mills wrote:
> On Fri, Nov 12, 2010 at 03:28:08PM +1100, Chris Samuel wrote:
> > On 12/11/10 12:33, Li Zefan wrote:
> > 
> > > Is there any blocker that prevents us from canceling balance
> > > by just Ctrl+C ?
> > 
> > Given that there's been at least 1 report of it taking 12 hours
> > to balance a non-trivial amount of data I suspect putting this
> > operation into the background by default and having the cancel
> > option might be a better plan.
> 
>    Only 12 hours? Last time I tried it, it took 19. :)
> 
>    It would certainly be easy enough to fork a copy of the userspace
> tool to run the ioctl in the background. Probably a little more work
> to make the balance a kernel thread. I'd prefer the former, for
> ease of implementation.

   How's this?


This patch makes a balance operation fork and detach from the current
terminal, to run the userspace side of the balance in the background.

Introduce a --wait switch so that a synchronous balance can be done if
the user requires.

Signed-off-by: Hugo Mills <hugo@carfax.org.uk>
---
 btrfs.c        |    8 ++++----
 btrfs_cmds.c   |   56 +++++++++++++++++++++++++++++++++++++++++++++++++++++---
 man/btrfs.8.in |    2 +-
 3 files changed, 58 insertions(+), 8 deletions(-)

diff --git a/btrfs.c b/btrfs.c
index 93f7886..7b42658 100644
--- a/btrfs.c
+++ b/btrfs.c
@@ -91,12 +91,12 @@ static struct Command commands[] = {
 	  "filesystem df", "<path>\n"
 		"Show space usage information for a mount point\n."
 	},
-	{ do_balance, 1,
-	  "filesystem balance", "<path>\n"
+	{ do_balance, -1,
+	  "filesystem balance", "[-w|--wait] <path>\n"
 		"Balance the chunks across the device."
 	},
-	{ do_balance, 1,
-	  "balance start", "<path>\n"
+	{ do_balance, -1,
+	  "balance start", "[-w|--wait] <path>\n"
 		"Synonym for \"btrfs filesystem balance\"."
 	},
 	{ do_balance_progress, -1,
diff --git a/btrfs_cmds.c b/btrfs_cmds.c
index d246a8b..13be603 100644
--- a/btrfs_cmds.c
+++ b/btrfs_cmds.c
@@ -754,12 +754,41 @@ int do_add_volume(int nargs, char **args)
 
 }
 
+const struct option balance_options[] = {
+	{ "wait", 0, NULL, 'w' },
+	{ NULL, 0, NULL, 0 }
+};
+
 int do_balance(int argc, char **argv)
 {
-
 	int	fdmnt, ret=0;
+	int background = 1;
 	struct btrfs_ioctl_vol_args args;
-	char	*path = argv[1];
+	char *path;
+	int ttyfd;
+
+	optind = 1;
+	while(1) {
+		int c = getopt_long(argc, argv, "w", balance_options, NULL);
+		if (c < 0)
+			break;
+		switch(c) {
+		case 'w':
+			background = 0;
+			break;
+		default:
+			fprintf(stderr, "Invalid arguments for balance\n");
+			free(argv);
+			return 1;
+		}
+	}
+
+	if(optind >= argc) {
+		fprintf(stderr, "No filesystem path given for balance\n");
+		return 1;
+	}
+
+	path = argv[optind];
 
 	fdmnt = open_file_or_dir(path);
 	if (fdmnt < 0) {
@@ -767,8 +796,29 @@ int do_balance(int argc, char **argv)
 		return 12;
 	}
 
+	if (background) {
+		int pid = fork();
+		if (pid == 0) {
+			/* We're in the child, and can run in the background */
+			ttyfd = open("/dev/tty", O_RDWR);
+			if (ttyfd > 0)
+				ioctl(ttyfd, TIOCNOTTY, 0);
+			/* Fall through to the BTRFS_IOC_BALANCE ioctl */
+		} else if (pid > 0) {
+			/* We're in the parent, and the fork succeeded */
+			printf("Background balance started\n");
+			return 0;
+		} else {
+			/* We're in the parent, and the fork failed */
+			fprintf(stderr, "ERROR: can't start background process -- %s\n",
+					strerror(errno));
+		}
+	}
+
 	memset(&args, 0, sizeof(args));
-	ret = ioctl(fdmnt, BTRFS_IOC_BALANCE, &args);
+	printf("ioctl\n");
+	sleep(60);
+	/* ret = ioctl(fdmnt, BTRFS_IOC_BALANCE, &args); */
 	close(fdmnt);
 	if(ret<0){
 		fprintf(stderr, "ERROR: balancing '%s'\n", path);
diff --git a/man/btrfs.8.in b/man/btrfs.8.in
index 3f7642e..1410aaa 100644
--- a/man/btrfs.8.in
+++ b/man/btrfs.8.in
@@ -27,7 +27,7 @@ btrfs \- control a btrfs filesystem
 .PP
 \fBbtrfs\fP \fBdevice show\fP\fI <dev>|<label> [<dev>|<label>...]\fP
 .PP
-\fBbtrfs\fP \fBdevice balance\fP\fI <path> \fP
+\fBbtrfs\fP \fBdevice balance\fP [\fB-w\fP|\fB--wait\fP] \fI<path>\fP
 .PP
 \fBbtrfs\fP \fBdevice add\fP\fI <dev> [<dev>..] <path> \fP
 .PP

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
    --- Turning,  pages turning in the widening bath, / The spine ---    
        cannot bear the humidity. / Books fall apart; the binding        
            cannot hold. / Page 129 is loosed upon the world.            

--ZGiS0Q5IWpPtfppv
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iD8DBQFM3YCIIKyzvlFcI40RAkt8AJ4kYLE9OEQmFmmeBkJESjzEwOJi9wCfRr46
3au8MD9zetJphu3UduEVgOg=
=yx86
-----END PGP SIGNATURE-----

--ZGiS0Q5IWpPtfppv--
