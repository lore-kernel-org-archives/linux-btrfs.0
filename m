Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vk0-f51.google.com ([209.85.213.51]:35384 "EHLO
        mail-vk0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752062AbdHBIbT (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 2 Aug 2017 04:31:19 -0400
Received: by mail-vk0-f51.google.com with SMTP id d124so15290676vkf.2
        for <linux-btrfs@vger.kernel.org>; Wed, 02 Aug 2017 01:31:19 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170801214519.GF26357@localhost.localdomain>
References: <CAN_=hu0k8+FmrSOw5P5TAZyjzjvGyqv_ByYr27s8rZY456k87Q@mail.gmail.com>
 <20170731181200.GA3459@lim.localdomain> <20170801110410.0813a03a@natsu> <20170801214519.GF26357@localhost.localdomain>
From: "marcel.cochem" <marcel.cochem@googlemail.com>
Date: Wed, 2 Aug 2017 10:30:37 +0200
Message-ID: <CAN_=hu3G2_C-GuC52RjgDiX_mN8GZAWr1w0AjtOdGF0ypuD8yA@mail.gmail.com>
Subject: Re: BTRFS error: bad tree block start 0 623771648
To: bo.li.liu@oracle.com
Cc: Roman Mamedov <rm@romanrm.net>, linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Thanks you for the information. It looks indeed like there are some
important parts all zerod... I will try to hijack to code to get easy
access to some config directories.
I already reinstalled the Operating System, now with dup Metadata and
will have a deeper look at the discard flag.
The restore tools don't work out of the box, because like Liu Bo
mentioned, they'll check metadata and exit on an error.

Thanks for your support
marcel


On Tue, Aug 1, 2017 at 11:45 PM, Liu Bo <bo.li.liu@oracle.com> wrote:
> On Tue, Aug 01, 2017 at 11:04:10AM +0500, Roman Mamedov wrote:
>> On Mon, 31 Jul 2017 11:12:01 -0700
>> Liu Bo <bo.li.liu@oracle.com> wrote:
>>
>> > Superblock and chunk tree root is OK, looks like the header part of
>> > the tree root is now all-zero, but I'm unable to think of a btrfs bug
>> > which can lead to that (if there is, it is a serious enough one)
>>
>> I see that the FS is being mounted with "discard". So maybe it was a TRIM gone
>> bad (wrong location or in a wrong sequence).
>>
>
> By checking discard path in btrfs, looks OK to me, more likely it's
> caused by problems from underlying stuff.
>
> Thanks,
>
> -liubo
>
>> Generally it appears to be not recommended to use "discard" by now (because of
>> its performance impact, and maybe possible issues like this), instead schedule
>> to call "fstrim <mountpoint>" once a day or so, and/or on boot-up.
>>
>> > on ssd like disks, by default there is only one copy for metadata.
>>
>> Time and time again, the default of "single" metadata for SSD is a terrible
>> idea. Most likely DUP metadata would save the FS in this case.
>>
>> --
>> With respect,
>> Roman
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
