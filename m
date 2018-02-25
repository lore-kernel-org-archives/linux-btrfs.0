Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lf0-f49.google.com ([209.85.215.49]:36397 "EHLO
        mail-lf0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751508AbeBYBsu (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 24 Feb 2018 20:48:50 -0500
Received: by mail-lf0-f49.google.com with SMTP id t79so17462497lfe.3
        for <linux-btrfs@vger.kernel.org>; Sat, 24 Feb 2018 17:48:49 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <a7984d0a-15e0-a087-1616-1eb21f5ab60e@gmx.com>
References: <E9DC5E3A12524BBAA0B7D3BDE7FB87F2@pc7ssd> <a7984d0a-15e0-a087-1616-1eb21f5ab60e@gmx.com>
From: Shehbaz Jaffer <shehbazjaffer007@gmail.com>
Date: Sat, 24 Feb 2018 20:48:47 -0500
Message-ID: <CAPLK-i_60dsLiwUdd5yP5WHvutn77xa0JwoR3m+FhH7GNNwk7g@mail.gmail.com>
Subject: Re: BTRFS RESTORE issue
To: Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: =?UTF-8?B?TWFyacOhbiBNbMSNb2No?= <marian@prima.pis.sk>,
        linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

> If you want checksum and your fs can stand normal RO mount, go RO mount,
> and do normal cp, you will get csum error in kernel message if there is any.

Also, try btrfsck and btrfs scrub. both help in identifying (and
sometimes correcting) csum errors.
They would give both logs on console and dmesg for csum error
detection and correction.

Thanks

On Sat, Feb 24, 2018 at 8:36 PM, Qu Wenruo <quwenruo.btrfs@gmx.com> wrote:
>
>
> On 2018年02月24日 19:13, Marián Mlčoch wrote:
>> Hello,
>> i requst IRC , but nobody helps.
>> My primary question is , how mark restored files with ignored errors.
>>
>> btrfs restore –iv /vol /restorage
>>
>> this command restores files like charm but no marker for ok and bad
>> files (bad crc , bad ...). WHY?
>> This file system isnt newbie , i mean this is urgent feature.
>
> From btrfs-restore(8):
>
> btrfs-restore - try to restore files from a *damaged* btrfs filesystem image
>
> Unless your filesystem is really damaged, you shouldn't use btrfs-restore.
> It's used to *salvage* data, no wonder it will bypass all checksum checking.
>
> If you want checksum and your fs can stand normal RO mount, go RO mount,
> and do normal cp, you will get csum error in kernel message if there is any.
>
>>
>> I restore terabytes miloins files , how after this check bad files ???
>>
>> Please send me info around this , and add this feature ifnt exist.
>>
>> I see one way use dump restore filter but how?
>>
>> btrfs restore –ivD /vol /restorage | grep ??? for bad files
>>
>> Second question is when files is restored with switch –iv , exist way to
>> update metadata in next restore without overwrite?
>
> What did you mean update metadata?
>
> Thanks,
> Qu
>
>> This is for restore
>> next urgent feature.
>>
>> Thanks for info Marian.
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
