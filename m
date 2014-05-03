Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vc0-f182.google.com ([209.85.220.182]:36641 "EHLO
	mail-vc0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751012AbaECNbB (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sat, 3 May 2014 09:31:01 -0400
Received: by mail-vc0-f182.google.com with SMTP id lf12so6834677vcb.27
        for <linux-btrfs@vger.kernel.org>; Sat, 03 May 2014 06:31:00 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <loom.20140502T194216-357@post.gmane.org>
References: <CAOwjQU4GP5PjdPZx8HPihS7GQOA74M+DexwMWoh1FOQP0tCTcw@mail.gmail.com>
	<pan$ba09e$4b80fc30$5f891c70$5774c32f@cox.net>
	<loom.20140502T194216-357@post.gmane.org>
Date: Sat, 3 May 2014 09:31:00 -0400
Message-ID: <CAC4gV=5QTAvPXm+66ZKcRoSvCh=Zp12iUkz2LcufF1s84sUGHA@mail.gmail.com>
Subject: Re:
From: Frank Holton <fholton@gmail.com>
To: Jaap Pieroen <jaap@pieroen.nl>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Jaap,

This patch http://www.spinics.net/lists/linux-btrfs/msg33025.html made
it into 3.15 RC2 so if you're willing to build your own RC kernel you
may have better luck with scrub in 3.15. The patch only scrubs the
data blocks in RAID5/6 so hopefully your parity blocks are intact. I'm
not sure if it would help any but it may be worth a try.

On Fri, May 2, 2014 at 1:48 PM, Jaap Pieroen <jaap@pieroen.nl> wrote:
> Duncan <1i5t5.duncan <at> cox.net> writes:
>
>>
>> To those that know the details, this tells the story.
>>
>> Btrfs raid5/6 modes are not yet code-complete, and scrub is one of the
>> incomplete bits.  btrfs scrub doesn't know how to deal with raid5/6
>> properly just yet.
>>
>> While the operational bits of raid5/6 support are there, parity is
>> calculated and written, scrub, and recovery from a lost device, are not
>> yet code complete.  Thus, it's effectively a slower, lower capacity raid0
>> without scrub support at this point, except that when the code is
>> complete, you'll get an automatic "free" upgrade to full raid5 or raid6,
>> because the operational bits have been working since they were
>> introduced, just the recovery and scrub bits were bad, making it
>> effectively a raid0 in reliability terms, lose one and you've lost them
>> all.
>>
>> That's the big picture anyway.  Marc Merlin recently did quite a bit of
>> raid5/6 testing and there's a page on the wiki now with what he found.
>> Additionally, I saw a scrub support for raid5/6 modes patch on the list
>> recently, but while it may be in integration, I believe it's too new to
>> have reached release yet.
>>
>> Wiki, for memory or bookmark: https://btrfs.wiki.kernel.org
>>
>> Direct user documentation link for bookmark (unwrap as necessary):
>>
>> https://btrfs.wiki.kernel.org/index.php/
>> Main_Page#Guides_and_usage_information
>>
>> The raid5/6 page (which I didn't otherwise see conveniently linked, I dug
>> it out of the recent changes list since I knew it was there from on-list
>> discussion):
>>
>> https://btrfs.wiki.kernel.org/index.php/RAID56
>>
>>  <at>  Marc or Hugo or someone with a wiki account:  Can this be more visibly
>> linked from the user-docs contents, added to the user docs category list,
>> and probably linked from at least the multiple devices and (for now) the
>> gotchas pages?
>>
>
> So raid5 is much more useless than I assumed. I read Marc's blog and
> figured that btrfs was ready enough.
>
> I' really in trouble now. I tried to get rid of raid5 by doing a convert
> balance to raid1. But of course this triggered the same issue. And now
> I have a dead system because the first thing btrfs does after mounting
> is continue the balance which will crash the system and send me into
> a vicious loop.
>
> - How can I stop btrfs from continuing balancing?
> - How can I salvage this situation and convert to raid1?
>
> Unfortunately I have little spare drives left. Not enough to contain
> 4.7TiB of data.. :(
>
>
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
