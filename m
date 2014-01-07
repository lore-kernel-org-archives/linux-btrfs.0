Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:51307 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756135AbaAGBLn (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 6 Jan 2014 20:11:43 -0500
Received: from m2.gw.fujitsu.co.jp (unknown [10.0.50.72])
	by fgwmail6.fujitsu.co.jp (Postfix) with ESMTP id 412C03EE0BB
	for <linux-btrfs@vger.kernel.org>; Tue,  7 Jan 2014 10:11:41 +0900 (JST)
Received: from smail (m2 [127.0.0.1])
	by outgoing.m2.gw.fujitsu.co.jp (Postfix) with ESMTP id 3276345DE4D
	for <linux-btrfs@vger.kernel.org>; Tue,  7 Jan 2014 10:11:41 +0900 (JST)
Received: from s2.gw.fujitsu.co.jp (s2.gw.nic.fujitsu.com [10.0.50.92])
	by m2.gw.fujitsu.co.jp (Postfix) with ESMTP id 1A73645DE3E
	for <linux-btrfs@vger.kernel.org>; Tue,  7 Jan 2014 10:11:41 +0900 (JST)
Received: from s2.gw.fujitsu.co.jp (localhost.localdomain [127.0.0.1])
	by s2.gw.fujitsu.co.jp (Postfix) with ESMTP id 0DDF61DB8038
	for <linux-btrfs@vger.kernel.org>; Tue,  7 Jan 2014 10:11:41 +0900 (JST)
Received: from ml14.s.css.fujitsu.com (ml14.s.css.fujitsu.com [10.240.81.134])
	by s2.gw.fujitsu.co.jp (Postfix) with ESMTP id B340F1DB802C
	for <linux-btrfs@vger.kernel.org>; Tue,  7 Jan 2014 10:11:40 +0900 (JST)
Message-ID: <52CB5441.3030004@jp.fujitsu.com>
Date: Tue, 07 Jan 2014 10:11:29 +0900
From: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
MIME-Version: 1.0
To: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
CC: xfs@oss.sgi.com, linux-btrfs@vger.kernel.org, Josef Bacik <jbacik@fb.com>
Subject: Re: [PATCH] xfstests: fix wrong return check for case 022
References: <1388995737-3480-1-git-send-email-wangsl.fnst@cn.fujitsu.com> <52CA67F2.9010108@jp.fujitsu.com> <52CA6DDF.3080306@cn.fujitsu.com>
In-Reply-To: <52CA6DDF.3080306@cn.fujitsu.com>
Content-Type: text/plain; charset=ISO-2022-JP
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2014/01/06 17:48, Wang Shilong wrote:
> Itoh San,
> 
> On 01/06/2014 04:23 PM, Tsutomu Itoh wrote:
>> On 2014/01/06 17:08, Wang Shilong wrote:
>>> Here we expect 0 as return value, fix it.
>>>
>>> Signed-off-by: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
>>> Cc: Josef Bacik <jbacik@fb.com>
>>> ---
>>>    tests/btrfs/022 | 2 +-
>>>    1 file changed, 1 insertion(+), 1 deletion(-)
>>>    mode change 100644 => 100755 tests/btrfs/022
>>>
>>> diff --git a/tests/btrfs/022 b/tests/btrfs/022
>>> old mode 100644
>>> new mode 100755
>>> index 5b18643..142aaf9
>>> --- a/tests/btrfs/022
>>> +++ b/tests/btrfs/022
>>> @@ -106,7 +106,7 @@ _limit_test()
>>>    	[ $? -ne 0 ] || _fail "quota should have limited us"
>>>    	dd if=/dev/urandom of=$SCRATCH_MNT/a/file bs=4M count=1 >> \
>>>    		$seqres.full 2>&1
>>> -	[ $? -eq 0 ] || _fail "should have been allowed to write"
>>> +	[ $? -ne 0 ] || _fail "should have been allowed to write"
>> from "man bash",
>>         An OR list has the form
>>                command1 || command2
>>         command2 is executed if and only if command1 returns a non-zero exit
>>         status.
>>
>> So, original code is OK, I think.
> 
> You are absolutely right, during my test i found we fail this case.
> I took a careful think about this:
> 
> The problem is that we should clear the data we have written before,
> Because we may write some data before, for example we limit subvolume to 5M
> then we try this:
> 
> # dd if=/dev/zero of=/mnt/data bs=10M count=1
> 
> Although we try to write 10M once, in kernel, we may split it into
> several request,
> at the end, we can still write some data actually, you can try the
> following command
> after the above command.
> 
> # du -sh /mnt/data
> 
> Here i think the best way to fix this problem is we disable quota and
> retry with 4m.

Umm... I don't think so.
Writing (or truncating) succeeds if sync is executed before writing 4MB.
Therefore, I think that there are some problems in quota.

===============================================================

# mkfs.btrfs -f /dev/sdc2

WARNING! - Btrfs v3.12 IS EXPERIMENTAL
WARNING! - see http://btrfs.wiki.kernel.org before using

Turning ON incompat feature 'extref': increased hardlink limit per file to 65536
fs created label (null) on /dev/sdc2
        nodesize 16384 leafsize 16384 sectorsize 4096 size 9.31GiB
Btrfs v3.12
# mount /dev/sdc2 /test8
# btrfs quota enable /test8
# btrfs qgroup limit 5M /test8
# dd if=/dev/zero of=/test8/file1 bs=10M count=1
dd: error writing '/test8/file1': Disk quota exceeded
1+0 records in
0+0 records out
5160960 bytes (5.2 MB) copied, 0.012274 s, 420 MB/s
# ls -ls /test8/file1
5040 -rw-r--r-- 1 root root 5160960 Jan  7 09:54 /test8/file1
# truncate -s 0 /test8/file1
truncate: failed to truncate '/test8/file1' at 0 bytes: Disk quota exceeded
# ls -ls /test8/file1
5040 -rw-r--r-- 1 root root 5160960 Jan  7 09:54 /test8/file1
# dd if=/dev/zero of=/test8/file1 bs=4M count=1
dd: failed to open '/test8/file1': Disk quota exceeded
# ls -ls /test8/file1
5040 -rw-r--r-- 1 root root 5160960 Jan  7 09:54 /test8/file1
#

---------------------------------------------------------------

# mkfs.btrfs -f /dev/sdc2

WARNING! - Btrfs v3.12 IS EXPERIMENTAL
WARNING! - see http://btrfs.wiki.kernel.org before using

Turning ON incompat feature 'extref': increased hardlink limit per file to 65536
fs created label (null) on /dev/sdc2
        nodesize 16384 leafsize 16384 sectorsize 4096 size 9.31GiB
Btrfs v3.12
# mount /dev/sdc2 /test8
# btrfs quota enable /test8
# btrfs qgroup limit 5M /test8
# dd if=/dev/zero of=/test8/file1 bs=10M count=1
dd: error writing '/test8/file1': Disk quota exceeded
1+0 records in
0+0 records out
5160960 bytes (5.2 MB) copied, 0.0120232 s, 429 MB/s
# ls -ls /test8/file1
5040 -rw-r--r-- 1 root root 5160960 Jan  7 09:54 /test8/file1
# btrfs filesystem sync /test8
FSSync '/test8'
# truncate -s 0 /test8/file1
# ls -ls /test8/file1
0 -rw-r--r-- 1 root root 0 Jan  7 09:54 /test8/file1
# dd if=/dev/zero of=/test8/file1 bs=4M count=1
1+0 records in
1+0 records out
4194304 bytes (4.2 MB) copied, 0.00734557 s, 571 MB/s
# ls -ls /test8/file1
4096 -rw-r--r-- 1 root root 4194304 Jan  7 09:54 /test8/file1
#

===============================================================

Thanks,
Tsutomu

> 
> # btrfs qgroup limit none /mnt <------------- in case we are nearly full
> and we can not delete file.
> # rm -rf /mnt/data && btrfs filesystem sync /mnt
> # btrfs qgroup limit 5m /mnt
> # dd if=/dev/zero of=/mnt bs=4m count=1
> 
> Please correct me if i miss something here.^_^
> 
> Thanks,
> Wang
>> Thanks,
>> Tsutomu
>>
>>>    }
>>>    
>>>    _scratch_mkfs > /dev/null 2>&1
>>>
>>
> 


