Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f66.google.com ([209.85.214.66]:41003 "EHLO
        mail-it0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751853AbdLMJ6C (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 13 Dec 2017 04:58:02 -0500
Received: by mail-it0-f66.google.com with SMTP id x28so3212453ita.0
        for <linux-btrfs@vger.kernel.org>; Wed, 13 Dec 2017 01:58:02 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20171213022619.GD3553@twin.jikos.cz>
References: <20171210091522.6061-1-anand.jain@oracle.com> <20171212174249.GN3553@twin.jikos.cz>
 <d37abb08-087f-7372-2196-c98b60229b63@oracle.com> <20171213022619.GD3553@twin.jikos.cz>
From: Timofey Titovets <nefelim4ag@gmail.com>
Date: Wed, 13 Dec 2017 12:57:21 +0300
Message-ID: <CAGqmi77LeXmQCYVKC1wjHycOO12JTzRzcYreX0c2qN+LoEAKxA@mail.gmail.com>
Subject: Re: [PATCH v3 0/5] define BTRFS_DEV_STATE
To: David Sterba <dsterba@suse.cz>, Anand Jain <anand.jain@oracle.com>,
        David Sterba <dsterba@suse.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

2017-12-13 5:26 GMT+03:00 David Sterba <dsterba@suse.cz>:
> On Wed, Dec 13, 2017 at 06:38:12AM +0800, Anand Jain wrote:
>>
>>
>> On 12/13/2017 01:42 AM, David Sterba wrote:
>> > On Sun, Dec 10, 2017 at 05:15:17PM +0800, Anand Jain wrote:
>> >> As of now device properties and states are being represented as int
>> >> variable, patches here makes them bit flags instead. Further, wip
>> >> patches such as device failed state needs this cleanup.
>> >>
>> >> v2:
>> >>   Adds BTRFS_DEV_STATE_REPLACE_TGT
>> >>   Adds BTRFS_DEV_STATE_FLUSH_SENT
>> >>   Drops BTRFS_DEV_STATE_CAN_DISCARD
>> >>   Starts bit flag from the bit 0
>> >>   Drops unrelated change - declare btrfs_device
>> >>
>> >> v3:
>> >>   Fix static checker warning, define respective dev state as bit number
>> >
>> > The define numbers are fixed but the whitespace changes that I made in
>> > misc-next
>>
>>   Will do next time. Thanks. I don't see misc-next. Is it for-next ?
>
> The kernel.org repository only gets the latest for-next, that is
> assembled from the pending branches, and also after some testing. You
> could still find 'misc-next' inside the for-next branch, but it's not
> obvious.
>
> All the development branches are pushed to
>
> https://github.com/kdave/btrfs-devel or
> http://repo.or.cz/linux-2.6/btrfs-unstable.git
>
> more frequently than the k.org/for-next is updated. I thought this has
> become a common knowledge, but yet it's not documented on the wiki so.
> Let's fix that.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Didn't know about your GitHub copy,
may be that have sense to update:
https://btrfs.wiki.kernel.org/index.php/Btrfs_source_repositories

And add new links? To:
 - k.org/for-next
 - https://github.com/kdave/btrfs-devel or
 - http://repo.or.cz/linux-2.6/btrfs-unstable.git

Because current link to
git://git.kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs.git
looks like a bit outdated.

Thanks.
-- 
Have a nice day,
Timofey.
