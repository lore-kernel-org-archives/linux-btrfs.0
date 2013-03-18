Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-we0-f180.google.com ([74.125.82.180]:57953 "EHLO
	mail-we0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753881Ab3CRS5N convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 18 Mar 2013 14:57:13 -0400
Received: by mail-we0-f180.google.com with SMTP id k14so5035278wer.39
        for <linux-btrfs@vger.kernel.org>; Mon, 18 Mar 2013 11:57:11 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAHGunU=usUS+rsohquAdsMffjgJhiRc1yGY_kVpsRv1NFoZJZw@mail.gmail.com>
References: <CABzOi+d9ku3xJwQLZanBsagWmcd54Uf-oUuApTqkwguFTaHyYg@mail.gmail.com>
	<CAHGunU=TnjQFSb3G9==af_PX1cT_Wm5wML7sxwSPyvvgkg7cUA@mail.gmail.com>
	<CAHGunU=usUS+rsohquAdsMffjgJhiRc1yGY_kVpsRv1NFoZJZw@mail.gmail.com>
Date: Mon, 18 Mar 2013 19:57:10 +0100
Message-ID: <CABzOi+caqjU1O+b5FVm8B3u6t5pS8M2EoA6U763GYnr7HAi3Gw@mail.gmail.com>
Subject: Re: Btrfs in multiple different disc -d sigle -m raid1 one drive failure...
From: Jan Beranek <jan233321@gmail.com>
To: Michael Johnson - MJ <mj@revmj.com>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Michael,
thank you for your advice - looks nice, I never used "aufs" before - I
will give a try.

Kind Regards

Jan.

On Mon, Mar 18, 2013 at 7:55 PM, Michael Johnson - MJ <mj@revmj.com> wrote:
> Sigh... failed to reply all...
>
> On Mon, Mar 18, 2013 at 11:52 AM, Michael Johnson - MJ <mj@revmj.com> wrote:
>> Hi Jan,
>>
>> In that configuration, you should assume that a single disk failure
>> will cause complete data loss.  While some data may be recoverable, I
>> don't believe btrfs gives you any guarantees in that regard.
>>
>> But, I have a suggestion for you that may be suitable for what you want.
>>
>> * Create 3 individual btrfs file systems, one on each disk.
>>
>> * Use 'aufs' to present these filesystems as if they were a single file system.
>>
>> I use a setup like this for data I don't consider important, but would
>> rather not lose it all.  This ensures that individual files are always
>> completely contained on a single disk.  It also has the additional
>> advantage of preventing filesystem corruption from causing total data
>> loss.
>>
>>
>> On Mon, Mar 18, 2013 at 11:32 AM, Jan Beranek <jan233321@gmail.com> wrote:
>>> Hi all,
>>> I'm preparing a strorage pool for large data with quite low importance
>>> - there will be at least 3 hdd in "-d single" and "-m raid1"
>>> configuration.
>>>
>>> mkfs.btrfs -d single -m raid1 /dev/sda /dev/sdb /dec/sdc
>>>
>>> What happen if one hdd fails? Do I lost everything from all three
>>> discs or only data from one disc? (if from only one disc, then is it
>>> acceptable otherwise not...)
>>>
>>> I read all documentation and a lot of discussions on the web and
>>> answer is not clear at all...
>>>
>>> Kind Regards
>>>
>>> Jan.
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>>
>>
>> --
>> Michael Johnson - MJ
>
>
>
> --
> Michael Johnson - MJ



--
S pozdravem

Jan Beránek
