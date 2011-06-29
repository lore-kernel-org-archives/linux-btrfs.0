From: Hubert Kario <kario@wit.edu.pl>
Subject: [PATCH] initialize all fields of commands[] struct
Date: Wed, 29 Jun 2011 20:10:03 +0200
Message-ID: <201106292010.03582.kario@wit.edu.pl>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
To: "linux-btrfs" <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

some help messages don't use advanced help message (shown when
invoked as `btrfs command subcommand --help`)
initialize them to NULL (meaning "use regular help message").

Signed-off-by: Hubert Kario <kario@wit.edu.pl>
---
this patch is for the branch integration-20110626 in 
http://git.darksatanic.net/repo/btrfs-progs-unstable.git/ integration-20110626

 btrfs.c |   18 ++++++++++++------
 1 files changed, 12 insertions(+), 6 deletions(-)

diff --git a/btrfs.c b/btrfs.c
index e117172..8875911 100644
--- a/btrfs.c
+++ b/btrfs.c
@@ -132,29 +132,35 @@ static struct Command commands[] = {
        },
        { do_balance_cancel, 1,
          "balance cancel", "<path>\n"
-               "Cancel the balance operation running on <path>."
+               "Cancel the balance operation running on <path>.",
+          NULL
        },
        { do_scrub_start, -1,
          "scrub start", "[-Bdqr] <path>|<device>\n"
-               "Start a new scrub."
+               "Start a new scrub.",
+          NULL
        }, 
        { do_scrub_cancel, 1,
          "scrub cancel", "<path>|<device>\n"
-               "Cancel a running scrub."
+               "Cancel a running scrub.",
+          NULL
        }, 
        { do_scrub_resume, -1,
          "scrub resume", "[-Bdqr] <path>|<device>\n"
-               "Resume previously canceled or interrupted scrub."
+               "Resume previously canceled or interrupted scrub.",
+          NULL
        }, 
        { do_scrub_status, -1,
          "scrub status", "[-d] <path>|<device>\n"
-               "Show status of running or finished scrub."
+               "Show status of running or finished scrub.",
+          NULL
        }, 
        { do_change_label, -1,
          "filesystem label", "<device> [<newlabel>]\n"
          "With one argument, get the label of filesystem on <device>.\n"
          "If <newlabel> is passed, set the filesystem label to <newlabel>.\n"
-         "The filesystem must be unmounted.\n"
+         "The filesystem must be unmounted.\n",
+          NULL
        },
        { do_scan, 999,
          "device scan", "[--all-devices|<device> [<device>..]\n"
-- 
1.7.5.1
