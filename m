Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lj1-f176.google.com ([209.85.208.176]:47069 "EHLO
        mail-lj1-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725780AbeICHdg (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 3 Sep 2018 03:33:36 -0400
Received: by mail-lj1-f176.google.com with SMTP id 203-v6so14123355ljj.13
        for <linux-btrfs@vger.kernel.org>; Sun, 02 Sep 2018 20:15:27 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1d04b9a0-ae0f-267c-11ec-722c2be279aa@couderc.eu>
References: <83a74213-e66c-238c-43e4-8333c678e588@couderc.eu>
 <CAJCQCtQso9Lvw-33DmLDuOxnMcsRPzq6Ya9oo_n2_LvsvFVYqA@mail.gmail.com> <1d04b9a0-ae0f-267c-11ec-722c2be279aa@couderc.eu>
From: Chris Murphy <lists@colorremedies.com>
Date: Sun, 2 Sep 2018 21:15:25 -0600
Message-ID: <CAJCQCtS6dy4JUqdQEuTNAxDeCVSsRPOhM-yNqq0c4BjQrkbDzw@mail.gmail.com>
Subject: Re: IO errors when building RAID1.... ?
To: Pierre Couderc <pierre@couderc.eu>
Cc: Chris Murphy <lists@colorremedies.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Sep 1, 2018 at 1:03 AM, Pierre Couderc <pierre@couderc.eu> wrote:
>
>
> On 08/31/2018 08:52 PM, Chris Murphy wrote:
>>
>>
>> Bad sector which is failing write. This is fatal, there isn't anything
>> the block layer or Btrfs (or ext4 or XFS) can do about it. Well,
>> ext234 do have an option to scan for bad sectors and create a bad
>> sector map which then can be used at mkfs time, and ext234 will avoid
>> using those sectors. And also the md driver has a bad sector option
>> for the same, and does remapping. But XFS and Btrfs don't do that.
>>
>> If the drive is under warranty, get it swapped out, this is definitely
>> a warranty covered problem.
>>
>>
>>
>>
> Thank you very much.
>
> Once upon a time...(I am old), there were lists of bad sectors, and the
> software did avoid wrting in them. It seems to have disappeared. For which
> reason ? Maybe because these errors occur so  rarely, that it is not worth
> the trouble ?

For > 10 years drive firmware handles bad sector remapping internally.
It remaps the sector logical address to a reserve physical sector.

NTFS and ext[234] have a means of accepting a list of bad sectors, and
will avoid using them. Btrfs doesn't. But also ZFS, XFS, APFS, HFS+
and I think even FAT, lack this capability. I'm not aware of any file
system that once had bad sector tracking, that has since dropped the
capability.

-- 
Chris Murphy
