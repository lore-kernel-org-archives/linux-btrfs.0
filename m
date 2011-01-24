From: Josef Bacik <josef@redhat.com>
Subject: ENOSPC fixes
Date: Mon, 24 Jan 2011 16:43:17 -0500
Message-ID: <1295905400-1417-1-git-send-email-josef@redhat.com>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

We were failing xfstests 224 by either hanging or failing to remove files.
These patches fix it so that we can now pass 224.  The first patch is obvious,
and the 2nd one is as well, but the 3rd one could use a good hard look.  Thanks,

Josef
