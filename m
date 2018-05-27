Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:43103 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S967010AbeE1Pxu (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 28 May 2018 11:53:50 -0400
Subject: Re: csum failed root raveled during balance
To: Andrei Borzenkov <arvidjaar@gmail.com>, ein <ein.net@gmail.com>,
        linux-btrfs@vger.kernel.org
References: <5B047817.3040106@gmail.com>
 <e04ab862-abe3-7187-1519-b89776df9362@suse.com>
 <66a664ef-63a3-d897-744f-57d6f7d6975f@gmail.com>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <c39be3aa-e45e-daad-9342-f35959def35c@suse.com>
Date: Sun, 27 May 2018 12:41:37 +0300
MIME-Version: 1.0
In-Reply-To: <66a664ef-63a3-d897-744f-57d6f7d6975f@gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 27.05.2018 08:50, Andrei Borzenkov wrote:
> 23.05.2018 09:32, Nikolay Borisov пишет:
>>
>>
>> On 22.05.2018 23:05, ein wrote:
>>> Hello devs,
>>>
>>> I tested BTRFS in production for about a month:
>>>
>>> 21:08:17 up 34 days,  2:21,  3 users,  load average: 0.06, 0.02, 0.00
>>>
>>> Without power blackout, hardware failure, SSD's SMART is flawless etc.
>>> The tests ended with:
>>>
>>> root@node0:~# dmesg | grep BTRFS | grep warn
>>> 185:980:[2927472.393557] BTRFS warning (device dm-0): csum failed root
>>> -9 ino 312 off 608284672 csum 0x7d03a376 expected csum 0x3163a9b7 mirror 1
>>> 186:981:[2927472.394158] BTRFS warning (device dm-0): csum failed root
>>> -9 ino 312 off 608284672 csum 0x7da1b152 expected csum 0x3163a9b7 mirror 1
>>> 191:986:[2928224.169814] BTRFS warning (device dm-0): csum failed root
>>> -9 ino 314 off 608284672 csum 0x7d03a376 expected csum 0x3163a9b7 mirror 1
>>> 192:987:[2928224.171433] BTRFS warning (device dm-0): csum failed root
>>> -9 ino 314 off 608284672 csum 0x7da1b152 expected csum 0x3163a9b7 mirror 1
>>> 206:1001:[2928298.039516] BTRFS warning (device dm-0): csum failed root
>>> -9 ino 319 off 608284672 csum 0x7d03a376 expected csum 0x3163a9b7 mirror 1
>>> 207:1002:[2928298.043103] BTRFS warning (device dm-0): csum failed root
>>> -9 ino 319 off 608284672 csum 0x7d03a376 expected csum 0x3163a9b7 mirror 1
>>> 208:1004:[2932213.513424] BTRFS warning (device dm-0): csum failed root
>>> 5 ino 219962 off 4564959232 csum 0xc616afb4 expected csum 0x5425e489
>>> mirror 1
>>> 209:1005:[2932235.666368] BTRFS warning (device dm-0): csum failed root
>>> 5 ino 219962 off 16989835264 csum 0xd63ed5da expected csum 0x7429caa1
>>> mirror 1
>>> 210:1072:[2936767.229277] BTRFS warning (device dm-0): csum failed root
>>> 5 ino 219915 off 82318458880 csum 0x83614341 expected csum 0x0b8706f8
>>> mirror 1
>>> 211:1073:[2936767.276229] BTRFS warning (device dm-0): csum failed root
>>> 5 ino 219915 off 82318458880 csum 0x83614341 expected csum 0x0b8706f8
>>> mirror 1
>>>
>>> Above has been revealed during below command and quite high IO usage by
>>> few VMs (Linux on top Ext4 with firebird database, lots of random
>>> read/writes, two others with Windows 2016 and Windows Update in the
>>> background):
>>
>> I believe you are hitting the issue described here:
>>
>> https://www.mail-archive.com/linux-btrfs@vger.kernel.org/msg25656.html
>>
>> Essentially the way qemu operates on vm images atop btrfs is prone to
>> producing such errors. As a matter of fact, other filesystems also
>> suffer from this(i.e pages modified while being written, however due to
>> lack of CRC on the data they don't detect it). Can you confirm that
>> those inodes (312/314/319/219962/219915) belong to vm images files?
>>
>> IMHO the best course of action would be to disable checksumming for you
>> vm files.
>>
>>
>> For some background I suggest you read the following LWN articles:
>>
>> https://lwn.net/Articles/486311/
>> https://lwn.net/Articles/442355/
>>
> 
> Hmm ... according to these articles, "pages under writeback are marked
> as not being writable; any process attempting to write to such a page
> will block until the writeback completes". And it says this feature is
> available since 3.0 and btrfs has it. So how comes it still happens?
> Were stable patches removed since then?

If you are using buffered writes, then yes you won't have the problem.
However qemu by default bypasses host's page cache and instead uses DIO:

https://btrfs.wiki.kernel.org/index.php/Gotchas#Direct_IO_and_CRCs

> 
