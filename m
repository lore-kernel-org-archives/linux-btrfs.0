Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:35467 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753162AbaDHBlL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 7 Apr 2014 21:41:11 -0400
Message-ID: <534353EB.9020601@cn.fujitsu.com>
Date: Tue, 8 Apr 2014 09:42:03 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
To: Marc MERLIN <marc@merlins.org>
CC: <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH 24/27] btrfs-progs: Convert man page for btrfs-zero-log
References: <1396427378-10487-1-git-send-email-quwenruo@cn.fujitsu.com> <1396427378-10487-25-git-send-email-quwenruo@cn.fujitsu.com> <20140404184620.GA12124@merlins.org>
In-Reply-To: <20140404184620.GA12124@merlins.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


于 2014年04月05日 02:46, Marc MERLIN 写道:
> On Wed, Apr 02, 2014 at 04:29:35PM +0800, Qu Wenruo wrote:
>> Convert man page for btrfs-zero-log
>>
>> Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
>> ---
>>   Documentation/Makefile           |  2 +-
>>   Documentation/btrfs-zero-log.txt | 39 +++++++++++++++++++++++++++++++++++++++
>>   2 files changed, 40 insertions(+), 1 deletion(-)
>>   create mode 100644 Documentation/btrfs-zero-log.txt
>>
>> diff --git a/Documentation/Makefile b/Documentation/Makefile
>> index e002d53..de06629 100644
>> --- a/Documentation/Makefile
>> +++ b/Documentation/Makefile
>> @@ -11,7 +11,7 @@ MAN8_TXT += btrfs-image.txt
>>   MAN8_TXT += btrfs-map-logical.txt
>>   MAN8_TXT += btrfs-show-super.txt
>>   MAN8_TXT += btrfstune.txt
>> -#MAN8_TXT += btrfs-zero-log.txt
>> +MAN8_TXT += btrfs-zero-log.txt
>>   #MAN8_TXT += fsck.btrfs.txt
>>   #MAN8_TXT += mkfs.btrfs.txt
>>   
>> diff --git a/Documentation/btrfs-zero-log.txt b/Documentation/btrfs-zero-log.txt
>> new file mode 100644
>> index 0000000..e3041fa
>> --- /dev/null
>> +++ b/Documentation/btrfs-zero-log.txt
>> @@ -0,0 +1,39 @@
>> +btrfs-zero-log(8)
>> +=================
>> +
>> +NAME
>> +----
>> +btrfs-zero-log - clear out log tree
>> +
>> +SYNOPSIS
>> +--------
>> +'btrfs-zero-log' <dev>
>> +
>> +DESCRIPTION
>> +-----------
>> +'btrfs-zero-log' will remove the log tree if log tree is corrupt, which will
>> +allow you to mount the filesystem again.
>> +
>> +The common case where this happens has been fixed a long time ago,
>> +so it is unlikely that you will see this particular problem.
> A note on this one: this can happen if your SSD rites things in the
> wrong order or potentially writes garbage when power is lost, or before
> locking up.
> I hit this problem about 10 times and it wasn't a btrfs bug, just the
> drive doing bad things.
>
> I had debian add this to the initramfs initrd by default so that someone
> can recover their root filesystem with this command if it won't mount.
>
> What got fixed is the kernel used to oops and crash, and now it gives a
> nice "can't mount" error message.
>
> Marc
Thanks for the note.

After reading following up mails on the thread, I agree that the note is 
needed.

But I would like to add more method to judge whether to call 
btrfs-zero-log or other tools like btrfsck.

It would be quite nice if any one can provide a log-tree-broken small 
btrfs image for me to test?
(Personally, I would prefer using dmesg warning/backtrace and btrfsck 
result to make sure to call btrfs-zero-log)

P.S: If btrfs can be automatically mounted as RO when log tree is 
broken, it would be better.
But it also seems log tree related things will be improved sooner or 
later, it may not be so urgent.

Thanks,
Qu.
