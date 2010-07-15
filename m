From: Johannes Hirte <johannes.hirte@fem.tu-ilmenau.de>
Subject: Re: kernel BUG at fs/btrfs/extent-tree.c:1353
Date: Thu, 15 Jul 2010 20:14:51 +0200
Message-ID: <201007152014.52924.johannes.hirte@fem.tu-ilmenau.de>
References: <201007081627.24654.johannes.hirte@fem.tu-ilmenau.de> <201007141725.24507.johannes.hirte@fem.tu-ilmenau.de> <20100715001104.GF30737@dastard>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Cc: Chris Mason <chris.mason@oracle.com>, linux-kernel@vger.kernel.org,
	linux-btrfs@vger.kernel.org, zheng.yan@oracle.com,
	Jens Axboe <axboe@kernel.dk>, linux-fsdevel@vger.kernel.org
To: Dave Chinner <david@fromorbit.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20100715001104.GF30737@dastard>
List-ID: <linux-btrfs.vger.kernel.org>

Am Donnerstag 15 Juli 2010, 02:11:04 schrieb Dave Chinner:
> On Wed, Jul 14, 2010 at 05:25:23PM +0200, Johannes Hirte wrote:
> > Am Donnerstag 08 Juli 2010, 16:31:09 schrieb Chris Mason:
> > I'm not sure if btrfs is to blame for this error. After the errors I
> > switched to XFS on this system and got now this error:
> > 
> > ls -l .kde4/share/apps/akregator/data/
> > ls: cannot access .kde4/share/apps/akregator/data/feeds.opml: Structure
> > needs cleaning
> > total 4
> > ?????????? ? ?    ?        ?            ? feeds.opml
> 
> What is the error reported in dmesg when the XFS filesytem shuts down?

Nothing. I double checked the logs. There are only the messages when mounting 
the filesystem. No other errors are reported than the inaccessible file and the 
output from xfs_check.

regards,
  Johannes
