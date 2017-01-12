Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:29993 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1750804AbdALBTI (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 11 Jan 2017 20:19:08 -0500
Subject: Re: [PATCH] btfs-progs: fsck-tests: corrupt nlink value test
To: <lakshmipathi.g@giis.co.in>
References: <20170107231955.GA24631@fedori>
 <c9e21f30-2231-94cd-09ed-8422951e7b69@cn.fujitsu.com>
 <fdc7f38883f4333cad73b7a92a1ba00a@giis.co.in>
CC: <linux-btrfs@vger.kernel.org>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <77e26cd7-0390-d02e-3dda-7107a2c68e7d@cn.fujitsu.com>
Date: Thu, 12 Jan 2017 09:19:00 +0800
MIME-Version: 1.0
In-Reply-To: <fdc7f38883f4333cad73b7a92a1ba00a@giis.co.in>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



At 01/11/2017 01:36 AM, lakshmipathi.g@giis.co.in wrote:
>> What about submitting a btrfs-image and use generic test load?
>
> Okay, how to share the corrupted btrfs-image? using github?  And also do
> you have references for this kind of
> setup under btrfs-progs/tests/?  So that  I can follow its model.

At least I follow the following steps to create image:

- Create a 256M file
   The default size of image.
   All zero content is recommended for high compression ratio.
   Both hole or fallocate is OK.

- Make btrfs on that file

- Fill the fs with minimum content
   Just enough files/dirs for next step.
   The smaller space it takes the better

- Corrupt the fs
   Either using btrfs-corrupt-block or manually

- Take the dump
   Either by btrfs-image or just use the raw image.

   It's recommended to use btrfs-image and with -c9 option, which
   can reduce the file size dramatically compared to xz raw image.
   But we must ensure the recovered image still has the same
   corruption, or we must use raw image.

   For raw image, xz it just like other tests.

   Normally submitted images are less than 100K, and that's small enough
   to send as patch.

Thanks,
Qu

>
> Cheers.
> Lakshmipathi.G
>
>
>


