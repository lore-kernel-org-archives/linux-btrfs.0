Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:52622 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752114Ab3JKOpA (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 11 Oct 2013 10:45:00 -0400
Message-ID: <52580EE5.8090408@redhat.com>
Date: Fri, 11 Oct 2013 09:44:53 -0500
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
To: Duncan <1i5t5.duncan@cox.net>
CC: linux-btrfs@vger.kernel.org
Subject: Re: BUG relating to fstrim on btrfs partitions
References: <20131010102043.74230@gmx.com> <pan$d3f39$3d6ac9b9$db7362c7$80c1ae2b@cox.net>
In-Reply-To: <pan$d3f39$3d6ac9b9$db7362c7$80c1ae2b@cox.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 10/10/13 6:39 AM, Duncan wrote:
> Mike Audia posted on Thu, 10 Oct 2013 06:20:42 -0400 as excerpted:
> 
>> I think I found a bug affecting btrfs filesystems and users invoking
>> fstrim to discard unused blocks: if I execute a `fstrim -v /` twice, the
>> amount trimmed does not change on the 2nd invocation AND it takes just
>> as long as the first.  Why do I think this is a bug?  When I do the same
>> on an ext4 partition I get different behavior: the output shows 0 B
>> trimmed and it does is instantaneously when I run it a 2nd time.  After
>> contacting the fstrim developer, he stated that the userspace part
>> (fstrim) does only one thing and it is invoke an ioctl (FITRIM); it is
>> the job of the filesystem to properly implement this.
> 
> This behavior is documented in the fstrim manpage under -v/--verbose:
> 
>>>> When [--verbose is] specified fstrim will output the number of bytes
>>>> passed from the filesystem down the block stack to the device for
>>>> potential discard. This number is a maximum discard amount from the
>>>> storage device's perspective, because FITRIM ioctl called repeated
>>>> will keep sending the same sectors for discard repeatedly.
>>>>
>>>> fstrim will report the same potential discard bytes each time, but
>>>> only sectors which had been written to between the discards would
>>>> actually be discarded by the storage device.
> 
> Why ext4 behavior doesn't conform to that fstrim documentation I can't 
> say (except by stating the obvious that the ext4 filesystem 
> implementation of that ioctl obviously does it differently, but why... 
> you'd have to either ask the ext4 folks or read its docs/sources), but 
> given that fstrim documentation, the btrfs behavior is certainly NOTABUG 
> as it's simply conforming to the documentation.

ext4 is conforming just fine.

"fstrim will output the number of bytes passed from the filesystem down
the block stack to the device for potential discard."

It reports the number of bytes passed *from the filesystem* to the block
device for discard, not the total range requested by the user.

If the filesystem is clever enough to know that the range in question has
not been written to since the last discard, then it takes no action, and
reports zero bytes.

So it sounds like btrfs doesn't maintain this "already discarded" state,
and will "re-discard" unused regions every time fstrim is issued.

Not a bug per se, but not really optimized.

-Eric
