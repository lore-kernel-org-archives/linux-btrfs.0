Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:65505 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751271AbaBKBZr (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 10 Feb 2014 20:25:47 -0500
Message-ID: <52F97BC1.4090900@cn.fujitsu.com>
Date: Tue, 11 Feb 2014 09:24:17 +0800
From: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
MIME-Version: 1.0
To: Dave Chinner <david@fromorbit.com>
CC: Wang Shilong <wangshilong1991@gmail.com>, xfs@oss.sgi.com,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] xfstests: btrfs/004: fix to make test really work
References: <1392034256-2412-1-git-send-email-wangshilong1991@gmail.com> <20140210213944.GT13647@dastard>
In-Reply-To: <20140210213944.GT13647@dastard>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 02/11/2014 05:39 AM, Dave Chinner wrote:
> On Mon, Feb 10, 2014 at 08:10:56PM +0800, Wang Shilong wrote:
>> From: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
>>
>> So i was wandering why test 004 could pass my previous wrong
>> kernel patch while it defenitely should not.
>>
>> By some debugging, i found here perl script is wrong, we did not
>> filter out anything and this unit test did not work acutally.so
>> it came out we will never fail this test.
>>
>> Signed-off-by: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
>> ---
>>   tests/btrfs/004 | 7 +++----
>>   1 file changed, 3 insertions(+), 4 deletions(-)
>>   mode change 100755 => 100644 tests/btrfs/004
>>
>> diff --git a/tests/btrfs/004 b/tests/btrfs/004
>> old mode 100755
>> new mode 100644
>> index 14da9f1..17a6e34
>> --- a/tests/btrfs/004
>> +++ b/tests/btrfs/004
>> @@ -57,10 +57,9 @@ _require_command "/usr/sbin/filefrag"
>>   
>>   rm -f $seqres.full
>>   
>> -FILEFRAG_FILTER='if (/, blocksize (\d+)/) {$blocksize = $1; next} ($ext, '\
>> -'$logical, $physical, $expected, $length, $flags) = (/^\s*(\d+)\s+(\d+)'\
>> -'\s+(\d+)\s+(?:(\d+)\s+)?(\d+)\s+(.*)/) or next; $flags =~ '\
>> -'/(?:^|,)inline(?:,|$)/ and next; print $physical * $blocksize, "#", '\
>> +FILEFRAG_FILTER='if (/blocks of (\d+) bytes/) {$blocksize = $1; next} ($ext, '\
>> +'$logical, $physical, $length) = (/^\s*(\d+):\s+(\d+)..\s+\d+:'\
>> +'\s+(\d+)..\s+\d+:\s+(\d+):/) or next; print $physical * $blocksize, "#", '\
>>   '$length * $blocksize, "#", $logical * $blocksize, " "'
> Oh, boy, who allowed that mess to pass review? Please format this in
> a readable manner while you are changing it.
Yeah,  i was thinking to make it more readable while i had sent this out.^_^
Thanks for your comments.

Wang
>
> FILEFRAG_FILTER='
> 	if (/blocks of (\d+) bytes/) {			\
> 		$blocksize = $1;			\
> 		next;					\
> 	}
> .....
>
> Cheers,
>
> Dave.

