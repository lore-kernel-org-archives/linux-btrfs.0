Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vc0-f177.google.com ([209.85.220.177]:34596 "EHLO
	mail-vc0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750935AbaJaRel (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 31 Oct 2014 13:34:41 -0400
Received: by mail-vc0-f177.google.com with SMTP id hq12so434976vcb.8
        for <linux-btrfs@vger.kernel.org>; Fri, 31 Oct 2014 10:34:39 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAGfcS_=f2TRGbeWpE186xE89jnXmPb=qiN6mPgjQGJRRX3UJ1g@mail.gmail.com>
References: <CAGwxe4hoJa6h3=qmsa6k+AzienjwZ2eifakKzhanXZVCru9koA@mail.gmail.com>
 <CAGwxe4inBLYrbq2t1T004dGR_vfE-GwgU=fho=SCDBa6LOkWow@mail.gmail.com> <CAGfcS_=f2TRGbeWpE186xE89jnXmPb=qiN6mPgjQGJRRX3UJ1g@mail.gmail.com>
From: Tobias Holst <tobby@tobby.eu>
Date: Fri, 31 Oct 2014 18:34:18 +0100
Message-ID: <CAGwxe4hC_BtPd41YCnFnyMD3TnOeuNgAZ1dZUFRUYuOkFjy0Yg@mail.gmail.com>
Subject: Re: filesystem corruption
To: Rich Freeman <r-btrfs@thefreemanclan.net>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I am now using another system with kernel 3.17.2 and btrfs-tools 3.17
and inserted one of the two HDDs of my btrfs-RAID1 to it. I can't add
the second one as there are only two slots in that server.

This is what I got:

 tobby@ubuntu: sudo btrfs check /dev/sdb1
warning, device 2 is missing
warning devid 2 not found already
root item for root 1746, current bytenr 80450240512, current gen
163697, current level 2, new bytenr 40074067968, new gen 163707, new
level 2
Found 1 roots with an outdated root item.
Please run a filesystem check with the option --repair to fix them.

 tobby@ubuntu: sudo btrfs check --repair /dev/sdb1
enabling repair mode
warning, device 2 is missing
warning devid 2 not found already
Unable to find block group for 0
extent-tree.c:289: find_search_start: Assertion `1` failed.
btrfs[0x42bd62]
btrfs[0x42ffe5]
btrfs[0x430211]
btrfs[0x4246ec]
btrfs[0x424d11]
btrfs[0x426af3]
btrfs[0x41b18c]
btrfs[0x40b46a]
/lib/x86_64-linux-gnu/libc.so.6(__libc_start_main+0xf5)[0x7ffca1119ec5]
btrfs[0x40b497]

This can be repeated as often as I want ;) Nothing changed.

Regards
Tobias


2014-10-31 3:41 GMT+01:00 Rich Freeman <r-btrfs@thefreemanclan.net>:
> On Thu, Oct 30, 2014 at 9:02 PM, Tobias Holst <tobby@tobby.eu> wrote:
>> Addition:
>> I found some posts here about a general file system corruption in 3.17
>> and 3.17.1 - is this the cause?
>> Additionally I am using ro-snapshots - maybe this is the cause, too?
>>
>> Anyway: Can I fix that or do I have to reinstall? Haven't touched the
>> filesystem, just did a scrub (found 0 errors).
>>
>
> Yup - ro-snapshots is a big problem in 3.17.  You can probably recover now by:
> 1.  Update your kernel to 3.17.2 - that takes care of all the big
> known 3.16/17 issues in general.
> 2.  Run btrfs check using btrfs-tools 3.17.  That can clean up the
> broken snapshots in your filesystem.
>
> That is fairly likely to get your filesystem working normally again.
> It worked for me.  I was getting some balance issues when trying to
> add another device and I'm not sure if 3.17.2 totally fixed that - I
> ended up cancelling the balance and it will be a while before I have
> to balance this particular filesystem again, so I'll just hold off and
> hope things stabilize.
>
> --
> Rich
