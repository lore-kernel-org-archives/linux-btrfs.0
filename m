Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:55094 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752014AbeDGDUW (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 6 Apr 2018 23:20:22 -0400
Subject: Re: Bad magic on superblock on /dev/sda at 65536
To: Ben Parsons <9parsonsb@gmail.com>
Cc: Qu Wenruo <quwenruo.btrfs@gmx.com>, dsterba@suse.cz,
        linux-btrfs@vger.kernel.org
References: <CAAGPGf9+y_BXj=jQ1aY3xSPzMTjOTWPPO2avBODSYem5pyRXGQ@mail.gmail.com>
 <20180406170329.GH8557@twin.jikos.cz>
 <1401c2e5-d0e9-ac9e-178f-776cb9847ffb@gmx.com>
 <CAAGPGf8m-8qQ-tsW6ZxtEktm1DbP4FfrU6FZr+tX3vb_Cq+9_g@mail.gmail.com>
 <17a45d05-1dc9-4b1b-5786-c4bf8ae8a5eb@gmx.com>
From: Anand Jain <anand.jain@oracle.com>
Message-ID: <f28eaa7e-81eb-8fe9-9918-d461403bf28e@oracle.com>
Date: Sat, 7 Apr 2018 11:22:15 +0800
MIME-Version: 1.0
In-Reply-To: <17a45d05-1dc9-4b1b-5786-c4bf8ae8a5eb@gmx.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


  First superblock is zero-ed and its not some random corruption,
  most probably someone else other than btrfs used the disk when
  it was unmounted? Or if the partition (if any) was changed? or
  if its a SAN storge hope the LUN wasn't recreated at the storage end.

Thanks, Anand

On 04/07/2018 08:56 AM, Qu Wenruo wrote:
> 
> 
> On 2018年04月07日 08:35, Ben Parsons wrote:
>>> btrfs inspect-internal dump-super -Ffa /path
>>
>> superblock: bytenr=65536, device=/dev/sda
>> ---------------------------------------------------------
>> csum_type        0 (crc32c)
>> csum_size        4
>> csum            0x00000000 [DON'T MATCH]
>> bytenr            0
>> flags            0x0
>> magic            ........ [DON'T MATCH]
>> fsid            00000000-0000-0000-0000-000000000000
> 
> First super block is completely gone.
> 
>> label
>> generation        0
>> root            0
>> sys_array_size        0
>> chunk_root_generation    0
>> root_level        0
>> chunk_root        0
>> chunk_root_level    0
>> log_root        0
>> log_root_transid    0
>> log_root_level        0
>> total_bytes        0
>> bytes_used        0
>> sectorsize        0
>> nodesize        0
>> leafsize (deprecated)        0
>> stripesize        0
>> root_dir        0
>> num_devices        0
>> compat_flags        0x0
>> compat_ro_flags        0x0
>> incompat_flags        0x0
>> cache_generation    0
>> uuid_tree_generation    0
>> dev_item.uuid        00000000-0000-0000-0000-000000000000
>> dev_item.fsid        00000000-0000-0000-0000-000000000000 [match]
>> dev_item.type        0
>> dev_item.total_bytes    0
>> dev_item.bytes_used    0
>> dev_item.io_align    0
>> dev_item.io_width    0
>> dev_item.sector_size    0
>> dev_item.devid        0
>> dev_item.dev_group    0
>> dev_item.seek_speed    0
>> dev_item.bandwidth    0
>> dev_item.generation    0
>> sys_chunk_array[2048]:
>> backup_roots[4]:


