From: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
Subject: Re: btrfs-tools source code
Date: Thu, 27 Oct 2011 09:43:26 +0900
Message-ID: <4EA8A92E.7090003@jp.fujitsu.com>
References: <4EA848A3.70108@cfl.rr.com> <20111026182653.GI29548@carfax.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
To: Hugo Mills <hugo@carfax.org.uk>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20111026182653.GI29548@carfax.org.uk>
List-ID: <linux-btrfs.vger.kernel.org>

(2011/10/27 3:26), Hugo Mills wrote:
> On Wed, Oct 26, 2011 at 01:51:31PM -0400, Phillip Susi wrote:
>> It still doesn't appear to have returned to kernel.org.  Should that
>> happen sometime soon, or is it available somewhere else now?
> 
>    If the wiki was up (which should be coming back to kernel.org in
> the next few weeks, I'm told), you'd be able to see that the latest
> version of the tools is actually available from
> 
>     http://git.darksatanic.net/repo/btrfs-progs-unstable.git/

Though the check on the number of args has been changed with the
following patch,

  commit:f71210f87e0c684d8c76dfa2e19ea86256fc3d1f
  check number of args for btrfs sub snap correctly

however, in integration-20111012, I think that returning it to an
original value is correct. 

Thanks,
Tsutomu


diff -urNp a/btrfs_cmds.c b/btrfs_cmds.c
--- a/btrfs_cmds.c	2011-10-12 19:54:48.000000000 +0900
+++ b/btrfs_cmds.c	2011-10-27 09:07:56.000000000 +0900
@@ -394,7 +394,7 @@ int do_clone(int argc, char **argv)
 			return 1;
 		}
 	}
-	if (argc - optind != 3) {
+	if (argc - optind != 2) {
 		fprintf(stderr, "Invalid arguments for subvolume snapshot\n");
 		free(argv);
 		return 1;

> 
> If you want something more recent than 6 months old, you will need
> either the for-chris branch (considered pretty stable), or the latest
> integration branch (which is the very latest bits). Gitweb access for
> browsing is at
> 
> http://git.darksatanic.net/cgi/gitweb.cgi?p=btrfs-progs-unstable.git;a=summary
> 
>    Hugo.

