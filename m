Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ie0-f169.google.com ([209.85.223.169]:38276 "EHLO
	mail-ie0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759601Ab3BYTBH (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 25 Feb 2013 14:01:07 -0500
Received: by mail-ie0-f169.google.com with SMTP id 13so3580918iea.0
        for <linux-btrfs@vger.kernel.org>; Mon, 25 Feb 2013 11:01:07 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20130225172719.GA2434@localhost.localdomain>
References: <CAEx9m45BO=McK-NrL3fX7QiJMtf-T+bKoc1D1G=6vHxYT8b36g@mail.gmail.com>
 <20130220175410.GB2062@localhost.localdomain> <CAEx9m46b9rW4xDiQi8QiTmyC5Wa9hNcasL_nXF4Y2qdyPE+D6g@mail.gmail.com>
 <CAEzrpqcGeiq=tHEvcH9625vZpCZaD94PrpjYO1_r4nS2GP9ByA@mail.gmail.com>
 <CAEx9m45V6aUkNQe0PTf+qJjpkJLHyMc4UBfSex9mxGOy-X7GrQ@mail.gmail.com> <20130225172719.GA2434@localhost.localdomain>
From: Aastha Mehta <aasthakm@gmail.com>
Date: Mon, 25 Feb 2013 20:00:47 +0100
Message-ID: <CAEx9m44BBv-rZqF_tv5PgKkHjfzBYo9p-4h3WeGLdykA+s+71A@mail.gmail.com>
Subject: Re: basic questions regarding COW in Btrfs
To: Josef Bacik <jbacik@fusionio.com>
Cc: Josef Bacik <josef@toxicpanda.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Ah okay, I now see how it works. Thanks a lot for your response.

Regards,
Aastha.


On 25 February 2013 18:27, Josef Bacik <jbacik@fusionio.com> wrote:
> On Mon, Feb 25, 2013 at 08:15:40AM -0700, Aastha Mehta wrote:
>> Thanks again Josef.
>>
>> I understood that cow_file_range is called for a regular file. Just to
>> clarify, in cow_file_range is cow done at the time of reserving
>> extents in the extent btree for the io to be done in this delalloc? I
>> see the following comment above find_free_extent() which is called
>> while trying to reserve extents:
>>
>> /*
>>  * walks the btree of allocated extents and find a hole of a given size.
>>  * The key ins is changed to record the hole:
>>  * ins->objectid == block start
>>  * ins->flags = BTRFS_EXTENT_ITEM_KEY
>>  * ins->offset == number of blocks
>>  * Any available blocks before search_start are skipped.
>>  */
>>
>> This seems to be the only place where a cow might be done, because a
>> key is being inserted into an extent which modifies it.
>>
>
> The key isn't inserted at this time, it's just returned with those values for us
> to do as we please.  There is no update of the btree until
> insert_reserved_extent/btrfs_mark_extent_written in btrfs_finish_ordered_io.
> Thanks,
>
> Josef
