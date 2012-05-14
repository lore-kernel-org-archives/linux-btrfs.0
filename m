From: David Sterba <dave@jikos.cz>
Subject: Re: Subdirectory creation on snapshot
Date: Mon, 14 May 2012 18:27:07 +0200
Message-ID: <20120514162707.GA24394@twin.jikos.cz>
References: <821DC50D-8451-4AD1-8CCA-DE1238D4788B@gmail.com>
 <20120509165802.GN19331@twin.jikos.cz>
 <F39B4ABB-65D7-467D-BB57-FD9EBB70F1FB@gmail.com>
 <20120514120852.GH25501@twin.jikos.cz>
Reply-To: dave@jikos.cz
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Brendan Smithyman <smithyman@gmail.com>, dave@jikos.cz,
	linux-btrfs@vger.kernel.org, miaox@cn.fujitsu.com
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20120514120852.GH25501@twin.jikos.cz>
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, May 14, 2012 at 02:08:52PM +0200, David Sterba wrote:
> Seems more like a bug, let's narrow down the conditions before we look
> into the code.

And already known bug (with a proposed fix, cc'd author):

http://www.spinics.net/lists/linux-btrfs/msg15195.html

Quoting:

 # mkfs.btrfs /dev/sda1
 # mount /dev/sda1 /mnt
 # mkdir /mnt/1
 # cd /mnt/1
 # btrfs subvolume snapshot /mnt snap0
 # ll /mnt/1
 total 0
 drwxr-xr-x 1 root root 10 Jun 30 15:01 1
			^^^
 # ll /mnt/1/snap0/
 total 0
 drwxr-xr-x 1 root root 10 Jun 30 15:01 1
			^^^
			It is also 10, but...
 # ll /mnt/1/snap0/1
 total 0
 [None]
 # cd /mnt/1/snap0/1/snap0
 [Enter a unexisted directory successfully]
---

Though there's a difference, that in your listing the @working (here
it'd be snap0) is present.


david
