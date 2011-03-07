From: Christian Kujau <lists@nerdbynature.de>
Subject: Re: btrfs lacking inode or file count?
Date: Mon, 7 Mar 2011 09:38:58 -0800 (PST)
Message-ID: <alpine.DEB.2.01.1103070935550.23816@trent.utfs.org>
References: <4D75052D.7050704@syseleven.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: linux-btrfs@vger.kernel.org
To: Jens Rosenboom <j.rosenboom@syseleven.de>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4D75052D.7050704@syseleven.de>
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, 7 Mar 2011 at 17:17, Jens Rosenboom wrote:
> I'm just starting to do some testing with btrfs and I noticed that "df
> -i" doesn't give any sensible output:

Btrfs has dynamic inode allocation (like zfs), so it (should) never runs 
out of "available inodes" (only "out of space"). 
It's a feature, not a bug :-)

Christian.
-- 
BOFH excuse #110:

The rolling stones concert down the road caused a brown out
