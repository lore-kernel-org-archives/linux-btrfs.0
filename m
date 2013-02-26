Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:36948 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756234Ab3BZGZM (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 26 Feb 2013 01:25:12 -0500
Received: by mail-we0-f174.google.com with SMTP id r6so3193481wey.5
        for <linux-btrfs@vger.kernel.org>; Mon, 25 Feb 2013 22:25:10 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20130226115704.50102196@natsu>
References: <CAPF83msjTJWjWJgJOAWsQ2GoxAC-cZ4GkK_+H11tAyA689KD_w@mail.gmail.com>
	<CAMU1PDhQqm6s5FUbVJa5nwOD4Ewf-6Cr2gx2khHHwrBxUqsQDA@mail.gmail.com>
	<CAG1y0scOg2QGCZdCTkKHBn5xxNh5GGmdXTcS8rOesup4r1JsXQ@mail.gmail.com>
	<CAPF83mvfLrDvBvbP5Oe_R94BM7Lr5pZD=gpnDrr4TquBq88q5Q@mail.gmail.com>
	<20130226115704.50102196@natsu>
Date: Mon, 25 Feb 2013 22:25:10 -0800
Message-ID: <CAPF83mv2qVqE5HnXVr9P8JHqs4+DKjt0hWaR8UG6Kk4reyPsAw@mail.gmail.com>
Subject: Re: lvm volume like support
From: Suman C <schakrava@gmail.com>
To: Roman Mamedov <rm@romanrm.ru>
Cc: "Fajar A. Nugraha" <list@fajar.net>,
        Mike Fleetwood <mike.fleetwood@googlemail.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Thanks for the sparse file idea, I am actually using that solution
already. I am not sure if its the best way, however.

Suman

On Mon, Feb 25, 2013 at 9:57 PM, Roman Mamedov <rm@romanrm.ru> wrote:
> On Mon, 25 Feb 2013 21:35:08 -0800
> Suman C <schakrava@gmail.com> wrote:
>
>> Yes, zvol like feature where a btrfs subvolume like construct can be
>> made available as a LUN/block device. This device can then be used by
>> any application that wants a raw block device. iscsi is another
>> obvious usecase. Having thin provisioning support would make it pretty
>> awesome.
>
> I think what you are missing is that btrfs is a filesystem, not a block device
> management mechanism.
>
> For your use case can simply create a snapshot and then make a sparse file
> inside of it.
>
>   btrfs sub create foobar
>   dd if=/dev/zero of=foobar/100GB.img bs=1 count=1 seek=100G
>
> If you need this to be a block device, use 'losetup' to make foobar/100GB.img
> appear as one (/dev/loopX). But iSCSI/AoE/NBD can export files as well as block
> devices, so this is not even necessary.
>
> --
> With respect,
> Roman
