Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:40146 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S935100AbdDFOUs (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 6 Apr 2017 10:20:48 -0400
MIME-Version: 1.0
In-Reply-To: <20170406141805.GL22845@eguan.usersys.redhat.com>
References: <1491287671-23097-1-git-send-email-fdmanana@kernel.org> <20170406141805.GL22845@eguan.usersys.redhat.com>
From: Filipe Manana <fdmanana@kernel.org>
Date: Thu, 6 Apr 2017 15:20:43 +0100
Message-ID: <CAL3q7H6F+vyh5DrNsa9ZWS2dTOnVF+9CG2h=MBojmsyjnfMy7w@mail.gmail.com>
Subject: Re: [PATCH 1/3] common/rc: test that xfs_io's falloc command supports
 specific flags
To: Eryu Guan <eguan@redhat.com>
Cc: fstests@vger.kernel.org,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        Filipe Manana <fdmanana@suse.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Apr 6, 2017 at 3:18 PM, Eryu Guan <eguan@redhat.com> wrote:
> On Tue, Apr 04, 2017 at 07:34:29AM +0100, fdmanana@kernel.org wrote:
>> From: Filipe Manana <fdmanana@suse.com>
>>
>> For example NFS 4.2 supports fallocate but it does not support its
>> KEEP_SIZE flag, so we want to skip tests that use fallocate with that
>> flag on filesystems that don't support it.
>>
>> Suggested-by: Eryu Guan <eguan@redhat.com>
>> Signed-off-by: Filipe Manana <fdmanana@suse.com>
>> ---
>>  common/rc | 4 ++--
>>  1 file changed, 2 insertions(+), 2 deletions(-)
>>
>> diff --git a/common/rc b/common/rc
>> index e1ab2c6..3d0f089 100644
>> --- a/common/rc
>> +++ b/common/rc
>> @@ -2021,8 +2021,8 @@ _require_xfs_io_command()
>>       "chproj")
>>               testio=`$XFS_IO_PROG -F -f -c "chproj 0" $testfile 2>&1`
>>               ;;
>> -     "falloc" )
>> -             testio=`$XFS_IO_PROG -F -f -c "falloc 0 1m" $testfile 2>&1`
>> +     "falloc*" )
>
> This doesn't work as expected with quotes. I can remove the quotes at
> commit time though.

Hum, it did work for me, strange.

But please do, thanks.

>
> Thanks,
> Eryu
>
>> +             testio=`$XFS_IO_PROG -F -f -c "$command 0 1m" $testfile 2>&1`
>>               ;;
>>       "fpunch" | "fcollapse" | "zero" | "fzero" | "finsert" | "funshare")
>>               testio=`$XFS_IO_PROG -F -f -c "pwrite 0 20k" -c "fsync" \
>> --
>> 2.7.0.rc3
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe fstests" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
