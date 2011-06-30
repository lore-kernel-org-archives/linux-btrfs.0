From: Stephane Chazelas <stephane.chazelas@gmail.com>
Subject: [PATCH] [btrfs-progs integration] incorrect argument checking for
	"btrfs sub snap -r"
Date: Thu, 30 Jun 2011 13:34:38 +0100
Message-ID: <chaz20110630123438.GE28702@seebyte.com>
References: <chaz20110629143747.GA28702@seebyte.com> <chaz20110629150041.GB28702@seebyte.com> <4E0BC7AA.7000709@cn.fujitsu.com> <chaz20110630084046.GC28702@seebyte.com> <4E0C3F72.5040508@gmail.com> <chaz20110630104340.GD28702@seebyte.com> <20110630105813.GD11170@carfax.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: Hugo Mills <hugo@carfax.org.uk>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20110630105813.GD11170@carfax.org.uk>
List-ID: <linux-btrfs.vger.kernel.org>

Looks like this was missing in integration-20110626 for the
readonly snapshot patch:

diff --git a/btrfs.c b/btrfs.c
index e117172..be6ece5 100644
--- a/btrfs.c
+++ b/btrfs.c
@@ -49,7 +49,7 @@ static struct Command commands[] = {
 	/*
 		avoid short commands different for the case only
 	*/
-	{ do_clone, 2,
+	{ do_clone, -1,
 	  "subvolume snapshot", "[-r] <source> [<dest>/]<name>\n"
 		"Create a writable/readonly snapshot of the subvolume <source> with\n"
 		"the name <name> in the <dest> directory.",

Without that, "btrfs sub snap -r x y" would fail as it's not *2*
arguments.

-- 
Stephane
