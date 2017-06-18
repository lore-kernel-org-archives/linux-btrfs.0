Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.22]:59133 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750995AbdFRLX0 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 18 Jun 2017 07:23:26 -0400
Subject: Re: [PATCH v3] btrfs: fiemap: Cache and merge fiemap extent before
 submit it to user
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Adam Borowski <kilobyte@angband.pl>
Cc: dsterba@suse.cz, Qu Wenruo <quwenruo@cn.fujitsu.com>,
        linux-btrfs@vger.kernel.org, bo.li.liu@oracle.com
References: <20170407024315.30685-1-quwenruo@cn.fujitsu.com>
 <20170616123352.GF25451@twin.jikos.cz>
 <92aae99b-2c1a-2c66-1291-a0ef73c58b16@gmx.com>
 <20170617083058.7z67mw4622oa7ajo@angband.pl>
 <48fbf1c1-6b7b-a886-2355-bac5ec3f79ba@gmx.com>
 <20170617212451.w7i3xqjv4rie57dw@angband.pl>
 <2d08d805-9e8e-38b1-b1cd-b8ae31db058a@gmx.com>
Message-ID: <5c63eef9-ff8e-6374-6a19-7e52f14dd18a@gmx.com>
Date: Sun, 18 Jun 2017 19:23:00 +0800
MIME-Version: 1.0
In-Reply-To: <2d08d805-9e8e-38b1-b1cd-b8ae31db058a@gmx.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 2017年06月18日 17:38, Qu Wenruo wrote:
> 
> 
> On 2017年06月18日 05:24, Adam Borowski wrote:
>> On Sat, Jun 17, 2017 at 09:28:30PM +0800, Qu Wenruo wrote:
>>>> I for one get this a lot even in regular use.  Somehow, it always 
>>>> has Comm:
>>>> dpkg, despite the vast majority of activity on the system obviously not
>>>> being dpkg.
>>
>>> linus/master without any extra patch is still the same?
>>> And which commit?
>>> I'm using 1439ccf73d9c07654fdd5b4969fd53c2feb8684d, at least it doesn't
>>> cause any warning the related test case, and I tried several combination
>>> with preallocated and written and hole, still no chance.
>>
>> Current linus/master:
>>
>> [   39.726099] ------------[ cut here ]------------
>> [   39.726109] WARNING: CPU: 5 PID: 3382 at fs/btrfs/extent_io.c:4484 
>> extent_fiemap+0x651/0x710
>> [   39.726110] Modules linked in: cp210x pl2303 usbserial nouveau 
>> video ttm
>> [   39.726120] CPU: 5 PID: 3382 Comm: dpkg Not tainted 
>> 4.12.0-rc5-debug-00219-gadc311034c35 #1
>> [   39.726122] Hardware name: System manufacturer System Product 
>> Name/M4A77T, BIOS 2401    05/18/2011
>> [   39.726124] task: ffff880220844140 task.stack: ffffc90001b88000
>> [   39.726127] RIP: 0010:extent_fiemap+0x651/0x710
>> [   39.726129] RSP: 0018:ffffc90001b8bd60 EFLAGS: 00010202
>> [   39.726131] RAX: ffff88021824c800 RBX: 0000000000020000 RCX: 
>> 0000000000000000
>> [   39.726132] RDX: 0000000000000000 RSI: ffff880217fae9a0 RDI: 
>> ffff8802205d6000
>> [   39.726134] RBP: ffffc90001b8be60 R08: 0000000000020000 R09: 
>> 0000000000000000
>> [   39.726135] R10: ffffffffffffffff R11: ffff880217fae9a0 R12: 
>> 0000000000020000
>> [   39.726137] R13: 0000000000000000 R14: ffff880223685480 R15: 
>> ffff880223685480
>> [   39.726139] FS:  00007f45c1726400(0000) GS:ffff88022fd40000(0000) 
>> knlGS:0000000000000000
>> [   39.726140] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>> [   39.726142] CR2: 000055e152d64000 CR3: 0000000213a8c000 CR4: 
>> 00000000000006e0
>> [   39.726143] Call Trace:
>> [   39.726149]  ? btrfs_get_extent+0xa60/0xa60
>> [   39.726153]  btrfs_fiemap+0x4d/0x60
>> [   39.726156]  do_vfs_ioctl+0x3bc/0x5e0
>> [   39.726159]  SyS_ioctl+0x86/0xa0
>> [   39.726163]  entry_SYSCALL_64_fastpath+0x17/0x98
>> [   39.726165] RIP: 0033:0x7f45c103fe07
>> [   39.726166] RSP: 002b:00007ffe327ecd88 EFLAGS: 00000246 ORIG_RAX: 
>> 0000000000000010
>> [   39.726169] RAX: ffffffffffffffda RBX: 000055e1528a8d60 RCX: 
>> 00007f45c103fe07
>> [   39.726170] RDX: 00007ffe327ecdd0 RSI: 00000000c020660b RDI: 
>> 000000000000000a
>> [   39.726171] RBP: 0000000000000548 R08: 000000000000002b R09: 
>> 0000000000000052
>> [   39.726173] R10: 000000000000000a R11: 0000000000000246 R12: 
>> 00007ffe327ecda0
>> [   39.726174] R13: 000055e150c12147 R14: ffffffffffffffff R15: 
>> 00000000000000a9
>> [   39.726175] Code: 04 fe ff ff 45 85 ed 4d 89 f7 0f 85 a6 fd ff ff 
>> 45 31 ed 80 7d 8f 00 48 8b 85 40 ff ff ff 48 8b b8 f0 01 00 00 0f 84 
>> 8b fd ff ff <0f> ff 4c 8b 6d a8 44 8b 65 88 48 c7 c6 90 c9 db 81 4c 8b 
>> 75 80
>> [   39.726210] ---[ end trace 25106b0204355180 ]---
>> [   39.726215] BTRFS warning (device sda1): unhandled fiemap cache 
>> detected: offset=phys$35798867968 len1072 flags=0x2008


Well, still no good news.

I created file extents which returns 0x2008 and the last extent with 0x9.
But still failed to reproduce the error message.

BTW, I noticed that your output is a little strange.
Normally we should have "offset=%llu phys=%llu len=%llu and flags=0x%x".

But your output seems a little out of shape.
And further more, the len (if it's correct) is not aligned even to 512 
bytes.

Seems something went wrong totally.

Thanks,
Qu

>>
> 
> Shared and encoded?
> 
> The length seems to be quite strange, maybe a compressed inline extent.
> 
> I'll try that when I'm back from LinuxCon China.
> 
> Thanks,
> Qu
> 
>>> I also ran btrfs/* with my patch applied on v4.11-rc2 (sorry, that's the
>>> correct original patch base), and except some known bug, it doesn't 
>>> cause
>>> anything special.
>>
>> 4.11-rc2 with nothing but 4751832d applied:
>>
>> [  151.838761] ------------[ cut here ]------------
>> [  151.839176] WARNING: CPU: 0 PID: 2074 at fs/btrfs/extent_io.c:4460 
>> extent_fiemap+0x662/0x740
>> [  151.840465] Modules linked in: pl2303 cp210x usbserial nouveau 
>> video ttm
>> [  151.842509] CPU: 0 PID: 2074 Comm: dpkg Not tainted 
>> 4.11.0-rc2-debug-00001-g2dbdec6c76b4 #1
>> [  151.844457] Hardware name: System manufacturer System Product 
>> Name/M4A77T, BIOS 2401    05/18/2011
>> [  151.846551] Call Trace:
>> [  151.848625]  dump_stack+0x4d/0x6d
>> [  151.850636]  __warn+0xd3/0xf0
>> [  151.852589]  warn_slowpath_null+0x18/0x20
>> [  151.854552]  extent_fiemap+0x662/0x740
>> [  151.856466]  ? btrfs_get_extent+0xa60/0xa60
>> [  151.858400]  btrfs_fiemap+0x4d/0x60
>> [  151.860323]  do_vfs_ioctl+0x3bc/0x5e0
>> [  151.862216]  SyS_ioctl+0x86/0xa0
>> [  151.864183]  entry_SYSCALL_64_fastpath+0x17/0x98
>> [  151.866071] RIP: 0033:0x7f542e763e07
>> [  151.868045] RSP: 002b:00007fff9d737188 EFLAGS: 00000246 ORIG_RAX: 
>> 0000000000000010
>> [  151.869995] RAX: ffffffffffffffda RBX: 000055cbf323bd80 RCX: 
>> 00007f542e763e07
>> [  151.872086] RDX: 00007fff9d7371d0 RSI: 00000000c020660b RDI: 
>> 000000000000000a
>> [  151.874127] RBP: 0000000000000548 R08: 000000000000002b R09: 
>> 0000000000000052
>> [  151.876246] R10: 000000000000000a R11: 0000000000000246 R12: 
>> 00007fff9d7371a0
>> [  151.878292] R13: 000055cbf28aa147 R14: ffffffffffffffff R15: 
>> 00000000000000a9
>> [  151.880487] ---[ end trace 135594ab8f41eada ]---
>> [  151.882586] BTRFS warning (device sda1): unhandled fiemap cache 
>> detected: offset=phys$35798867968 len1072 flags=0x2008
>>
>>
>> 喵!
>>
> -- 
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
