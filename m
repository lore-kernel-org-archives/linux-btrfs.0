Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mo-p05-ob.rzone.de ([81.169.146.181]:45652 "EHLO
	mo-p05-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752591Ab3ABQ5g (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 2 Jan 2013 11:57:36 -0500
Message-ID: <50E466FC.1070802@jan-o-sch.net>
Date: Wed, 02 Jan 2013 17:57:32 +0100
From: Jan Schmidt <list.btrfs@jan-o-sch.net>
MIME-Version: 1.0
To: junlion@tormail.org
CC: Alex Lyakas <alex.btrfs@zadarastorage.com>, linux-btrfs@vger.kernel.org
Subject: Re: Incremental btrfs receive in opposite direction fails
References: <1ToibV-0001fD-SN@internal.tormail.org> <CAOcd+r3OjBAGbRN-cSbL7tQP=tTRYakZO3fm9gA_oqSz6KXuYw@mail.gmail.com> <1TpCWu-000Fz2-6t@internal.tormail.org>
In-Reply-To: <1TpCWu-000Fz2-6t@internal.tormail.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

I admit I haven't completely understood what you're trying to achieve. You can
only receive an incremental stream if the internal (!) file system state on the
receiver's side is the same as on the sender's. Thus I don't see where setting a
uuid to trick btrfs receive could do you any good.

On Sun, December 30, 2012 at 07:40 (+0100), junlion wrote:
> On 2012-12-29 15:00 +0200, Alex Lyakas wrote:
>> There is no special repo, but you may want, in addition to the patch
>> you mentioned, apply this one as well:
>> https://patchwork.kernel.org/patch/1604391/
> 
> Very useful! Somehow a few lines got wrapped though.
> 
>>> Is there a way for me to directly change the received_uuid of
>>> /mnt/bak/.snap to make it identical to the UUID of /.snap? This looks
>>> like the easiest way if I only need to do it once.
>> There is no implemented way, but since you debugged this far, you can
>> put up some code that sends BTRFS_IOC_SET_RECEIVED_SUBVOL, which is
>> the one setting the received_uuid (and some other small stuff, please
>> check the kernel code for it).
> 
> Ah, BTRFS_IOC_SET_RECEIVED_SUBVOL. Thanks for pointing me in the right
> direction. After some hacking, it worked without eating my data... These
> are the two commands to run before the failing one:
> 
> btrfs subvolume snapshot /mnt/bak/.snap /mnt/bak/.snap-mangled
> uu / .snap /mnt/bak/.snap-mangled
> 
> ... where uu is my crude little received_uuid and stransid display and
> adjustment tool. I've attached its source.

Still in doubt, I'd like to recommend checking with Arne's fssum tool if both
file systems are really the same now. You can fetch and build from his repository at

	git://git.kernel.org/pub/scm/linux/kernel/git/arne/far-progs.git

As a general rule, please send patches inline for people to quote them when
commenting.

> Would be cool if someone modified btrfs send/receive to handle this use
> case automatically, but it's too difficult for me.

We could completely drop the check leading to the "could not find parent
subvolume" error message, if someone explained why removing it was sensible.

Looking forward to your explanation!
-Jan
