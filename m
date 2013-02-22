Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lb0-f180.google.com ([209.85.217.180]:40514 "EHLO
	mail-lb0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755691Ab3BVVT2 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 22 Feb 2013 16:19:28 -0500
Received: by mail-lb0-f180.google.com with SMTP id q12so874230lbc.39
        for <linux-btrfs@vger.kernel.org>; Fri, 22 Feb 2013 13:19:27 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20130222100015.GD12835@liubo.cn.oracle.com>
References: <1361520691-22665-1-git-send-email-bo.li.liu@oracle.com>
	<CAAdM645SGn=in2xq-Gv=DBCfpxJvynQEywr5tq7sh=jt-J197A@mail.gmail.com>
	<20130222084034.GC12835@liubo.cn.oracle.com>
	<CAAdM644hwRoGyrJVcmZgEY6S0EMDX4d-ZAQQ550mVi3SYVsYwg@mail.gmail.com>
	<20130222100015.GD12835@liubo.cn.oracle.com>
Date: Fri, 22 Feb 2013 16:19:27 -0500
Message-ID: <CAAdM644O8k3K16As84tbtoP9Knac93wqNB5Bwg_wN6YJ16Ea3g@mail.gmail.com>
Subject: Re: [PATCH] Btrfs: update inode flags when renaming
From: Marios Titas <redneb8888@gmail.com>
To: bo.li.liu@oracle.com
Cc: btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Feb 22, 2013 at 5:00 AM, Liu Bo <bo.li.liu@oracle.com> wrote:
> On Fri, Feb 22, 2013 at 04:10:37AM -0500, Marios Titas wrote:
>> You are right, your patch does improve the situation a bit. But it
>> still does not address the main issue. To illustrate that, consider
>> the following scenario:
>
> Sorry for so much confusion for users.
>
> Please let me explain the following senario,
>
>>
>> touch test
>> chattr +C test
>> head -c 1048576 /dev/zero >> test
>> mv test test2
>>
>> now test2 lost the C flag because it was renamed. But the data in
>> test2 was written before it lost the C flag and so the extents do not
>> have checksums!
>> Also try to clone it with BTRFS_IOC_CLONE. It fails as if it had the C flag:
>>
>> cp --reflink test2 test3
>
> We don't clone a file when the src(test2) file has NODATASUM and the dest(test3)
> file does not have NODATASUM, or vice versa.  This ensures our checksum's valid.
>
> Here,
> *  test2 does has NODATASUM because test has NODATASUM, while
> *  test3 is a new created file, and we're not with '-o nodatasum' or
>    '-o nodatacow' mount options or we don't chattr test3,
>    so test3 does not have NODATASUM flags set.
>
> So 'cp' ends up 'INVALID'.
>
>>
>> OTOH, if you try to clone over a file with NODATACOW then it works:
>>
>> touch test3
>> chattr +C test3
>> cp --reflink test2 test3
>
> Now test3 is with NODATACOW, so the above 'cp' works.
>
>>
>> so the file is in an incosistent state: it sometimes behaves as if it
>> had the NODATACOW flag and sometimes as if it didn't.
>
> The C flag refers to NODATACOW, this NODATACOW is used to tell btrfs
> if we write the file's data on COW mode.
>
> So the failure of 'clone' does not equal to the file is NODATACOW.
>
> Feel free to correct me.

I think that many end users will find all this very confusing. They
will never expect that renaming a file will cause it to suddenly lose
one flag (NODATACOW) while preserving the other (NODATASUM).
Especially since they cannot explicitly control the NODATASUM flag on
a per file basis. I think that renaming a file should preserve all
flags no matter if it's done in the same directory or not. Just like
it preserves permissions, ownership and inode number. So I think
inheriting the flags from the parent on rename is not a good idea
either. Interestingly enough, files don't lose any of the two flags if
instead of renaming you link and then unlink the original.
