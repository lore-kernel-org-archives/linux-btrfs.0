Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.virtall.com ([178.63.195.102]:35536 "EHLO mail.virtall.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753933AbbFOKbS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 15 Jun 2015 06:31:18 -0400
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Subject: Re: kernel crashes with btrfs and busy database IO - how to debug?
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Date: Mon, 15 Jun 2015 19:31:15 +0900
From: Tomasz Chmielewski <tch@virtall.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
In-Reply-To: <557E8860.3080307@cn.fujitsu.com>
References: <ae9b9ca434c98509ca6c1ba6dbd84b63@admin.virtall.com>
 <557A8691.6070908@cn.fujitsu.com>
 <73cb882c23a71c9039a0e7bbfddfab64@admin.virtall.com>
 <557AA1B9.9040009@cn.fujitsu.com>
 <cf09b22a06bf52a5b365fa44e15583f7@admin.virtall.com>
 <f96134ed2c586f25fa959234fc525ab9@admin.virtall.com>
 <40998423616120fecd531f31971b0b8b@admin.virtall.com>
 <557E8860.3080307@cn.fujitsu.com>
Message-ID: <866a1890f369531a673a901df8ac5c89@admin.virtall.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

Do you want me to produce one more crash / hang? I had to restart the 
hanged server (via echo b > /proc/sysrq-trigger).


Tomasz


On 2015-06-15 17:10, Qu Wenruo wrote:
> Now we can get the full backtrace.
> That's a step forward
> 
> [45705.854778] BUG: unable to handle kernel NULL pointer dereference
> at 0000000000000008
> [45705.854824] IP: [<ffffffffc0158b8e>]
> btrfs_wait_pending_ordered+0x5e/0x110 [btrfs]
> [45705.855615] Call Trace:
> [45705.855637]  [<ffffffffc015addb>]
> btrfs_commit_transaction+0x40b/0xb60 [btrfs]
> [45705.855671]  [<ffffffff810c0700>] ? 
> prepare_to_wait_event+0x100/0x100
> [45705.855698]  [<ffffffffc0171973>] btrfs_sync_file+0x313/0x380 
> [btrfs]
> [45705.855721]  [<ffffffff81236c26>] vfs_fsync_range+0x46/0xc0
> [45705.855740]  [<ffffffff81236cbc>] vfs_fsync+0x1c/0x20
> [45705.855758]  [<ffffffff81236cf8>] do_fsync+0x38/0x70
> [45705.855777]  [<ffffffff812370d0>] SyS_fsync+0x10/0x20
> [45705.855796]  [<ffffffff8180cbb2>] system_call_fastpath+0x16/0x75
> 
> Also the hang seems to be highly related to the bug,
> would you please send a new mail reporting the hang?
> 
> Thanks,
> Qu
> 
> 在 2015年06月14日 15:58, Tomasz Chmielewski 写道:
>> On 2015-06-14 09:30, Tomasz Chmielewski wrote:
>>> On 2015-06-13 08:23, Tomasz Chmielewski wrote:
>>> 
>>>> I did get it from /var/crash/ though - is it more useful? I don't 
>>>> have
>>>> vmlinux for this kernel though, but have just built 4.1-rc7 with the
>>>> same config, can try to get the crash there.
>>> 
>>> I've uploaded a crash dump and vmlinux here:
>>> 
>>> http://www.virtall.com/files/temp/201506132321/
>>> 
>>> Let me know if it's anything useful or if you need more info.
>> 
>> I've tried running it the same procedure to get one more crash, but it
>> didn't crash this time.
>> 
>> Instead, btrfs is hanged on any writes - any processes trying to write
>> get into D state and never return; there is no write activity when
>> checking for example with iostat. "sync" command does not return.
>> 
>> Reads from this btrfs filesystem are OK.
>> 
>> I've uploaded the output of "echo w > /proc/sysrq-trigger" here:
>> 
>> http://www.virtall.com/files/temp/dmesg.txt
>> 
>> 
>> Tomasz Chmielewski
>> 
Hello,

sorry, not sure what you mean.

Do you want me to produce one more crash / or hang?

