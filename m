Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ie0-f169.google.com ([209.85.223.169]:39488 "EHLO
	mail-ie0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752567Ab3CRSzb (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 18 Mar 2013 14:55:31 -0400
Received: by mail-ie0-f169.google.com with SMTP id 13so7466613iea.14
        for <linux-btrfs@vger.kernel.org>; Mon, 18 Mar 2013 11:55:31 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAHGunU=TnjQFSb3G9==af_PX1cT_Wm5wML7sxwSPyvvgkg7cUA@mail.gmail.com>
References: <CABzOi+d9ku3xJwQLZanBsagWmcd54Uf-oUuApTqkwguFTaHyYg@mail.gmail.com>
	<CAHGunU=TnjQFSb3G9==af_PX1cT_Wm5wML7sxwSPyvvgkg7cUA@mail.gmail.com>
Date: Mon, 18 Mar 2013 11:55:30 -0700
Message-ID: <CAHGunU=usUS+rsohquAdsMffjgJhiRc1yGY_kVpsRv1NFoZJZw@mail.gmail.com>
Subject: Re: Btrfs in multiple different disc -d sigle -m raid1 one drive failure...
From: Michael Johnson - MJ <mj@revmj.com>
To: Jan Beranek <jan233321@gmail.com>, linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Sigh... failed to reply all...

On Mon, Mar 18, 2013 at 11:52 AM, Michael Johnson - MJ <mj@revmj.com> wrote:
> Hi Jan,
>
> In that configuration, you should assume that a single disk failure
> will cause complete data loss.  While some data may be recoverable, I
> don't believe btrfs gives you any guarantees in that regard.
>
> But, I have a suggestion for you that may be suitable for what you want.
>
> * Create 3 individual btrfs file systems, one on each disk.
>
> * Use 'aufs' to present these filesystems as if they were a single file system.
>
> I use a setup like this for data I don't consider important, but would
> rather not lose it all.  This ensures that individual files are always
> completely contained on a single disk.  It also has the additional
> advantage of preventing filesystem corruption from causing total data
> loss.
>
>
> On Mon, Mar 18, 2013 at 11:32 AM, Jan Beranek <jan233321@gmail.com> wrote:
>> Hi all,
>> I'm preparing a strorage pool for large data with quite low importance
>> - there will be at least 3 hdd in "-d single" and "-m raid1"
>> configuration.
>>
>> mkfs.btrfs -d single -m raid1 /dev/sda /dev/sdb /dec/sdc
>>
>> What happen if one hdd fails? Do I lost everything from all three
>> discs or only data from one disc? (if from only one disc, then is it
>> acceptable otherwise not...)
>>
>> I read all documentation and a lot of discussions on the web and
>> answer is not clear at all...
>>
>> Kind Regards
>>
>> Jan.
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>
>
> --
> Michael Johnson - MJ



-- 
Michael Johnson - MJ
