Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ve0-f181.google.com ([209.85.128.181]:57045 "EHLO
	mail-ve0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751197AbaFFSbi (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 6 Jun 2014 14:31:38 -0400
Received: by mail-ve0-f181.google.com with SMTP id pa12so3684797veb.40
        for <linux-btrfs@vger.kernel.org>; Fri, 06 Jun 2014 11:31:38 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAL3q7H7TD8FvFwVEx+A9ABEXhQW-C2yuNr6mga+XH9uMyMt+Qw@mail.gmail.com>
References: <20140606204009.261e8ec3@natsu>
	<CAL3q7H7TD8FvFwVEx+A9ABEXhQW-C2yuNr6mga+XH9uMyMt+Qw@mail.gmail.com>
Date: Fri, 6 Jun 2014 19:31:37 +0100
Message-ID: <CALOYprW2R7iN0j=M6py0pbOkibbyob5L7KXHtmT92-32wVYMdw@mail.gmail.com>
Subject: Re: btrfs module dependencies broken in 3.14?
From: WorMzy Tykashi <wormzy.tykashi@gmail.com>
To: Filipe Manana <fdmanana@gmail.com>
Cc: Roman Mamedov <rm@romanrm.net>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 6 June 2014 16:41, Filipe David Manana <fdmanana@gmail.com> wrote:
> On Fri, Jun 6, 2014 at 3:40 PM, Roman Mamedov <rm@romanrm.net> wrote:
>> Hello,
>>
>> Not sure if this has been reported somewhere closer to Btrfs development, and
>> not just in Debian... Anyways, just now I (also) hit this bug when upgrading my
>> kernel from 3.12.21 to 3.14.5 on one machine (but not on a number of others):
>>
>>   https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=747929
>>
>> I use btrfs as my root FS, and the error early in the initramfs stage, is
>> along the lines of:
>>
>>> FATAL: Error inserting btrfs...: Unknown symbol in
>>> module, or unknown parameter (see dmesg)
>>
>> (noting in dmesg).
>>
>> The workaround has been detailed back in 2010:
>> https://lists.debian.org/debian-user/2010/06/msg02060.html
>>
>> After adding "crc32c" into /etc/initramfs-tools/modules (for forced inclusion
>> into the initramfs) and regenerating the initramfs image, the btrfs module
>> started loading fine.
>>
>> Interesting why this problem from 2010 has resurfaced in 3.14, with 3.12
>> working normally. Also why not every machine with a similar setup is affected
>> (I have several hosts with btrfs root, although both hardware and software
>> configurations are not identical but quite diverse), but as I said just one
>> for me.
>
> Hi Roman,
>
> This thread might help:  http://www.spinics.net/lists/linux-btrfs/msg32187.html
> Since WorMzy went through similar problem(s), he might provide more
> recommendations.
>
>
>>
>> --
>> With respect,
>> Roman
>
>
>
> --
> Filipe David Manana,
>
> "Reasonable men adapt themselves to the world.
>  Unreasonable men adapt the world to themselves.
>  That's why all progress depends on unreasonable men."

Hi,

My solution was to write a patch for mkinitcpio (Arch initrd creation
tool) [1] so that it explicitly adds the crc32c module to the initrd
if btrfs is needed. I imagine it wouldn't be difficult to add the same
logic to debian's initrd creation tool. IIRC it already does something
similar in other cases where there's an invisible dependency like
this.

Cheers,

WorMzy

P.S. Apologies if you receive this twice, I foolishly assumed that the
gmail app on my android phone would send a plain text message as plain
text!

[1] https://mailman.archlinux.org/pipermail/arch-projects/2014-March/004093.html
