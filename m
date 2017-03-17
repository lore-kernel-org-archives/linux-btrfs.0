Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:45740 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751098AbdCQCPy (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 16 Mar 2017 22:15:54 -0400
Subject: Re: help!!! error when mount a btrfs file system
To: <bo.li.liu@oracle.com>, =?UTF-8?B?5p2O5LqR55Sr?= <liyunfu@cnkh.com>
References: <6e2f91a1.6cf8.15ad7124e12.Coremail.liyunfu@cnkh.com>
 <20170316173654.GA8145@lim.localdomain>
CC: <linux-btrfs@vger.kernel.org>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <e2797ef8-aa8c-371a-a7dd-2a9ae528f942@cn.fujitsu.com>
Date: Fri, 17 Mar 2017 10:15:50 +0800
MIME-Version: 1.0
In-Reply-To: <20170316173654.GA8145@lim.localdomain>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



At 03/17/2017 01:36 AM, Liu Bo wrote:
> On Thu, Mar 16, 2017 at 08:23:05PM +0800, 李云甫 wrote:
>> hi, buddy
>>
>>    I have a file server with btrfs file system, it's work well for several months.
>>
>> but after last system reboot, the /dev/sdb become not mountable.
>>
>> below is the details.   is there any advise?
>>
>>
>> ######Version info
>> Fedora 25 Server
>> Kernel 4.9.13-201.fc25.x86_64
>> btrfs-progs v4.6.1
>>
>> #####error messages when mount
>> mount: wrong fs type, bad option, bad superblock on /dev/sdb,
>> missing codepage or helper program, or other error
>>
>> In some cases useful info is found in syslog - try
>> dmesg | tail or so.
>>
>> ######dmesg |tail
>> [79570.756871] BTRFS error (device sdb): parent transid verify failed on 21413888 wanted 755660 found 623605
>> [79570.762307] BTRFS error (device sdb): bad tree block start 0 21413888
>> [79570.762345] BTRFS error (device sdb): failed to read chunk tree: -5
>> [79570.778129] BTRFS error (device sdb): open_ctree failed
>> [79589.743772] BTRFS error (device sdb): support for check_integrity* not compiled in!
>> [79589.803176] BTRFS error (device sdb): open_ctree failed
>>
>
> Looks like one node of the chunk tree was zero'd by something, were you use -o discard or fstrim before reboot?
>
> Thanks,
>
> -liubo
>
>> ######btrfsck
>> parent transid verify failed on 21413888 wanted 755660 found 623605
>> parent transid verify failed on 21413888 wanted 755660 found 623605
>> checksum verify failed on 21413888 found E4E3BDB6 wanted 00000000
>> parent transid verify failed on 21413888 wanted 755660 found 623605
>> Ignoring transid failure
>> checksum verify failed on 21331968 found E4E3BDB6 wanted 00000000
>> checksum verify failed on 21331968 found E4E3BDB6 wanted 00000000
>> checksum verify failed on 21692416 found E4E3BDB6 wanted 00000000
>> checksum verify failed on 21692416 found E4E3BDB6 wanted 00000000
>> checksum verify failed on 22888448 found E4E3BDB6 wanted 00000000
>> checksum verify failed on 22888448 found E4E3BDB6 wanted 00000000
>> checksum verify failed on 22888448 found E4E3BDB6 wanted 00000000
>> checksum verify failed on 22888448 found E4E3BDB6 wanted 00000000

I'm afraid not only one, but two chunk tree blocks are zeroed.

While you still have a little chance to recovery chunk tree by using 
backup chunk roots.

Would you please paste the output of "btrfs-show-super -f /dev/sdb"?

Thanks,
Qu

>> bytenr mismatch, want=22888448, have=0
>> Couldn't read chunk tree
>> Couldn't open file system
>>
>> ######btrfs-find-root
>> parent transid verify failed on 21413888 wanted 755660 found 623605
>> parent transid verify failed on 21413888 wanted 755660 found 623605
>> parent transid verify failed on 21413888 wanted 755660 found 623605
>> Ignoring transid failure
>> Couldn't read chunk tree
>> ERROR: open ctree failed
>>
>> ######btrfs-show-super -a /dev/sdb
>> superblock: bytenr=65536, device=/dev/sdb
>> ---------------------------------------------------------
>> csum			0xb6f3ccb1 [match]
>> bytenr			65536
>> flags			0x1
>> ( WRITTEN )
>> magic			_BHRfS_M [match]
>> fsid			7f5aecd6-40fe-45ce-90c3-e86bacc4bf6f
>> label			samba_fs
>> generation		770740
>> root			16187774615552
>> sys_array_size		355
>> chunk_root_generation	755799
>> root_level		1
>> chunk_root		24331161698304
>> chunk_root_level	1
>> log_root		0
>> log_root_transid	0
>> log_root_level		0
>> total_bytes		23999996231680
>> bytes_used		22205028102144
>> sectorsize		4096
>> nodesize		16384
>> leafsize		16384
>> stripesize		4096
>> root_dir		6
>> num_devices		1
>> compat_flags		0x0
>> compat_ro_flags		0x0
>> incompat_flags		0x169
>> ( MIXED_BACKREF |
>> COMPRESS_LZO |
>> BIG_METADATA |
>> EXTENDED_IREF |
>> SKINNY_METADATA )
>> csum_type		0
>> csum_size		4
>> cache_generation	770740
>> uuid_tree_generation	770740
>> dev_item.uuid		dd8c8d66-b6f5-48d8-9d5e-6f56b2ad4751
>> dev_item.fsid		7f5aecd6-40fe-45ce-90c3-e86bacc4bf6f [match]
>> dev_item.type		0
>> dev_item.total_bytes	23999996231680
>> dev_item.bytes_used	23274943676416
>> dev_item.io_align	4096
>> dev_item.io_width	4096
>> dev_item.sector_size	4096
>> dev_item.devid		1
>> dev_item.dev_group	0
>> dev_item.seek_speed	0
>> dev_item.bandwidth	0
>> dev_item.generation	0
>>
>> superblock: bytenr=67108864, device=/dev/sdb
>> ---------------------------------------------------------
>> csum			0x1692e47f [match]
>> bytenr			67108864
>> flags			0x1
>> ( WRITTEN )
>> magic			_BHRfS_M [match]
>> fsid			7f5aecd6-40fe-45ce-90c3-e86bacc4bf6f
>> label			samba_fs
>> generation		770740
>> root			16187774615552
>> sys_array_size		355
>> chunk_root_generation	755799
>> root_level		1
>> chunk_root		24331161698304
>> chunk_root_level	1
>> log_root		0
>> log_root_transid	0
>> log_root_level		0
>> total_bytes		23999996231680
>> bytes_used		22205028102144
>> sectorsize		4096
>> nodesize		16384
>> leafsize		16384
>> stripesize		4096
>> root_dir		6
>> num_devices		1
>> compat_flags		0x0
>> compat_ro_flags		0x0
>> incompat_flags		0x169
>> ( MIXED_BACKREF |
>> COMPRESS_LZO |
>> BIG_METADATA |
>> EXTENDED_IREF |
>> SKINNY_METADATA )
>> csum_type		0
>> csum_size		4
>> cache_generation	770740
>> uuid_tree_generation	770740
>> dev_item.uuid		dd8c8d66-b6f5-48d8-9d5e-6f56b2ad4751
>> dev_item.fsid		7f5aecd6-40fe-45ce-90c3-e86bacc4bf6f [match]
>> dev_item.type		0
>> dev_item.total_bytes	23999996231680
>> dev_item.bytes_used	23274943676416
>> dev_item.io_align	4096
>> dev_item.io_width	4096
>> dev_item.sector_size	4096
>> dev_item.devid		1
>> dev_item.dev_group	0
>> dev_item.seek_speed	0
>> dev_item.bandwidth	0
>> dev_item.generation	0
>>
>> superblock: bytenr=274877906944, device=/dev/sdb
>> ---------------------------------------------------------
>> csum			0xeb15b24e [match]
>> bytenr			274877906944
>> flags			0x1
>> ( WRITTEN )
>> magic			_BHRfS_M [match]
>> fsid			7f5aecd6-40fe-45ce-90c3-e86bacc4bf6f
>> label			samba_fs
>> generation		770740
>> root			16187774615552
>> sys_array_size		355
>> chunk_root_generation	755799
>> root_level		1
>> chunk_root		24331161698304
>> chunk_root_level	1
>> log_root		0
>> log_root_transid	0
>> log_root_level		0
>> total_bytes		23999996231680
>> bytes_used		22205028102144
>> sectorsize		4096
>> nodesize		16384
>> leafsize		16384
>> stripesize		4096
>> root_dir		6
>> num_devices		1
>> compat_flags		0x0
>> compat_ro_flags		0x0
>> incompat_flags		0x169
>> ( MIXED_BACKREF |
>> COMPRESS_LZO |
>> BIG_METADATA |
>> EXTENDED_IREF |
>> SKINNY_METADATA )
>> csum_type		0
>> csum_size		4
>> cache_generation	770740
>> uuid_tree_generation	770740
>> dev_item.uuid		dd8c8d66-b6f5-48d8-9d5e-6f56b2ad4751
>> dev_item.fsid		7f5aecd6-40fe-45ce-90c3-e86bacc4bf6f [match]
>> dev_item.type		0
>> dev_item.total_bytes	23999996231680
>> dev_item.bytes_used	23274943676416
>> dev_item.io_align	4096
>> dev_item.io_width	4096
>> dev_item.sector_size	4096
>> dev_item.devid		1
>> dev_item.dev_group	0
>> dev_item.seek_speed	0
>> dev_item.bandwidth	0
>> dev_item.generation	0
>>
>>
>>
>>
>>
>>
>>
>>
>>
>> --
>>
>> Best Regards
>>
>>
>>
>>
>> YunFu Li
>> System Engineer
>> Chengdu Kanghong Pharmaceuticals Group Co., Ltd
>> No. 36, Shu XiRoad, Chengdu, Sichuan Province, China
>> Ext.:4004 |
>> Liyunfu@cnkh.com| www.cnkh.com
>>
>>
>>
>>
>> -------------------------------------------------------------
>> 本邮件及其附件内容系我司保密信息，仅向收件人提供。若您不是本邮件指定收件人，敬请立即删除本邮件并与发件人联系，同时请勿以任何方式复制、使用及传播。多谢合作！
>>
>> The information contained in this E-mail and its
>> attachment(s) are our confidential information and are intended solely for the addressees. If
>> you are not the designated recipient, please delete
>> it from your system immediately and  notify the sender,
>> meanwhile, do not copy or use or spread it in any way.
>> Thank you very much!
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>


