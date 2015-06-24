Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:63582 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S933554AbbFXAay (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 23 Jun 2015 20:30:54 -0400
Subject: Re: Corrupted btrfs partition (converted from ext4) after balance
To: Chris Murphy <lists@colorremedies.com>
References: <55835A55.7000308@stroebel.fr> <5588BA12.4010104@cn.fujitsu.com>
 <CAJCQCtQF3H37tKKYWzUW9R3S9h+18Dzpg22hWViAahm2_ttZtQ@mail.gmail.com>
CC: Vianney Stroebel <capsule@likwid.fr>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <5589FA3E.4010205@cn.fujitsu.com>
Date: Wed, 24 Jun 2015 08:30:54 +0800
MIME-Version: 1.0
In-Reply-To: <CAJCQCtQF3H37tKKYWzUW9R3S9h+18Dzpg22hWViAahm2_ttZtQ@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



Chris Murphy wrote on 2015/06/23 11:30 -0600:
> On Mon, Jun 22, 2015 at 7:44 PM, Qu Wenruo <quwenruo@cn.fujitsu.com> wrote:
>> Without the full output of btrfsck, it's quite hard to call it a clear bug
>> report if you want to save your data in the corrupted partition.
>
> What I read was that he included everything btrfs check reported,
> which wasn't a lot. It
>
>
>> The command Konsole output "btrfs check /dev/sdb1" outputs :
>> "Checking filesystem on /dev/sdb1
>> UUID: 21873ba7-438a-4fbf-a051-ace28bffd264
>> checking extents"
>> and stops after a few minutes with no other output.
>
> Since he's using btrfs-progs 3.19, I think he should upgrade to
> btrfs-progs 4.1, try check again, and report the complete results.
>

If it stopped without further output, it has a high possibility that 
btrfsck encounters a segfault or assert.
If it's assert, backtrace (need to enable at compile time) should be 
provided.

If core dump, gdb backtrace is better provided if possible.

Anyway, advice from Chris is quite useful.
Upgrade to latest 4.1 btrfs-progs (better to compile from source) should 
solve the two cases above and provide enough information.

Thanks,
Qu
