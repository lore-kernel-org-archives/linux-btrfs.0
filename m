Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f178.google.com ([209.85.213.178]:34154 "EHLO
	mail-ig0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751959AbbL2CqF (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 28 Dec 2015 21:46:05 -0500
Received: by mail-ig0-f178.google.com with SMTP id ik10so6399527igb.1
        for <linux-btrfs@vger.kernel.org>; Mon, 28 Dec 2015 18:46:04 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <pan$5afbb$4270f15d$d1ce1c42$cc039fab@cox.net>
References: <CAJCQCtT78=kqXZVDAV-x0C1NW=7okBBM_+vM3+HAc5BtUArsiw@mail.gmail.com>
	<pan$5afbb$4270f15d$d1ce1c42$cc039fab@cox.net>
Date: Mon, 28 Dec 2015 19:46:03 -0700
Message-ID: <CAJCQCtSfyTAJuEmsddyHEzwU335eQJmHWr6+a4JqpV0shZfjkQ@mail.gmail.com>
Subject: Re: should btrfsck fix a bad superblock?
From: Chris Murphy <lists@colorremedies.com>
To: Duncan <1i5t5.duncan@cox.net>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Dec 28, 2015 at 7:28 PM, Duncan <1i5t5.duncan@cox.net> wrote:
> Chris Murphy posted on Mon, 28 Dec 2015 17:10:14 -0700 as excerpted:
>
>> Hi,
>>
>> I (intentionally) used wipefs -a on a device with a btrfs. As expected
>> btrfs check doesn't recognize the device as having a btrfs volume
>> anymore.
>>
>> Slightly surprising that it doesn't mention other intact supers are
>> found.
>>
>> Most surprising that options -s1 --repair doesn't fix it.
>>
>> I thought maybe it's intentional, only with explicitly bad magic, and
>> I'd get different results if it were zero'd. So I zero'd it and I get
>> the same results. s0 superblock isn't repaired with --repair.
>>
>> Bug?
>>
>> Of course I can fix it with echo+dd.
>
> Btrfs check's -s option simply lets you use a different superblock.  I
> don't believe check is designed to actually fix superblocks, tho I guess
> with --repair it fixes certain bad fields in them.
>
> What you want to actually recover bad superblocks from good copies is
> btrfs rescue super-recover.

Yep! I forgot about that. But it's still confusing that particular
repair is split out.



-- 
Chris Murphy
