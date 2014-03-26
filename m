Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f175.google.com ([209.85.213.175]:47625 "EHLO
	mail-ig0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755203AbaCZTUd (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 26 Mar 2014 15:20:33 -0400
Received: by mail-ig0-f175.google.com with SMTP id ur14so902861igb.2
        for <linux-btrfs@vger.kernel.org>; Wed, 26 Mar 2014 12:20:32 -0700 (PDT)
Message-ID: <5333287F.6000601@gmail.com>
Date: Wed, 26 Mar 2014 15:20:31 -0400
From: Adam Khan <adam.s.khan@gmail.com>
MIME-Version: 1.0
To: Xavier Bassery <xavier@bartica.org>
CC: linux-btrfs@vger.kernel.org
Subject: Re: Please advise on repair action
References: <532931D9.60809@gmail.com> <20140321111701.2502a307@renoir.lan>
In-Reply-To: <20140321111701.2502a307@renoir.lan>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 21/03/14 06:17 AM, Xavier Bassery wrote:
> Le 2014-03-19 06:57, Adam Khan a écrit :
>> Hello,
>>
>> I have a simple btrfs located on a dm-crypt volume. I'm getting a
>> general protection fault when I
>> attempt to access a specific directory in Thunar file manager and in a
>> Python program.
>>
>> The trace is attached for Thunar.
> 
> [  313.491347] general protection fault: 0000 [#1] SMP 
> ...
> [  313.492376] RIP: 0010:[<ffffffff8127c66d>]  [<ffffffff8127c66d>] memcpy+0xd/0x110 ...
> [  313.492804] Call Trace:
> [  313.492836]  [<ffffffffa013f168>] ? read_extent_buffer+0xc8/0x120 [btrfs]
> [  313.492877]  [<ffffffffa0125064>] ? <btrfs_get_extent+0x8f4/0x950 [btrfs]
> ...
> [  313.493293]  [<ffffffff811223ba>] ? ondemand_readahead+0x14a/0x280
> 
>>
>> btrfsck returns this:
>>
>> Checking filesystem on /dev/mapper/xyz_crypt
>> UUID: ...
> 
> Here you've omitted the interesting part (preceding the next line).
> Weren't there lines looking like 
> "root 256 inode XXXX errors 400, nbytes wrong" ?

There is not a detailed error returned by btrfsck. The only part I found
interesting is 'used err is 1', but maybe that is because this was my
first time running btrfsck. No inode errors are reported.

>>found 88316880601 bytes used err is 1
>> total csum bytes: 180423792
>> total tree bytes: 291459072
>> total fs tree bytes: 50192384
>> total extent tree bytes: 12898304
>> btree space waste bytes: 55087032
>> file data blocks allocated: 352826490880
>>  referenced 184697802752
>> Btrfs v3.12
>>
>> How should I proceed to repair this fs?
>>
> 
> this seems to be the same issue as the one described in BZ 68411
> (https://bugzilla.kernel.org/show_bug.cgi?id=68411).
> If I'm correct, the run-time fix is "Btrfs: don't use ram_bytes for
> uncompressed inline items" as said in the bz.
> At the moment this fix is only in 3.14-xx but is expected to come to
> stable too.

I tried running a Debian kernel from experimental (3.14~rc7-1~exp1) but
it won't boot.. I'm missing many modules.
Presumably if the new kernel prevents the crash then the files would be
accessible?

> Also btrfs check is not yet able to repair this. You'll find a
> work-around given in the bug report that involves truncating and
> unlinking the problematic files.

I would try this but btrfsck does not give me any inodes.

> 
> Best regards,
> Xavier
> 
> 

Merci beaucoup pour l'assistance/thank you for the assistance,
Adam
