Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:6639 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756699AbcBXHxz (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 24 Feb 2016 02:53:55 -0500
Subject: Re: [PATCH 1/5] fstests: Add support to check btrfs sysfs features
To: <fdmanana@gmail.com>
References: <1456295716-9589-1-git-send-email-quwenruo@cn.fujitsu.com>
 <1456295716-9589-2-git-send-email-quwenruo@cn.fujitsu.com>
 <CAL3q7H5Vii4TVT9TMsnGMk1dMzF=Z69e-_0m6yE+n5JSgT8_Rw@mail.gmail.com>
CC: <fstests@vger.kernel.org>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <56CD6188.7000407@cn.fujitsu.com>
Date: Wed, 24 Feb 2016 15:53:44 +0800
MIME-Version: 1.0
In-Reply-To: <CAL3q7H5Vii4TVT9TMsnGMk1dMzF=Z69e-_0m6yE+n5JSgT8_Rw@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



Filipe Manana wrote on 2016/02/24 07:27 +0000:
> On Wed, Feb 24, 2016 at 6:35 AM, Qu Wenruo <quwenruo@cn.fujitsu.com> wrote:
>> Btrfs has its sysfs interface showing what features current kernel/btrfs
>> module support.
>>
>> Add _require_btrfs_kernel_feature() to check such interface.
>
>
> I think you sent the wrong patch. This doesn't add such a function and
> the changes are exactly the same as in:
>
> [PATCH 1/5] fstests: rename _require_btrfs to _require_btrfs_subcommand

Oh, this is one old and deprecated patch.
I forgot to cleanup the dir...

Please ignore this one.

The other one, "[PATCH 1/5] fstests: rename _require_btrfs to
  _require_btrfs_subcommand" is the correct one.

As fstests already provide _btrfs_require_fs_feature().

I'll send the patchset.

Thanks,
Qu
>
>>
>> Also rename _require_btrfs() to _require_btrfs_subcommand() to avoid
>> confusion.
>
> So if there's a dedicated patch to do that already (the one I
> mentioned above), why do it here again? (and should be a separate
> patch anyway, since it's unrelated)
>
>>
>> Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
>> ---
>>   common/rc       | 2 +-
>>   tests/btrfs/004 | 2 +-
>>   tests/btrfs/048 | 1 +
>>   tests/btrfs/059 | 1 +
>>   4 files changed, 4 insertions(+), 2 deletions(-)
>>
>> diff --git a/common/rc b/common/rc
>> index af16c81..ff57862 100644
>> --- a/common/rc
>> +++ b/common/rc
>> @@ -2706,7 +2706,7 @@ _require_deletable_scratch_dev_pool()
>>   }
>>
>>   # We check for btrfs and (optionally) features of the btrfs command
>> -_require_btrfs()
>> +_require_btrfs_subcommand()
>>   {
>>          cmd=$1
>>          _require_command "$BTRFS_UTIL_PROG" btrfs
>> diff --git a/tests/btrfs/004 b/tests/btrfs/004
>> index 905770a..2ce628e 100755
>> --- a/tests/btrfs/004
>> +++ b/tests/btrfs/004
>> @@ -51,7 +51,7 @@ _supported_fs btrfs
>>   _supported_os Linux
>>   _require_scratch
>>   _require_no_large_scratch_dev
>> -_require_btrfs inspect-internal
>> +_require_btrfs_subcommand inspect-internal
>>   _require_command "/usr/sbin/filefrag" filefrag
>>
>>   rm -f $seqres.full
>> diff --git a/tests/btrfs/048 b/tests/btrfs/048
>> index c2cb4a6..d15346a 100755
>> --- a/tests/btrfs/048
>> +++ b/tests/btrfs/048
>> @@ -48,6 +48,7 @@ _supported_os Linux
>>   _require_test
>>   _require_scratch
>>   _require_btrfs "property"
>> +_require_btrfs_subcommand "property"
>>
>>   send_files_dir=$TEST_DIR/btrfs-test-$seq
>>
>> diff --git a/tests/btrfs/059 b/tests/btrfs/059
>> index b9a6ef4..6e7f7ee 100755
>> --- a/tests/btrfs/059
>> +++ b/tests/btrfs/059
>> @@ -51,6 +51,7 @@ _supported_os Linux
>>   _require_test
>>   _require_scratch
>>   _require_btrfs "property"
>> +_require_btrfs_subcommand "property"
>>
>>   rm -f $seqres.full
>>
>> --
>> 2.7.1
>>
>>
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>
>


