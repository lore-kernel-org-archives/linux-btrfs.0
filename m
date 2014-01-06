Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:21786 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752995AbaAFIt1 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 6 Jan 2014 03:49:27 -0500
Message-ID: <52CA6DDF.3080306@cn.fujitsu.com>
Date: Mon, 06 Jan 2014 16:48:31 +0800
From: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
MIME-Version: 1.0
To: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
CC: xfs@oss.sgi.com, linux-btrfs@vger.kernel.org, Josef Bacik <jbacik@fb.com>
Subject: Re: [PATCH] xfstests: fix wrong return check for case 022
References: <1388995737-3480-1-git-send-email-wangsl.fnst@cn.fujitsu.com> <52CA67F2.9010108@jp.fujitsu.com>
In-Reply-To: <52CA67F2.9010108@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-2022-JP
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Itoh San,

On 01/06/2014 04:23 PM, Tsutomu Itoh wrote:
> On 2014/01/06 17:08, Wang Shilong wrote:
>> Here we expect 0 as return value, fix it.
>>
>> Signed-off-by: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
>> Cc: Josef Bacik <jbacik@fb.com>
>> ---
>>   tests/btrfs/022 | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>   mode change 100644 => 100755 tests/btrfs/022
>>
>> diff --git a/tests/btrfs/022 b/tests/btrfs/022
>> old mode 100644
>> new mode 100755
>> index 5b18643..142aaf9
>> --- a/tests/btrfs/022
>> +++ b/tests/btrfs/022
>> @@ -106,7 +106,7 @@ _limit_test()
>>   	[ $? -ne 0 ] || _fail "quota should have limited us"
>>   	dd if=/dev/urandom of=$SCRATCH_MNT/a/file bs=4M count=1 >> \
>>   		$seqres.full 2>&1
>> -	[ $? -eq 0 ] || _fail "should have been allowed to write"
>> +	[ $? -ne 0 ] || _fail "should have been allowed to write"
> from "man bash",
>        An OR list has the form
>               command1 || command2
>        command2 is executed if and only if command1 returns a non-zero exit
>        status.
>
> So, original code is OK, I think.

You are absolutely right, during my test i found we fail this case.
I took a careful think about this:

The problem is that we should clear the data we have written before,
Because we may write some data before, for example we limit subvolume to 5M
then we try this:

# dd if=/dev/zero of=/mnt/data bs=10M count=1

Although we try to write 10M once, in kernel, we may split it into
several request,
at the end, we can still write some data actually, you can try the
following command
after the above command.

# du -sh /mnt/data

Here i think the best way to fix this problem is we disable quota and
retry with 4m.

# btrfs qgroup limit none /mnt <------------- in case we are nearly full
and we can not delete file.
# rm -rf /mnt/data && btrfs filesystem sync /mnt
# btrfs qgroup limit 5m /mnt
# dd if=/dev/zero of=/mnt bs=4m count=1

Please correct me if i miss something here.^_^

Thanks,
Wang
> Thanks,
> Tsutomu
>
>>   }
>>   
>>   _scratch_mkfs > /dev/null 2>&1
>>
>

