From: Yuri D'Elia <wavexx@users.sf.net>
Subject: btrfs volume backup
Date: Fri, 18 Feb 2011 12:24:24 +0100
Message-ID: <20110218122424.de09f5e8.wavexx@users.sf.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Is there a way to backup/restore a btrfs volume without losing all the associated metadata? (something like xfsdump/restore?)

brtfs-image looks somewhat what one would need, except that it clears the actual data (for debugging purposes I guess?). I guess it also doesn't work on a mounted filesystem, so fixing btrfs-image would be of limited use right now.

Thanks

