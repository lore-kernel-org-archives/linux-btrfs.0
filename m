Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:60604 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751300AbdEQPgq (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 17 May 2017 11:36:46 -0400
Received: from mail-io0-f170.google.com (mail-io0-f170.google.com [209.85.223.170])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 68A7F239CC
        for <linux-btrfs@vger.kernel.org>; Wed, 17 May 2017 15:36:42 +0000 (UTC)
Received: by mail-io0-f170.google.com with SMTP id f102so11614631ioi.2
        for <linux-btrfs@vger.kernel.org>; Wed, 17 May 2017 08:36:42 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <5907F475.10704@gmail.com>
References: <5907519C.2020204@gmail.com> <CAL3q7H772sxj0KVWQ6tWTrb=2fzvgCQxryyCDPzj4GaUWH2TGw@mail.gmail.com>
 <5907F475.10704@gmail.com>
From: Filipe Manana <fdmanana@kernel.org>
Date: Wed, 17 May 2017 16:36:41 +0100
Message-ID: <CAL3q7H598GmQqJMxj6N3eetjvgroKkgXnPh02T3UkYszLtxWeQ@mail.gmail.com>
Subject: Re: ERROR: rename o3528-7220-0 -> usr failed: Directory not empty
To: Joseph Hart <jfhart085@gmail.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, May 2, 2017 at 3:52 AM, J. Hart <jfhart085@gmail.com> wrote:
> On 05/01/2017 02:52 PM, Filipe Manana wrote:
>>
>> On Mon, May 1, 2017 at 4:17 PM, J. Hart <jfhart085@gmail.com> wrote:
>> Just use "btrfs-image -c 9 /dev/whatever image_file", it will create a
>> compressed image where the data is replaced with zeroes (not needed to debug
>> this problem anyway). Then uploaded it anywhere convenient for you.
>
>
> I have prepared the image as per your instructions.  It is 27 Mb in size.  I
> have no way to confirm whether or not it is correct, as the documentation on
> how that might be done is unclear on that point. It was also not clear
> whether or not the btrfs filesystem should be unmounted as the documentation
> does not specify.   A warning appears if it is mounted, so I unmounted it to
> make the image.
>
> I have at present no convenient location to upload it to.   Can you suggest
> one ?
>
> If you can manage to load the image on to a btrfs filesystem, cd to the
> mount point and do the following:
>
> btrfs se --no-data snp1 | btrfs rec temp
> btrfs se --no-data -p snp1 snp2 | btrfs rec temp # failure here
>
> The error should be something like:
>
> -su-3.2# btrfs se --no-data -p snp1 snp2 | btrfs rec temp # failure here
> At subvol snp2
> At snapshot snp2
> ERROR: rename o3528-12-0 -> usr failed: Directory not empty

So I managed to use the image and try it myself with the 4.11 kernel
codebase. No problems found sending those snapshots.
Please try a 4.11 kernel, as there's a few send fixes in there that
should fix the issue.

Thanks!

>
>
> I have been able to get the requisite data from the original filesystem to a
> completely different one, and recreate the error on the new filesystem, so
> the error seems to follow along with the data involved.
>
