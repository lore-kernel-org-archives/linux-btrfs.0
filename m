Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vk0-f65.google.com ([209.85.213.65]:33378 "EHLO
	mail-vk0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757122AbcG1L6I (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 28 Jul 2016 07:58:08 -0400
Received: by mail-vk0-f65.google.com with SMTP id s189so1675111vkh.0
        for <linux-btrfs@vger.kernel.org>; Thu, 28 Jul 2016 04:58:06 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20160728094441.GO30795@twin.jikos.cz>
References: <CADxRZqyXtmf7LMB4ogwp8Af4Nd+Md7YtiTWRpC2xjM_fG3YKJw@mail.gmail.com>
 <20160727195609.GN30795@twin.jikos.cz> <20160728094441.GO30795@twin.jikos.cz>
From: Anatoly Pugachev <matorola@gmail.com>
Date: Thu, 28 Jul 2016 14:58:05 +0300
Message-ID: <CADxRZqwTUaZyDipvmGcfk8Q9P2X_NLQ=9svtc8BbKeFqoFVPdw@mail.gmail.com>
Subject: Re: [sparc64] mkfs.btrfs bus error / align issue?
To: dsterba@suse.cz
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>,
        debian-sparc <debian-sparc@lists.debian.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jul 28, 2016 at 12:44 PM, David Sterba <dsterba@suse.cz> wrote:
> On Wed, Jul 27, 2016 at 09:56:09PM +0200, David Sterba wrote:
>> On Wed, Jul 27, 2016 at 04:59:27PM +0300, Anatoly Pugachev wrote:
>> > Hello!
>> >
>> > Running xfstests suite, got in logs mkfs.btrfs bus error, debugging it
>> > shows the following :
>> >
>> > Program received signal SIGBUS, Bus error.
>> > 0x000000000015e160 in write_raid56_with_parity (info=0x2b17b0,
>> > eb=0x2c7fe0, multi=0x2c2870, stripe_len=65536, raid_map=0x2c2570) at
>> > volumes.c:2156
>> > 2156                                    *(unsigned long *)(p_eb->data + i) ^=
>>
>> Yeah, clear unaligned access. We have helpers for so I'll fix it. I was
>> looking for a way to simulate and catch that on x86 or at least let gcc
>> warn but no such thing seems to exist. Which means we might accidentally
>> introduce that in the future.
>
> Can you please test with the current 'devel' branch? Fixed by the patch
> "btrfs-progs: fix unaligned access calculating raid56 data" (depends on
> another patch in devel). Thanks.

David,

but where do I get -devel branch of btrfs-progs?
I just tried git://repo.or.cz/btrfs-progs-unstable/devel.git , but
still seeing last commit in it:

mator@nvg5120:~/1/devel$ git log -1 --pretty=format:"%h %s, %an, %ad"
--date=short
40650bf Btrfs progs v4.6.1, David Sterba, 2016-06-24

so where do i pull git repo to take latest development patches?

Thanks.
