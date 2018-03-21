Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f47.google.com ([209.85.214.47]:34676 "EHLO
        mail-it0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751920AbeCURNz (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 21 Mar 2018 13:13:55 -0400
Received: by mail-it0-f47.google.com with SMTP id z7-v6so16881994iti.1
        for <linux-btrfs@vger.kernel.org>; Wed, 21 Mar 2018 10:13:55 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <f2113adc-776c-856c-4047-3281afe6e079@gmx.com>
References: <06b1fdb0d1884406a2d4c2e8be75e289@MOXDE7.na.bayer.cnb>
 <5389894b-5553-27b8-f9b3-4f6938bd75dd@dirtcellar.net> <3a6b6a6fb7d441b5a8081300067d6e02@MOXDE7.na.bayer.cnb>
 <CANQeFDDEtYYummhR7gZAxidQxTjbCbzEpLsR5L=HtykFkP2BBQ@mail.gmail.com>
 <1a292eab288a4c90bf6dbf804dc92c86@MOXDE7.na.bayer.cnb> <CANQeFDCSv9pwrGOqimQnb0kW8ZBJY=smF2MbZ7zcmEev-M7YzQ@mail.gmail.com>
 <CANQeFDB5pu+h++p3-GTUO28DE52r9JiW6TyLdy+rYGfUwjOfGA@mail.gmail.com>
 <fa53b8c8-1cf9-2d3d-4a9b-70e760ec45bb@dirtcellar.net> <CANQeFDDK7uU+USWzzDvWBG1SCpQJyZgrTnYoZ0qp99txSp7cEg@mail.gmail.com>
 <93b4d10e04d34ecfa97f705d939ab671@MOXDE7.na.bayer.cnb> <f2113adc-776c-856c-4047-3281afe6e079@gmx.com>
From: Liu Bo <obuil.liubo@gmail.com>
Date: Wed, 21 Mar 2018 10:13:53 -0700
Message-ID: <CANQeFDCR7skUgeY4esN5G4-y2Ry30fjFOyy7p8ayc6W1OtwxKw@mail.gmail.com>
Subject: Re: Crashes running btrfs scrub
To: Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: Mike Stevens <michael.stevens@bayer.com>,
        "waxhead@dirtcellar.net" <waxhead@dirtcellar.net>,
        "kreijack@inwind.it" <kreijack@inwind.it>,
        David Sterba <dsterba@suse.cz>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Mar 20, 2018 at 7:01 PM, Qu Wenruo <quwenruo.btrfs@gmx.com> wrote:
>
>
> On 2018年03月21日 01:44, Mike Stevens wrote:
>>
>>>> 30 devices is really not that much, heck you get 90 disks top load JBOD
>>>> storage chassis these days and BTRFS does sound like an attractive choice
>>>> for things like that.
>>
>>> So Mike's case is, that both metadata and data are configured as
>>> raid6, and the operations, balance and scrub, that he tried, need to
>>> set the existing block group as readonly (in order to avoid any
>>> further changes being applied during operations are running), then we
>>> got into the place where another system chunk is needed.
>>
>>> However, I think it'd be better to have some warnings about this when
>>> doing a) mkfs.btrfs -mraid6, b) btrfs device add.
>>
>>> David, any idea?
>>
>> I'll certainly vote for a warning, I would have set this up differently had I been aware.
>>
>> My filesystem check seems to have returned successfully:
>>
>> [root@auswscs9903] ~ # btrfs check --readonly /dev/sdb
>> Checking filesystem on /dev/sdb
>> UUID: 77afc2bb-f7a8-4ce9-9047-c031f7571150
>> checking extents
>> checking free space cache
>> checking fs roots
>> checking csums
>> checking root refs
>> found 97926270238720 bytes used err is 0
>> total csum bytes: 95395030288
>> total tree bytes: 201223503872
>> total fs tree bytes: 84484636672
>> total extent tree bytes: 7195869184
>> btree space waste bytes: 29627784154
>> file data blocks allocated: 97756261568512
>>
>> I've remounted the filesystem and I can at least touch a file.  I'm restarting the rsync that was running when it originally went read only.
>> What is the next step if it drops back to r/o?
>
> As already mentioned, if you're using tons of disks and RAID0/10/5/6 as
> metadata profile, you can just convert your metadata (or just system) to
> RAID1/DUP.
>
> Then there will be more than enough space for system chunk array.
>

It's chicken & egg, balance seems to be the only way to switch raid
profiles however users are stuck here because balance is aborted due
to failing to allocate an extra system chunk.

thanks,
liubo
