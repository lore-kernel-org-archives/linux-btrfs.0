From: David Nicol <davidnicol@gmail.com>
Subject: IOCTL #21 could also wait for btrfs_run_delayed_iputs
Date: Mon, 18 Oct 2010 12:32:15 -0500
Message-ID: <AANLkTinoaCGVbhfv+LtqwRi4_nXZTaFNcFxaaqsknKf5@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: BTRFS MAILING LIST <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

That's the other thing the cleaner_kthread does; conceivably some new
delayed iputs could get queued during snapshot deletions.

Thoughts?

-- 
"In one instance, a rai being transported by canoe was accidentally
dropped and sunk to the sea floor. Although it was never seen again,
everyone agreed that the rai must still be there, so it continued to
be transacted as genuine currency" -- Wikipedia
