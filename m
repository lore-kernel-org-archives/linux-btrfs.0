From: "krzf83@gmail.com " <krzf83@gmail.com>
Subject: recursive subvolume delete
Date: Sun, 2 Oct 2011 16:38:21 +0200
Message-ID: <CAJ1PRS=7HGupXFP1ma-rTyFnxvtCge2Ajipg1wLmGhZTAuDKrg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

btrfs is missing recursive subvolume delete. You can't delete
subvolume if there is other subvolumes/snapshots in it. Also I think
there are no real tools to find out which directories are
subvolumes/snapshots
