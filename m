Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io1-f65.google.com ([209.85.166.65]:40499 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727002AbeITBOL (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 19 Sep 2018 21:14:11 -0400
Received: by mail-io1-f65.google.com with SMTP id l14-v6so5451779iob.7
        for <linux-btrfs@vger.kernel.org>; Wed, 19 Sep 2018 12:34:48 -0700 (PDT)
Subject: Re: GRUB writing to grubenv outside of kernel fs code
To: kreijack@inwind.it, Chris Murphy <lists@colorremedies.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
References: <CAJCQCtRyY=_qPTkBkMCs9HCNMvEHJCeFJ_=eCK_BGKgWLHotXA@mail.gmail.com>
 <CAJCQCtTw9=A7BS-eZTy0rRJ1V0+=tUY5c43rvGg5ieY4EkdWZg@mail.gmail.com>
 <406ded26-bcef-ce8c-36e4-1b25bbb36768@libero.it>
 <ea52b0e3-9444-d1e0-a934-ad132998b23c@libero.it>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <3d755559-f25e-0e6d-b6eb-7e38732bed5f@gmail.com>
Date: Wed, 19 Sep 2018 15:34:42 -0400
MIME-Version: 1.0
In-Reply-To: <ea52b0e3-9444-d1e0-a934-ad132998b23c@libero.it>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2018-09-19 15:08, Goffredo Baroncelli wrote:
> On 18/09/2018 19.15, Goffredo Baroncelli wrote:
>>> b. The bootloader code, would have to have sophisticated enough Btrfs
>>> knowledge to know if the grubenv has been reflinked or snapshot,
>>> because even if +C, it may not be valid to overwrite, and COW must
>>> still happen, and there's no way the code in GRUB can do full blow COW
>>> and update a bunch of metadata.
> 
>> And what if GRUB ignore the possibility of COWing and overwrite the data ? Is it a so big problem that the data is changed in all the snapshots ?
>> It would be interested if the same problem happens for a swap file.....
> 
> I gave a look to the Sandoval's patches about implementing swap on BTRFS. This patch set
> prevents the subvolume containing the swapfile to be snapshot-ted (and the file to be balanced and so on...); what if we would add the same constraint to the grubenv file ?
We would need to have a generalized mechanism of doing this then, 
because there's no way in hell a patch special-casing a single filename 
is going to make it into mainline.

Whatever mechanism is used, it should also:

* Force the file to not be inlined in metadata.
* Enforce the file having the NOCOW attribute being set.
