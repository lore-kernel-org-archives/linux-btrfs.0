Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from port-92-195-67-144.dynamic.qsc.de ([92.195.67.144]:40975 "EHLO
	richtercloud.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755794AbbBPL3t (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 16 Feb 2015 06:29:49 -0500
Message-ID: <54E1D25C.4090900@richtercloud.de>
Date: Mon, 16 Feb 2015 12:19:56 +0100
From: Karl-Philipp Richter <richter@richtercloud.de>
MIME-Version: 1.0
To: Tim DeNike <tim@denike.us>, Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: btrfs check --init-csum-tree removes csums again
References: <54E05DCD.3050508@richtercloud.de>	<CAJCQCtSSeSbb9r=f830k=5UjKkw=3huE6H_o3oqNWYg2UFJTwg@mail.gmail.com>	<54E1AD61.7010007@cn.fujitsu.com> <CAEr6y+VaV_d6rg3mobkKRQbm5oV0LjUu+Xv-14sx6Rg3fDVLLg@mail.gmail.com>
In-Reply-To: <CAEr6y+VaV_d6rg3mobkKRQbm5oV0LjUu+Xv-14sx6Rg3fDVLLg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,
I get the same output except some differences in address offsets:

    $ sudo btrfs check --init-csum-tree /dev/disk/by-uuid/bd6298ea-
0748-45fe-87c8-eace6793ca89
    Creating a new CRC tree
    Checking filesystem on
/dev/disk/by-uuid/bd6298ea-0748-45fe-87c8-eace6793ca89
    UUID: bd6298ea-0748-45fe-87c8-eace6793ca89
    Reinit crc root
    extent-tree.c:2657: btrfs_reserve_extent: Assertion `ret` failed.
    btrfs[0x43da2a]
    btrfs(btrfs_reserve_extent+0xb63)[0x44347a]
    btrfs(btrfs_alloc_free_block+0x5a)[0x4434f5]
    btrfs[0x4368db]
    btrfs(btrfs_search_slot+0x11d1)[0x438652]
    btrfs(btrfs_csum_file_block+0x3ce)[0x447b35]
    btrfs(cmd_check+0xf76)[0x426191]
    btrfs(main+0x15d)[0x40993d]
    /lib/x86_64-linux-gnu/libc.so.6(__libc_start_main+0xf5)[0x7fe6b0807ec5]
    btrfs[0x4094f9]

with 3.18.2 and 3.19-rc2. The check runs for hours completing reading up
to 90 % of the device.

Find kern.log attached, but there's nothing in it afaik except 1
trillion complaints about missing csums... In case you wonder why
there're so many segmentation faults in crucial programs - It's from an
Ubuntu 14.10 system ;). I'm running the amd64 version.

Best regards,
Kalle

Am 16.02.2015 um 11:21 schrieb Tim DeNike:
> I just ran through with vanilla 3.19 kernel and btrfs-progs 3.18.2
> with the same result.  Nothing in kernel log at all. Output of btrfs
> check below.
> 
> [root@938el btrfs-progs]# ./btrfs check --repair --init-csum-tree /dev/sda
> enabling repair mode
> Creating a new CRC tree
> Checking filesystem on /dev/sda
> UUID: 1de92eed-c588-4471-b853-7f6a0a22c9a6
> Reinit crc root
> extent-tree.c:2657: btrfs_reserve_extent: Assertion `ret` failed.
> ./btrfs[0x43c93f]
> ./btrfs(btrfs_reserve_extent+0xaf8)[0x441f83]
> ./btrfs(btrfs_alloc_free_block+0x57)[0x44202b]
> ./btrfs[0x435805]
> ./btrfs(btrfs_search_slot+0x12ce)[0x437666]
> ./btrfs(btrfs_csum_file_block+0x3c2)[0x4462d4]
> ./btrfs(cmd_check+0xf7d)[0x42564e]
> ./btrfs(main+0x15d)[0x4098e1]
> /lib64/libc.so.6(__libc_start_main+0xf5)[0x7fdb99224af5]
> ./btrfs[0x409499]
> [root@938el btrfs-progs]# ./btrfs --version
> Btrfs v3.18.2
> 
> On Mon, Feb 16, 2015 at 3:42 AM, Qu Wenruo <quwenruo@cn.fujitsu.com> wrote:
>>
>> -------- Original Message --------
>> Subject: Re: btrfs check --init-csum-tree removes csums again
>> From: Chris Murphy <lists@colorremedies.com>
>> To: Karl-Philipp Richter <richter@richtercloud.de>
>> Date: 2015年02月16日 13:59
>>>
>>> On Sun, Feb 15, 2015 at 1:50 AM, Karl-Philipp Richter
>>> <richter@richtercloud.de> wrote:
>>>>
>>>> Hi,
>>>> After running `btrfs check --init-csum-tree` 3.18.2 and 3.19-rc2 on a
>>>> btrfs all checksums are gone (thousands of line in the form of `no csum
>>>> found for inode X start Y` in `/var/log/kern.log`). I know that this
>>>> behavior (to delete all csums) was a stub in a dev version and remember
>>>> that it was fixed and that I even fixed a csum tree at one point. Could
>>>> someone please confirm and maybe even point me to a working version?
>>>
>>> I just tried this on CentOS 7 with kernel-3.19-0 and
>>> btrfs-progs-3.18.2 (from Fedora 21) and it rebuilt the csums, and took
>>> a little while to do it, unlike 3.12 which was very fast by just
>>> removing the csums. So... worksforme. However I used it with --repair,
>>> not by itself.
>>>
>>>
>> The behavior that deletes all csum tree but not to rebuilt them maybe a bug
>> happens when extent tree is also
>> corrupted or with '--init-extent-tree' in 3.18.2.
>>
>> And --init-csum-tree should imply --repair, so Chris' result should also be
>> OK.
>>
>> To Karl:
>> Would you please provide the full output of "btrfs check --init-csum-tree"
>> and the kernel log?
>> IMHO this should help to find the bug in btrfsck.
>>
>> Thanks,
>> Qu
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
