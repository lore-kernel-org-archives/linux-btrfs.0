Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp1-g21.free.fr ([212.27.42.1]:18969 "EHLO smtp1-g21.free.fr"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726163AbeIALOQ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 1 Sep 2018 07:14:16 -0400
Subject: Re: IO errors when building RAID1.... ?
To: Chris Murphy <lists@colorremedies.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
References: <83a74213-e66c-238c-43e4-8333c678e588@couderc.eu>
 <CAJCQCtQso9Lvw-33DmLDuOxnMcsRPzq6Ya9oo_n2_LvsvFVYqA@mail.gmail.com>
From: Pierre Couderc <pierre@couderc.eu>
Message-ID: <1d04b9a0-ae0f-267c-11ec-722c2be279aa@couderc.eu>
Date: Sat, 1 Sep 2018 09:03:16 +0200
MIME-Version: 1.0
In-Reply-To: <CAJCQCtQso9Lvw-33DmLDuOxnMcsRPzq6Ya9oo_n2_LvsvFVYqA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 08/31/2018 08:52 PM, Chris Murphy wrote:
>
> Bad sector which is failing write. This is fatal, there isn't anything
> the block layer or Btrfs (or ext4 or XFS) can do about it. Well,
> ext234 do have an option to scan for bad sectors and create a bad
> sector map which then can be used at mkfs time, and ext234 will avoid
> using those sectors. And also the md driver has a bad sector option
> for the same, and does remapping. But XFS and Btrfs don't do that.
>
> If the drive is under warranty, get it swapped out, this is definitely
> a warranty covered problem.
>
>
>
>
Thank you very much.

Once upon a time...(I am old), there were lists of bad sectors, and the 
software did avoid wrting in them. It seems to have disappeared. For 
which reason ? Maybe because these errors occur so  rarely, that it is 
not worth the trouble ?
