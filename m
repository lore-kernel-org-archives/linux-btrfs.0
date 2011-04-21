From: CACook@quantum-sci.com
Subject: How Snapshots Inter-relate?
Date: Thu, 21 Apr 2011 10:17:52 -0700
Message-ID: <201104211017.52341.CACook@quantum-sci.com>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>


I have set up a backup server in the garage which does rsync backups of all my servers weekly, and snapshots those backups.  It works wonderfully, and I was able to set it up thanks to help from this listserv, thank you.

But I'm accumulating quite a few backups now, unnecessarily.  After a couple months I only need a representative one, once a month.  I am afraid to delete three of my weekly snapshots out of each month, as I'm afraid they're cumulative.  I might end up with nothing valid if each builds on the last, forever.

How do I resolve this?

