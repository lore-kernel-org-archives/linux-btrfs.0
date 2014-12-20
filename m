Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:55140 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752163AbaLTLCa (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 20 Dec 2014 06:02:30 -0500
Message-ID: <54955740.5070405@fb.com>
Date: Sat, 20 Dec 2014 06:02:24 -0500
From: Josef Bacik <jbacik@fb.com>
MIME-Version: 1.0
To: Daniele Testa <daniele.testa@gmail.com>,
        Zygo Blaxell <ce3g8jdj@umail.furryterror.org>
CC: <linux-btrfs@vger.kernel.org>
Subject: Re: btrfs is using 25% more disk than it should
References: <CAN6BF2Luf3ERd+ShLyUavzM3bLmy9dT918Zg17xL9T42DNVtVQ@mail.gmail.com>	<54949454.9020601@fb.com>	<549495D4.9030800@fb.com>	<20141220055242.GB436@hungrycats.org> <CAN6BF2LhUcrmRrfhJP1scrTLsCyZ2pWNp-_5MQ5spQViPfJc7g@mail.gmail.com>
In-Reply-To: <CAN6BF2LhUcrmRrfhJP1scrTLsCyZ2pWNp-_5MQ5spQViPfJc7g@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 12/20/2014 01:18 AM, Daniele Testa wrote:
> But I read somewhere that compression should be turned off on mounts
> that just store large VM-images. Is that wrong?
>

It doesn't really matter frankly.  Usually virt images are preallocated 
with fallocate which means compression doesn't happen as writes into 
fallocated areas aren't compressed, but you aren't doing that so you 
would be getting some compression.

> Btw, I am not pre-allocation space for the images. I use sparse files with:
>
> dd if=/dev/zero of=drive.img bs=1 count=1 seek=300G
>
> It creates the file in a few ms.
> Is it better to use "fallocate" with btrfs?
>

It depends.  If you are going to use nodatacow for your virt images then 
I would definitely suggest using fallocate since you'll get a nice 
contiguous chunk of data for your virt images.

> If I use sparse files, it adds a benefit when I want to copy/move the
> image-file to another server.
> Like if the 300GB sparse file just has 10GB of data in it, I only need
> to copy 10GB when moving it to another server.
> Would the same be true with "fallocate"?
>

No, but send/receive would only copy 10GB, but the resulting file would 
be sparse.

> Anyways, would disabling CoW (by putting +C on the parent dir) prevent
> the performance issues and 2*filesize issue?
>

Yes.  Thanks,

Josef
