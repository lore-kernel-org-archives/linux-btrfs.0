Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f179.google.com ([209.85.223.179]:33459 "EHLO
	mail-io0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752361AbcEMQyJ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 13 May 2016 12:54:09 -0400
Received: by mail-io0-f179.google.com with SMTP id f89so139732937ioi.0
        for <linux-btrfs@vger.kernel.org>; Fri, 13 May 2016 09:54:08 -0700 (PDT)
Subject: Re: BTRFS Data at Rest File Corruption
To: kreijack@inwind.it, Richard Lochner <lochner@clone1.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
References: <CACTfMoQmco=yBP+e8tn0MoTVZsMauw0_=N1yc42NVNM9Krqv7A@mail.gmail.com>
 <97b8a0bd-3707-c7d6-4138-c8fe81937b72@gmail.com> <573600C1.5020602@inwind.it>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <c7617d55-d8d6-77c4-52d9-3312110ca26b@gmail.com>
Date: Fri, 13 May 2016 12:54:06 -0400
MIME-Version: 1.0
In-Reply-To: <573600C1.5020602@inwind.it>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2016-05-13 12:28, Goffredo Baroncelli wrote:
> On 2016-05-11 21:26, Austin S. Hemmelgarn wrote:
>> (although it can't tell the difference between a corrupted checksum and a corrupted block of data).
>
> I don't think so. The data checksums are stored in metadata blocks, and as metadata block, these have their checksums. So btrfs know if the checksum is correct or none, despite the fact that the data is correct or none. Of course if the checksum is wrong, btrfs can't tell if the data is correct.
>
> The only exception should be the inline data: in this case the data is stored in the metadata block, and this block is protected by only one checksum.
>
> I know that I am pedantic :_)  but after reading your comment I looked at the btrfs data structure to refresh my memory, so I want to share these information.
It is fully possible for the block of data to be good and the checksum 
to be bad, it's just ridiculously unlikely.  I've actually had this 
happen before at least twice (I have really bad luck when it comes disk 
corruption).

