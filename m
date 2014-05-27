Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp.domeneshop.no ([194.63.252.54]:50510 "EHLO
	smtp.domeneshop.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751591AbaE0UmZ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 27 May 2014 16:42:25 -0400
Message-ID: <5384F8A4.1050206@skagestad.org>
Date: Tue, 27 May 2014 22:42:12 +0200
From: =?ISO-8859-1?Q?Torbj=F8rn?= <lists@skagestad.org>
MIME-Version: 1.0
To: linux-btrfs <linux-btrfs@vger.kernel.org>
CC: Chris Mason <clm@fb.com>
Subject: Re: 3.15-rc6 - btrfs-transacti:4157 blocked for more than 120 seconds.
References: <5384D53C.9070509@skagestad.org> <5384E2FA.1070509@fb.com> <5384F0B4.7040309@skagestad.org>
In-Reply-To: <5384F0B4.7040309@skagestad.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 05/27/2014 10:08 PM, Torbjørn wrote:
> On 05/27/2014 09:09 PM, Chris Mason wrote:
>>
>> On 05/27/2014 02:11 PM, Torbjørn wrote:
>>> Hi,
>>>
>>> Btrfs-transaction keeps blocking for me on all 3.15-rc versions.
>>> 3.14 does not have this issue.
>>> The process never gets unstuck. btrfs fi sync does not help. A hard
>>> reboot seems to be the only way to recover.
>>>
>>> The volume is still readable when it's in this state.
>>>
>>> dmesg + sysrq-w is available at
>>> https://urldefense.proofpoint.com/v1/url?u=http://pastebin.com/vHQnRE2F&k=ZVNjlDMF0FElm4dQtryO4A%3D%3D%0A&r=6%2FL0lzzDhu0Y1hL9xm%2BQyA%3D%3D%0A&m=IKSs%2F0C3x9a0LIiVKFmZVoP9lSAZ%2BK9JgEkchLEAAzM%3D%0A&s=127b40cc34dbb205b5277e6081b082f26e84fc417d35310f3aeee04998a679a8 
>>>
>>>
>>> It's over 6000 lines, and would most likely not be allowed on the list.
>>>
>>> The blocking happons on a server with local kvm-clients reading and
>>> writing to a local btrfs-volume over nfs.
>>> The btrfs-volume is on top of dm-crypt devices.
>>>
>>> Any additional info I can give to help?
>>> Tests you want me to run?
>> Very strange, since I don't actually see what we're waiting for.  Can
>> you please either send me your btrfs.ko or use gdb to see where this
>> statement is:
>>
>>
>> btrfs_commit_transaction+0x315
>>
>> The syntax is
>>
>> gdb btrfs.ko
>> gdb> list *btrfs_commit_transaction+0x315
>>
>> -chris
> Sure, here you go.
>
> Reading symbols from btrfs.ko...done.
> (gdb) list *btrfs_commit_transaction+0x315
> 0x30f95 is in btrfs_commit_transaction (fs/btrfs/transaction.c:1752).
> 1747         * COMMIT_DOING so make sure to wait for num_writers to == 
> 1 again.
> 1748         */
> 1749        spin_lock(&root->fs_info->trans_lock);
> 1750        cur_trans->state = TRANS_STATE_COMMIT_DOING;
> 1751        spin_unlock(&root->fs_info->trans_lock);
> 1752        wait_event(cur_trans->writer_wait,
> 1753               atomic_read(&cur_trans->num_writers) == 1);
> 1754
> 1755        /* ->aborted might be set after the previous check, so 
> check it */
> 1756        if (unlikely(ACCESS_ONCE(cur_trans->aborted))) {
> (gdb)
>
> I'm attaching the btrfs.ko as well, hopefully the 20M file gets through.
> -- 
> Torbjørn
Seems like the attachment stopped the email from reaching the list.
Resending with only debug info.

--
Torbjørn
