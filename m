From: Miao Xie <miaox@cn.fujitsu.com>
Subject: Re: [RFC PATCH 1/2] vfs: add an interface to do some preparation
 for umount
Date: Thu, 22 Mar 2012 13:07:19 +0800
Message-ID: <4F6AB387.5010800@cn.fujitsu.com>
References: <4F6A98CB.1070308@cn.fujitsu.com> <20120322034109.GU6589@ZenIV.linux.org.uk>
Reply-To: miaox@cn.fujitsu.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Chris Mason <chris.mason@oracle.com>,
	Linux Fsdevel <linux-fsdevel@vger.kernel.org>,
	Linux Btrfs <linux-btrfs@vger.kernel.org>
To: Al Viro <viro@ZenIV.linux.org.uk>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20120322034109.GU6589@ZenIV.linux.org.uk>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, 22 Mar 2012 03:41:09 +0000, Al Viro wrote:
> On Thu, Mar 22, 2012 at 11:13:15AM +0800, Miao Xie wrote:
>> Some file systems can do some works in the background by kthreads, we'd
>> better stop those works before we umount the file system, or it is easy to
>> introduce some problems. So we add an interface that is used to do some
>> preparation for umount.
> 
> NAK.  First of all, fs might be in active use _after_ umount.  man 8 umount,
> see umount -l there.  Moreover, the same superblock may very well be mounted
> more than once, so umount of an individual mountpoint would better not do
> anything nasty to users of other ones.
> 
> IOW, this is completely misguided - you are dealing with whatever problem it
> is at least two layers above the right one.
> 
> 1) vfsmount may be detached from mount trees but remain in active use.
> 2) there may be many vfsmounts over given struct super_block.
> 
> Doing things earlier than the final mntput() runs afoul of (1); doing
> them before the final deactivate_locked_super() runs afoul of (2).
> 
> What the hell is that thread doing that needs ->s_umount for serialization
> and why is it doing that?

AFAIK, acquiring ->s_umount is to avoid the filesystem going from r/w to r/o.

This is patch is slapdash, I will find another way to deal with the bug we found.

Thanks for your review.

Miao
