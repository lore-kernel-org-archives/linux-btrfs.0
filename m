Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:44942 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932691AbdDGJNP (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 7 Apr 2017 05:13:15 -0400
MIME-Version: 1.0
In-Reply-To: <20170407085117.GS22845@eguan.usersys.redhat.com>
References: <1491287671-23097-1-git-send-email-fdmanana@kernel.org> <20170407085117.GS22845@eguan.usersys.redhat.com>
From: Filipe Manana <fdmanana@kernel.org>
Date: Fri, 7 Apr 2017 10:13:09 +0100
Message-ID: <CAL3q7H7SN5stPdFDD87kUBtLhJkA2E5dHJ+Cf0m601WeyA9H+A@mail.gmail.com>
Subject: Re: [PATCH 1/3] common/rc: test that xfs_io's falloc command supports
 specific flags
To: Eryu Guan <eguan@redhat.com>
Cc: fstests@vger.kernel.org,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        Filipe Manana <fdmanana@suse.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Apr 7, 2017 at 9:51 AM, Eryu Guan <eguan@redhat.com> wrote:
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
>> +             testio=`$XFS_IO_PROG -F -f -c "$command 0 1m" $testfile 2>&1`
>
> Sorry, I was wrong about this. It would break the subsequent
> $XFS_IO_PROG -c "help $command" | grep ... command if another $param is
> specified.

Yeah I had noticed that because the following won't cause the return anymore:

test -z "$param" && return

> Seems adding $param to falloc command is the right way, as
> what Darrick did to fiemap in his new test.
>
> -               testio=`$XFS_IO_PROG -F -f -c "falloc 0 1m" $testfile 2>&1`
> +               testio=`$XFS_IO_PROG -F -f -c "falloc $param 0 1m" $testfile 2>&1`

But in that case grepping the help output, at the very end of the
function, will fail for falloc since its help output fails to match
the grep pattern (as highlighted in the thread you pointed before).
So that grep pattern would have to change as well.

>
> Do you mind me updating these three patches accordingly? Or can you send
> out new version if you like?

Sure, fell free to update it as you feel it's the best way.

Thanks!

>
> Thanks! And sorry again!
>
> Eryu
>
> P.S. I'm thinking of converting all the case switches (except the
> default one) in _require_xfs_io_command() to actually run the $command
> with $param, and doing other cleanups, but that won't block this patch
> and I can do it in another patch.
>
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
