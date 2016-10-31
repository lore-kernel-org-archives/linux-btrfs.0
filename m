Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:54063 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1758686AbcJaF2J (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 31 Oct 2016 01:28:09 -0400
Subject: Re: btrfs check --repair: ERROR: cannot read chunk root
To: Marc MERLIN <marc@merlins.org>
References: <20161030183437.GA3287@merlins.org>
 <062d36da-197f-6a58-0b6e-208a5ca9fef3@cn.fujitsu.com>
 <20161031020616.GH28648@merlins.org>
CC: <linux-btrfs@vger.kernel.org>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <60a0ce1f-7b2f-325e-51f7-ccad054fab8b@cn.fujitsu.com>
Date: Mon, 31 Oct 2016 13:27:56 +0800
MIME-Version: 1.0
In-Reply-To: <20161031020616.GH28648@merlins.org>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



At 10/31/2016 10:06 AM, Marc MERLIN wrote:
> On Mon, Oct 31, 2016 at 09:02:50AM +0800, Qu Wenruo wrote:
>> Your chunk root is corrupted, and since chunk tree provides the
>> underlying disk layout, even for single device, so if we failed to read
>> it, then it will never be able to be mounted.
>
> That's the thing though, I can mount the filesystem just fine :)

That's strange, pretty strange.

And according to your super dump, I didn't see anything btrfs-progs 
can't handle.

Your chunk tree lies in a DUP chunk, which btrfs-progs should be able to 
handle it. (Unlike RAID5/6, btrfs-progs doesn't support to recover it at 
read time)



>
>> You could try to use backup chunk root.
>>
>> "btrfs inspect-internal dump-super -f" to find the backup chunk root,
>> and use "btrfs check --chunk-root <backup chunk root bytenr>" to have
>> another try.
>
> Am I doing this right? It doesn't seem to work
>
> myth:~# btrfs check -p --repair --chunk-root 13835462344704 /dev/mapper/crypt_bcache0  2>&1 | tee /var/spool/repair2
> bytenr mismatch, want=13835462344704, have=0
> ERROR: cannot read chunk root
> Couldn't open file system
> enabling repair mode

You're doing it right, while the superblock doesn't contain any old 
chunk root bytenr.

So this method doesn't work at all. :(


Would you please dump the following bytes?
That's the chunk root tree block on your disk.

offset: 13500329066496 length: 16384
offset: 13500330213376 length: 16384

According to your fsck error output, I assume btrfs-progs fails to read 
the first copy of chunk root, and due to a bug, it doesn't continue to 
read 2nd copy.

While kernel continues to read the 2nd copy and everything goes on.

IIRC btrfs-progs can handle csum error and continue trying, maybe some 
logical goes wrong.

Thanks,
Qu
>
>
> myth:~# btrfs inspect-internal dump-super -f /dev/mapper/crypt_bcache0 | less
> superblock: bytenr=65536, device=/dev/mapper/crypt_bcache0
> ---------------------------------------------------------
> csum_type               0 (crc32c)
> csum_size               4
> csum                    0x3814e4a0 [match]
> bytenr                  65536
> flags                   0x1
>                         ( WRITTEN )
> magic                   _BHRfS_M [match]
> fsid                    6692cf4c-93d9-438c-ac30-5db6381dc4f2
> label                   DS5
> generation              51176
> root                    13845513109504
> sys_array_size          129
> chunk_root_generation   51135
> root_level              1
> chunk_root              13835462344704
> chunk_root_level        1
> log_root                0
> log_root_transid        0
> log_root_level          0
> total_bytes             16002599346176
> bytes_used              14584560160768
> sectorsize              4096
> nodesize                16384
> leafsize                16384
> stripesize              4096
> root_dir                6
> num_devices             1
> compat_flags            0x0
> compat_ro_flags         0x0
> incompat_flags          0x169
>                         ( MIXED_BACKREF |
>                           COMPRESS_LZO |
>                           BIG_METADATA |
>                           EXTENDED_IREF |
>                           SKINNY_METADATA )
> cache_generation        51176
> uuid_tree_generation    51176
> dev_item.uuid           0cf779be-8e16-4982-b7d7-f8241deea0d1
> dev_item.fsid           6692cf4c-93d9-438c-ac30-5db6381dc4f2 [match]
> dev_item.type           0
> dev_item.total_bytes    16002599346176
> dev_item.bytes_used     14691011133440
> dev_item.io_align       4096
> dev_item.io_width       4096
> dev_item.sector_size    4096
> dev_item.devid          1
> dev_item.dev_group      0
> dev_item.seek_speed     0
> dev_item.bandwidth      0
> dev_item.generation     0
> sys_chunk_array[2048]:
>         item 0 key (FIRST_CHUNK_TREE CHUNK_ITEM 13835461197824)
>                 chunk length 33554432 owner 2 stripe_len 65536
>                 type SYSTEM|DUP num_stripes 2
>                         stripe 0 devid 1 offset 13500327919616
>                         dev uuid: 0cf779be-8e16-4982-b7d7-f8241deea0d1
>                         stripe 1 devid 1 offset 13500361474048
>                         dev uuid: 0cf779be-8e16-4982-b7d7-f8241deea0d1
> backup_roots[4]:
>         backup 0:
>                 backup_tree_root:       12801101791232  gen: 51174      level: 1
>                 backup_chunk_root:      13835462344704  gen: 51135      level: 1
>                 backup_extent_root:     12801124352000  gen: 51174      level: 3
>                 backup_fs_root:         10548133724160  gen: 51172      level: 0
>                 backup_dev_root:        11125467824128  gen: 51172      level: 1
>                 backup_csum_root:       12801133953024  gen: 51174      level: 3
>                 backup_total_bytes:     16002599346176
>                 backup_bytes_used:      14584560160768
>                 backup_num_devices:     1
>
>         backup 1:
>                 backup_tree_root:       13842532810752  gen: 51175      level: 1
>                 backup_chunk_root:      13835462344704  gen: 51135      level: 1
>                 backup_extent_root:     13843784695808  gen: 51175      level: 3
>                 backup_fs_root:         10548133724160  gen: 51172      level: 0
>                 backup_dev_root:        11125467824128  gen: 51172      level: 1
>                 backup_csum_root:       13842542362624  gen: 51175      level: 3
>                 backup_total_bytes:     16002599346176
>                 backup_bytes_used:      14584560160768
>                 backup_num_devices:     1
>
>         backup 2:
>                 backup_tree_root:       13845513109504  gen: 51176      level: 1
>                 backup_chunk_root:      13835462344704  gen: 51135      level: 1
>                 backup_extent_root:     13845513191424  gen: 51176      level: 3
>                 backup_fs_root:         10548133724160  gen: 51172      level: 0
>                 backup_dev_root:        11125467824128  gen: 51172      level: 1
>                 backup_csum_root:       13852180938752  gen: 51176      level: 3
>                 backup_total_bytes:     16002599346176
>                 backup_bytes_used:      14584560160768
>                 backup_num_devices:     1
>
>         backup 3:
>                 backup_tree_root:       12750807580672  gen: 51173      level: 1
>                 backup_chunk_root:      13835462344704  gen: 51135      level: 1
>                 backup_extent_root:     12750810447872  gen: 51173      level: 3
>                 backup_fs_root:         10548133724160  gen: 51172      level: 0
>                 backup_dev_root:        11125467824128  gen: 51172      level: 1
>                 backup_csum_root:       12684302712832  gen: 51173      level: 3
>                 backup_total_bytes:     16002599346176
>                 backup_bytes_used:      14584560177152
>                 backup_num_devices:     1
>
>
>


