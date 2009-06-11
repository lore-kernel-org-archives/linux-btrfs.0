From: Chris Mason <chris.mason@oracle.com>
Subject: Re: [BUG] Cannot Mount Btrfs Volume Created By mkfs.btrfs
	v0.18-26-g0030f1d
Date: Thu, 11 Jun 2009 09:01:15 -0400
Message-ID: <20090611130115.GC3657@think>
References: <4A30FD04.4090903@turknet.net.tr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: Tarkan Erimer <tarkan.erimer@turknet.net.tr>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4A30FD04.4090903@turknet.net.tr>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jun 11, 2009 at 03:48:04PM +0300, Tarkan Erimer wrote:
> Hi,
>
> I try to format a USB memory with a Btrfs. I can format it with  
> mkfs.btrfs without problems. But; when I try to mount it, it fails to  
> mount with the below error messages. But the USB memory works fine with  
> other filesystems (ext4, XFS etc.). So, the hardware is not faulty.


>
>
> tarkane@tarkane:~$ sudo mkfs.btrfs -d single -n 4096 /dev/sdb1
>
> WARNING! - Btrfs v0.18-26-g0030f1d IS EXPERIMENTAL
> WARNING! - see http://btrfs.wiki.kernel.org before using

Where did your btrfs-progs come from?  You're using the latest and great
utilities that create a new disk format.  You can find the new disk in
the newformat2 branch of btrfs-unstable kernel repo.

(v0.19 will be released with this today).

-chris
