Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from port-92-195-115-244.dynamic.qsc.de ([92.195.115.244]:48186 "EHLO
	richtercloud.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751736AbbBQEYx (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 16 Feb 2015 23:24:53 -0500
Message-ID: <54E2C0FC.8030300@richtercloud.de>
Date: Tue, 17 Feb 2015 05:18:04 +0100
From: Karl-Philipp Richter <richter@richtercloud.de>
MIME-Version: 1.0
To: Tim DeNike <tim@denike.us>, Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: btrfs check --init-csum-tree removes csums again
References: <54E05DCD.3050508@richtercloud.de>	<CAJCQCtSSeSbb9r=f830k=5UjKkw=3huE6H_o3oqNWYg2UFJTwg@mail.gmail.com>	<54E1AD61.7010007@cn.fujitsu.com> <CAEr6y+VaV_d6rg3mobkKRQbm5oV0LjUu+Xv-14sx6Rg3fDVLLg@mail.gmail.com> <54E1D25C.4090900@richtercloud.de>
In-Reply-To: <54E1D25C.4090900@richtercloud.de>
Content-Type: multipart/mixed;
 boundary="------------070306000602050801080607"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is a multi-part message in MIME format.
--------------070306000602050801080607
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit

Hi,
Now I could rebuild the csum tree with `--repair --init-csum-tree` with
3.18.2 on Linux 3.19, see the attached output for the things which were
fixed and probably caused the problem.

Thanks for your suggestions!

Best regards,
Kalle

Am 16.02.2015 um 12:19 schrieb Karl-Philipp Richter:
> Hi,
> I get the same output except some differences in address offsets:
> 
>     $ sudo btrfs check --init-csum-tree /dev/disk/by-uuid/bd6298ea-
> 0748-45fe-87c8-eace6793ca89
>     Creating a new CRC tree
>     Checking filesystem on
> /dev/disk/by-uuid/bd6298ea-0748-45fe-87c8-eace6793ca89
>     UUID: bd6298ea-0748-45fe-87c8-eace6793ca89
>     Reinit crc root
>     extent-tree.c:2657: btrfs_reserve_extent: Assertion `ret` failed.
>     btrfs[0x43da2a]
>     btrfs(btrfs_reserve_extent+0xb63)[0x44347a]
>     btrfs(btrfs_alloc_free_block+0x5a)[0x4434f5]
>     btrfs[0x4368db]
>     btrfs(btrfs_search_slot+0x11d1)[0x438652]
>     btrfs(btrfs_csum_file_block+0x3ce)[0x447b35]
>     btrfs(cmd_check+0xf76)[0x426191]
>     btrfs(main+0x15d)[0x40993d]
>     /lib/x86_64-linux-gnu/libc.so.6(__libc_start_main+0xf5)[0x7fe6b0807ec5]
>     btrfs[0x4094f9]
> 
> with 3.18.2 and 3.19-rc2. The check runs for hours completing reading up
> to 90 % of the device.
> 
> Find kern.log attached, but there's nothing in it afaik except 1
> trillion complaints about missing csums... In case you wonder why
> there're so many segmentation faults in crucial programs - It's from an
> Ubuntu 14.10 system ;). I'm running the amd64 version.
> 
> Best regards,
> Kalle
> 
> Am 16.02.2015 um 11:21 schrieb Tim DeNike:
>> I just ran through with vanilla 3.19 kernel and btrfs-progs 3.18.2
>> with the same result.  Nothing in kernel log at all. Output of btrfs
>> check below.
>>
>> [root@938el btrfs-progs]# ./btrfs check --repair --init-csum-tree /dev/sda
>> enabling repair mode
>> Creating a new CRC tree
>> Checking filesystem on /dev/sda
>> UUID: 1de92eed-c588-4471-b853-7f6a0a22c9a6
>> Reinit crc root
>> extent-tree.c:2657: btrfs_reserve_extent: Assertion `ret` failed.
>> ./btrfs[0x43c93f]
>> ./btrfs(btrfs_reserve_extent+0xaf8)[0x441f83]
>> ./btrfs(btrfs_alloc_free_block+0x57)[0x44202b]
>> ./btrfs[0x435805]
>> ./btrfs(btrfs_search_slot+0x12ce)[0x437666]
>> ./btrfs(btrfs_csum_file_block+0x3c2)[0x4462d4]
>> ./btrfs(cmd_check+0xf7d)[0x42564e]
>> ./btrfs(main+0x15d)[0x4098e1]
>> /lib64/libc.so.6(__libc_start_main+0xf5)[0x7fdb99224af5]
>> ./btrfs[0x409499]
>> [root@938el btrfs-progs]# ./btrfs --version
>> Btrfs v3.18.2
>>
>> On Mon, Feb 16, 2015 at 3:42 AM, Qu Wenruo <quwenruo@cn.fujitsu.com> wrote:
>>>
>>> -------- Original Message --------
>>> Subject: Re: btrfs check --init-csum-tree removes csums again
>>> From: Chris Murphy <lists@colorremedies.com>
>>> To: Karl-Philipp Richter <richter@richtercloud.de>
>>> Date: 2015年02月16日 13:59
>>>>
>>>> On Sun, Feb 15, 2015 at 1:50 AM, Karl-Philipp Richter
>>>> <richter@richtercloud.de> wrote:
>>>>>
>>>>> Hi,
>>>>> After running `btrfs check --init-csum-tree` 3.18.2 and 3.19-rc2 on a
>>>>> btrfs all checksums are gone (thousands of line in the form of `no csum
>>>>> found for inode X start Y` in `/var/log/kern.log`). I know that this
>>>>> behavior (to delete all csums) was a stub in a dev version and remember
>>>>> that it was fixed and that I even fixed a csum tree at one point. Could
>>>>> someone please confirm and maybe even point me to a working version?
>>>>
>>>> I just tried this on CentOS 7 with kernel-3.19-0 and
>>>> btrfs-progs-3.18.2 (from Fedora 21) and it rebuilt the csums, and took
>>>> a little while to do it, unlike 3.12 which was very fast by just
>>>> removing the csums. So... worksforme. However I used it with --repair,
>>>> not by itself.
>>>>
>>>>
>>> The behavior that deletes all csum tree but not to rebuilt them maybe a bug
>>> happens when extent tree is also
>>> corrupted or with '--init-extent-tree' in 3.18.2.
>>>
>>> And --init-csum-tree should imply --repair, so Chris' result should also be
>>> OK.
>>>
>>> To Karl:
>>> Would you please provide the full output of "btrfs check --init-csum-tree"
>>> and the kernel log?
>>> IMHO this should help to find the bug in btrfsck.
>>>
>>> Thanks,
>>> Qu
>>>
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

--------------070306000602050801080607
Content-Type: application/x-xz;
 name="btrfs_csum_reconstruction.log.tar.xz"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="btrfs_csum_reconstruction.log.tar.xz"

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
--------------070306000602050801080607--
