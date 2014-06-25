Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vc0-f182.google.com ([209.85.220.182]:50408 "EHLO
	mail-vc0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752337AbaFYNBv (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 25 Jun 2014 09:01:51 -0400
Received: by mail-vc0-f182.google.com with SMTP id il7so1853969vcb.13
        for <linux-btrfs@vger.kernel.org>; Wed, 25 Jun 2014 06:01:50 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <yq1bntjizkr.fsf@sermon.lab.mkp.net>
References: <CAPLrYESSX+D5tnY_qWcz0B+xUyyT1Ut-ALM=b9TfehACUq82GA@mail.gmail.com>
	<2316027.LZEnVG8laK@xev>
	<CAPLrYETdzeT_Yia-nnbZBMvGxU3x7tCFiJSv3rNJezMsjce3Zw@mail.gmail.com>
	<6CA8020B-EB92-4A44-8AA5-3F69709F81F2@colorremedies.com>
	<CAK5rZE6gfmQsZz3W_8t=pkKEk_rzqUn5hQVv0sbt8p7qbdhSdQ@mail.gmail.com>
	<53A6DDAD.8070804@chinilu.com>
	<99AD3EFE-AF9A-44A1-912E-07B1E934239B@colorremedies.com>
	<pan$600a2$3927cc39$ae007590$e90b8415@cox.net>
	<yq1bntjizkr.fsf@sermon.lab.mkp.net>
Date: Wed, 25 Jun 2014 15:01:49 +0200
Message-ID: <CAK5rZE4Eo+e_wbyzqPauYO=9HC9CEEF8Dftnw0D6zr1+7Z+GBw@mail.gmail.com>
Subject: Re: btrfs on whole disk (no partitions)
From: Imran Geriskovan <imran.geriskovan@gmail.com>
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 6/23/14, Martin K. Petersen <martin.petersen@oracle.com> wrote:
> Anyway. The short answer is that Linux will pretty much always do I/O in
> multiples of the system page size regardless of the logical block size
> of the underlying device. There are a few exceptions to this such as
> direct I/O, legacy filesystems using bufferheads and raw block device
> access.

Thanks for the clarification.

And some random notes:

Note that gdisk gives default 8 sector alignment value for AF disks.
That is 'sector' meant by gdisk is 'Logical Sector'!
Sufficiently determined user may create misaligned
partitions by playing with alignment value and partition start/end
values.

There are SSDs with 4K, 8K block/page sizes and
512K, 1M, 1.5M Erase block sizes.

Partitions should be aligned with Erase blocks.
And filesystem block size (leafsize for btrfs. Default 16 K)
should be in multiples of device block size.

Regards, Imran
