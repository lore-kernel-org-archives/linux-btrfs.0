Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lf0-f45.google.com ([209.85.215.45]:33706 "EHLO
        mail-lf0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751734AbcJJGvT (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 10 Oct 2016 02:51:19 -0400
Received: by mail-lf0-f45.google.com with SMTP id x79so110352526lff.0
        for <linux-btrfs@vger.kernel.org>; Sun, 09 Oct 2016 23:51:19 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <536c679a-d8a5-7c0d-6d4f-6fa7bffb23c7@cn.fujitsu.com>
References: <CAKuJGC8oPG=oO98SKg+DwLeyPanGHdGxGxaUAW0ekhM7hE4dnw@mail.gmail.com>
 <536c679a-d8a5-7c0d-6d4f-6fa7bffb23c7@cn.fujitsu.com>
From: "Lakshmipathi.G" <lakshmipathi.g@gmail.com>
Date: Mon, 10 Oct 2016 12:20:37 +0530
Message-ID: <CAKuJGC_MBD7DW6BarJ_e+BExVLbo9Cam8M-_qub=w-GcoXXk6Q@mail.gmail.com>
Subject: Re: btrfs-convert: migrating files with flags set using chattr
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Qu,

Thanks for resolving the issue and update. I'll re-use your testcase
with common.convert/generate_dataset() when it becomes
available on master branch.

----
Cheers,
Lakshmipathi.G



On Mon, Oct 10, 2016 at 6:54 AM, Qu Wenruo <quwenruo@cn.fujitsu.com> wrote:
> Thanks for the report.
>
> I first thought it's a convert rewrite regression again, but I checked out
> v4.5.3(the last version without convert rewrite) and just found it's still
> the same problem.
>
> So the good news is, it's not a regression(at least for me), and the bad
> news is, attr copy never works from the beginning.
>
> I'll fix it in recent days, and enrich the convert test framework to prevent
> such problem happens again.
>
> Thanks,
> Qu
>
>
> At 10/10/2016 01:51 AM, Lakshmipathi.G wrote:
>>
>> Hi.
>>
>> Looks like btrfs-progs/btrfs-convert doesn't retain file attributes
>> like immutable flags, is this expected behavior ?
>>
>> //  test.img is ext2
>> [root@ mnt]# touch a b
>> [root@ mnt]# chattr +a a
>> [root@ mnt]# chattr +i b
>> [root@ mnt]# lsattr a b
>> -----a---------- a
>> ----i----------- b
>>
>>
>> // after btrfs-convert  test.img
>>
>> [root@ mnt]# lsattr a b
>> ---------------- a
>> ---------------- b
>>
>>
>>
>> ----
>> Cheers,
>> Lakshmipathi.G
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>>
>
>
