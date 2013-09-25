Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:38109 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755502Ab3IYAsc (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 24 Sep 2013 20:48:32 -0400
Message-ID: <524232DD.60202@redhat.com>
Date: Tue, 24 Sep 2013 19:48:29 -0500
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
To: vgrvelu <vgrajan2005@gmail.com>
CC: linux-btrfs@vger.kernel.org
Subject: Re: hi
References: <CALe5Emw4u1g2XPet5goM5V3YFbb4isqA4OTecR9RxnD7gxZr7g@mail.gmail.com>
In-Reply-To: <CALe5Emw4u1g2XPet5goM5V3YFbb4isqA4OTecR9RxnD7gxZr7g@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 9/24/13 6:39 PM, vgrvelu wrote:
> hi
> 
> I created  btrfs file system  on one of  sda partition. when I mount
> with mount -t /dev/sda17  /btrfs,

# mount -t /dev/sda17 /btrfs?

That doesn't work.  Maybe you meant :

# mount -t btrfs /dev/sda17 /btrfs ?

> it is failing with wrong fs type bad option. when i see the dmesg,
> mount command is searching  for ext3, ext2 filesystem on sda17. but
> not btrfs.
> even in the man page of mount, btrfs is not mentioned as supported
> file system type.
> 
> Please help me to solve this issue.

does your kernel support btrfs?  Sounds like maybe not.

To load it in case it's a module:
# modprobe btrfs

then see if the kernel even knows what btrfs is, either via the
module, or due to being built into the kernel image already:

# grep btrfs /proc/filesystems

The first cmd might fail if it's built into the kernel, but if that's
the reason, the 2nd one should find btrfs in /proc/filesystems...

If not, you need a kernel that supports btrfs.

-Eric
 
> thanks
> rajan
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

