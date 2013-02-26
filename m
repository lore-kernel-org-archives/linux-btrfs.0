Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wg0-f46.google.com ([74.125.82.46]:46481 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752458Ab3BZG2r convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 26 Feb 2013 01:28:47 -0500
Received: by mail-wg0-f46.google.com with SMTP id fg15so3041401wgb.13
        for <linux-btrfs@vger.kernel.org>; Mon, 25 Feb 2013 22:28:46 -0800 (PST)
Content-Type: text/plain; charset=US-ASCII
Mime-Version: 1.0 (Mac OS X Mail 6.2 \(1499\))
Subject: Re: lvm volume like support
From: Remco Hosman - Yerf IT <remco@yerf-it.nl>
In-Reply-To: <CAPF83mv2qVqE5HnXVr9P8JHqs4+DKjt0hWaR8UG6Kk4reyPsAw@mail.gmail.com>
Date: Tue, 26 Feb 2013 07:28:43 +0100
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Message-Id: <FEF2721D-ABA2-4CE7-A562-6210B0946BF8@yerf-it.nl>
References: <CAPF83msjTJWjWJgJOAWsQ2GoxAC-cZ4GkK_+H11tAyA689KD_w@mail.gmail.com> <CAMU1PDhQqm6s5FUbVJa5nwOD4Ewf-6Cr2gx2khHHwrBxUqsQDA@mail.gmail.com> <CAG1y0scOg2QGCZdCTkKHBn5xxNh5GGmdXTcS8rOesup4r1JsXQ@mail.gmail.com> <CAPF83mvfLrDvBvbP5Oe_R94BM7Lr5pZD=gpnDrr4TquBq88q5Q@mail.gmail.com> <20130226115704.50102196@natsu> <CAPF83mv2qVqE5HnXVr9P8JHqs4+DKjt0hWaR8UG6Kk4reyPsAw@mail.gmail.com>
To: Suman C <schakrava@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

would be really cool if a TRIM to the loopback device would do a 'hole punch' on the file

Remco


On Feb 26, 2013, at 7:25 AM, Suman C <schakrava@gmail.com> wrote:

> Thanks for the sparse file idea, I am actually using that solution
> already. I am not sure if its the best way, however.
> 
> Suman
> 
> On Mon, Feb 25, 2013 at 9:57 PM, Roman Mamedov <rm@romanrm.ru> wrote:
>> On Mon, 25 Feb 2013 21:35:08 -0800
>> Suman C <schakrava@gmail.com> wrote:
>> 
>>> Yes, zvol like feature where a btrfs subvolume like construct can be
>>> made available as a LUN/block device. This device can then be used by
>>> any application that wants a raw block device. iscsi is another
>>> obvious usecase. Having thin provisioning support would make it pretty
>>> awesome.
>> 
>> I think what you are missing is that btrfs is a filesystem, not a block device
>> management mechanism.
>> 
>> For your use case can simply create a snapshot and then make a sparse file
>> inside of it.
>> 
>>  btrfs sub create foobar
>>  dd if=/dev/zero of=foobar/100GB.img bs=1 count=1 seek=100G
>> 
>> If you need this to be a block device, use 'losetup' to make foobar/100GB.img
>> appear as one (/dev/loopX). But iSCSI/AoE/NBD can export files as well as block
>> devices, so this is not even necessary.
>> 
>> --
>> With respect,
>> Roman
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

