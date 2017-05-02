Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f176.google.com ([209.85.223.176]:34599 "EHLO
        mail-io0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750830AbdEBCwl (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 1 May 2017 22:52:41 -0400
Received: by mail-io0-f176.google.com with SMTP id a103so139302729ioj.1
        for <linux-btrfs@vger.kernel.org>; Mon, 01 May 2017 19:52:40 -0700 (PDT)
Message-ID: <5907F475.10704@gmail.com>
Date: Mon, 01 May 2017 22:52:37 -0400
From: "J. Hart" <jfhart085@gmail.com>
Reply-To: jfhart085@gmail.com
MIME-Version: 1.0
To: Filipe Manana <fdmanana@kernel.org>
CC: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: ERROR: rename o3528-7220-0 -> usr failed: Directory not empty
References: <5907519C.2020204@gmail.com> <CAL3q7H772sxj0KVWQ6tWTrb=2fzvgCQxryyCDPzj4GaUWH2TGw@mail.gmail.com>
In-Reply-To: <CAL3q7H772sxj0KVWQ6tWTrb=2fzvgCQxryyCDPzj4GaUWH2TGw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 05/01/2017 02:52 PM, Filipe Manana wrote:
> On Mon, May 1, 2017 at 4:17 PM, J. Hart <jfhart085@gmail.com> wrote:
> Just use "btrfs-image -c 9 /dev/whatever image_file", it will create a 
> compressed image where the data is replaced with zeroes (not needed to 
> debug this problem anyway). Then uploaded it anywhere convenient for you. 

I have prepared the image as per your instructions.  It is 27 Mb in 
size.  I have no way to confirm whether or not it is correct, as the 
documentation on how that might be done is unclear on that point. It was 
also not clear whether or not the btrfs filesystem should be unmounted 
as the documentation does not specify.   A warning appears if it is 
mounted, so I unmounted it to make the image.

I have at present no convenient location to upload it to.   Can you 
suggest one ?

If you can manage to load the image on to a btrfs filesystem, cd to the 
mount point and do the following:

btrfs se --no-data snp1 | btrfs rec temp
btrfs se --no-data -p snp1 snp2 | btrfs rec temp # failure here

The error should be something like:

-su-3.2# btrfs se --no-data -p snp1 snp2 | btrfs rec temp # failure here
At subvol snp2
At snapshot snp2
ERROR: rename o3528-12-0 -> usr failed: Directory not empty


I have been able to get the requisite data from the original filesystem 
to a completely different one, and recreate the error on the new 
filesystem, so the error seems to follow along with the data involved.

