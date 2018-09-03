Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lj1-f172.google.com ([209.85.208.172]:33776 "EHLO
        mail-lj1-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727599AbeICX5c (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 3 Sep 2018 19:57:32 -0400
Received: by mail-lj1-f172.google.com with SMTP id s12-v6so1258507ljj.0
        for <linux-btrfs@vger.kernel.org>; Mon, 03 Sep 2018 12:35:53 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20180903102303.6jver7oxvwlq6yhc@angband.pl>
References: <83a74213-e66c-238c-43e4-8333c678e588@couderc.eu>
 <CAJCQCtQso9Lvw-33DmLDuOxnMcsRPzq6Ya9oo_n2_LvsvFVYqA@mail.gmail.com>
 <1d04b9a0-ae0f-267c-11ec-722c2be279aa@couderc.eu> <CAJCQCtS6dy4JUqdQEuTNAxDeCVSsRPOhM-yNqq0c4BjQrkbDzw@mail.gmail.com>
 <20180903102303.6jver7oxvwlq6yhc@angband.pl>
From: Chris Murphy <lists@colorremedies.com>
Date: Mon, 3 Sep 2018 13:35:51 -0600
Message-ID: <CAJCQCtQ8jB9Tovvvffq5DcfhX6cogXRuKwLHZK_Sz6SANc=Lkg@mail.gmail.com>
Subject: Re: IO errors when building RAID1.... ?
To: Adam Borowski <kilobyte@angband.pl>
Cc: Chris Murphy <lists@colorremedies.com>, Pierre Couderc <pierre@couderc.eu>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Sep 3, 2018 at 4:23 AM, Adam Borowski <kilobyte@angband.pl> wrote:
> On Sun, Sep 02, 2018 at 09:15:25PM -0600, Chris Murphy wrote:
>> For > 10 years drive firmware handles bad sector remapping internally.
>> It remaps the sector logical address to a reserve physical sector.
>>
>> NTFS and ext[234] have a means of accepting a list of bad sectors, and
>> will avoid using them. Btrfs doesn't. But also ZFS, XFS, APFS, HFS+
>> and I think even FAT, lack this capability.
>
> <nitpick>
> FAT entry FF7 (FAT12)/FFF7 (FAT16)/...
> </nitpick>

Oh yeah even Linux mkdosfs does have -c option to check for bad
sectors and presumably will remove them from use. It doesn't accept a
separate list though, like badblocks + mke2fs.

-- 
Chris Murphy
