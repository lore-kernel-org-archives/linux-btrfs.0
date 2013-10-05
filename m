Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ea0-f172.google.com ([209.85.215.172]:32943 "EHLO
	mail-ea0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751656Ab3JELvx (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sat, 5 Oct 2013 07:51:53 -0400
Received: by mail-ea0-f172.google.com with SMTP id r16so2291705ead.17
        for <linux-btrfs@vger.kernel.org>; Sat, 05 Oct 2013 04:51:52 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <pan$29f84$2a19071e$4190bce2$1629fe10@cox.net>
References: <CAOMFOmWzXL5G22Z7srkvXe+p+F9U7atOoiV5jRHc9i0k4kUfnA@mail.gmail.com>
	<pan$29f84$2a19071e$4190bce2$1629fe10@cox.net>
Date: Sat, 5 Oct 2013 04:51:52 -0700
Message-ID: <CAOMFOmWuEhqg4L18h+0BXo-=T7ur2dJF--FU8-=O6-zWAeDXhA@mail.gmail.com>
Subject: Re: Linux Arch: kernel BUG at fs/btrfs/inode.c:873!
From: Anatol Pomozov <anatol.pomozov@gmail.com>
To: Duncan <1i5t5.duncan@cox.net>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi

On Fri, Oct 4, 2013 at 9:42 PM, Duncan <1i5t5.duncan@cox.net> wrote:
> Anatol Pomozov posted on Fri, 04 Oct 2013 21:03:11 -0700 as excerpted:
>
>> Hi,
>>
>> I have a home server on Linux Arch (kernel 3.11.2) that uses
>> multi-device btrfs on root filesystem.
>>
>> Until recently it worked completely fine. And yesterday I rebooted it
>> and the machine did not wake up.
>>
>> I booted from a USB (kernel 3.10) and tried to mount the filesystem.
>> Here is OOPs I see
>
>> ------------[ cut here ]------------
>> [   68.126138] kernel BUG at fs/btrfs/inode.c:873!
>> [   68.126164] invalid opcode: 0000 [#1] PREEMPT SMP
>
>> The only thing that I did recently is defrag /var/log/journal files
>> (journalctl is very slow because of btrfs COW). Something like this
>> http://www.mail-archive.com/linux-btrfs@vger.kernel.org/msg24878.html
>>
>> How to fix this problem? And restore the data...
>
> I'm not a dev just a btrfs user and list regular myself, so the traces
> don't mean much to me.  However, the bit I retained in the quote above
> (especially the 0000 opcode) looks very much like a bug that should be
> fixed in kernel 3.12, with the patch queued for stable as well, but due
> to a mixup it didn't get into stable thru 3.11.4, but the mixup's
> hopefully straightened out now so with luck it'll be in 3.11.5.
>
> So the first thing I'd try is either cherrypicking the btrfs patches from
> 3.12 back to 3.11-stable, or wait for 3.11.5 and check for btrfs patches
> there, or try 3.12-rcX (rc3 is out and I guess rc4 should be out shortly
> now as I think it has been nearly a week).

Could you please give me the patch SHA1 you are talking about?

>
> With luck that'll fix it.  If not, then post back with the new kernel you
> tried and hopefully one of the devs can help.
