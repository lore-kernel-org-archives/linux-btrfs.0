Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.alfazone.pl ([91.222.140.5]:34162 "EHLO mail.alfazone.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750946AbcCRSJW (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 18 Mar 2016 14:09:22 -0400
Subject: Re: recovery problem raid5
To: Hugo Mills <hugo@carfax.org.uk>, linux-btrfs@vger.kernel.org
References: <56EC3DCC.6060101@alfazone.pl>
 <20160318180207.GA1802@carfax.org.uk>
From: Marcin Solecki <solo@alfazone.pl>
Message-ID: <56EC4426.6020906@alfazone.pl>
Date: Fri, 18 Mar 2016 19:08:38 +0100
MIME-Version: 1.0
In-Reply-To: <20160318180207.GA1802@carfax.org.uk>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I try mount with -o degraded but this same effect what recovery:

[ 7133.926778] BTRFS info (device sdc): allowing degraded mounts
[ 7133.926783] BTRFS info (device sdc): disk space caching is enabled
[ 7133.932140] BTRFS info (device sdc): bdev (null) errs: wr 921, rd 
164889, flush 0, corrupt 0, gen 0
[ 7133.993146] BTRFS error (device sdc): bad tree block start 0 1619525632
[ 7133.993185] BTRFS: Failed to read block groups: -5
[ 7134.002111] BTRFS: open_ctree failed

Do you  suggest to return for stable kernel on centos? ( 3.10 )


W dniu 2016-03-18 o 19:02, Hugo Mills pisze:
>     The main thing you haven't tried here is mount -o degraded, which
> is the thing to do if you have a missing device in your array.
>
>     Also, that kernel's not really all that good for a parity RAID
> array -- it's the very first one that had the scrub and replace
> implementation, so it's rather less stable with parity RAID than the
> later 4.x kernels. That's probably not the issue here, though.
>
>     Hugo.
>
> On Fri, Mar 18, 2016 at 06:41:32PM +0100, Marcin Solecki wrote:
>> Hello all,
>> I give up for this problem at restore my data
>>
>>
>> # uname -a
>> Linux jarvis.home 4.5.0-1.el7.elrepo.x86_64
>>
>> # btrfs --version
>> btrfs-progs v3.19.1
>>
>> # btrfs fi show
>> warning, device 4 is missing
>> bytenr mismatch, want=21020672, have=21217280
>> Couldn't read chunk root
>> Label: none  uuid: 27ef2638-b50a-4243-80ed-40c3733ec11d
>>          Total devices 4 FS bytes used 2.50TiB
>>          devid    1 size 931.51GiB used 899.71GiB path /dev/sdd
>>          devid    2 size 931.51GiB used 899.69GiB path /dev/sdb
>>          devid    3 size 931.51GiB used 899.69GiB path /dev/sdc
>>          *** Some devices missing
>>
>> # mount  -o recovery /dev/sda /srv/
>> mount: wrong fs type, bad option, bad superblock on /dev/sda,
>>         missing codepage or helper program, or other error
>>
>>         In some cases useful info is found in syslog - try
>>         dmesg | tail or so.
>>
>> dmesg after :
>> [ 4886.521315] BTRFS info (device sdc): enabling auto recovery
>> [ 4886.521320] BTRFS info (device sdc): disk space caching is enabled
>> [ 4886.522853] BTRFS: failed to read chunk tree on sdc
>> [ 4886.528789] BTRFS: open_ctree failed
>>
>> #btrfs check --repair /dev/sda
>> enabling repair mode
>> warning, device 4 is missing
>> bytenr mismatch, want=21020672, have=21217280
>> Couldn't read chunk root
>> Couldn't open file system
>>
>> # btrfs rescue chunk-recover -v /dev/sda
>> All Devices:
>>          Device: id = 3, name = /dev/sdc
>>          Device: id = 2, name = /dev/sdb
>>          Device: id = 1, name = /dev/sda
>>
>> [ 5164.468272] btrfs[3653]: segfault at 7f454014172e ip
>> 0000000000423479 sp 00007f4482cec880 error 4 in btrfs[400000+83000]
>> [ 5168.928317] btrfs[3657]: segfault at 7fd18c14172e ip
>> 0000000000423479 sp 00007fd0d5858880 error 4 in btrfs[400000+83000]
>> [ 5173.812457] btrfs[3662]: segfault at 7fd76c14172e ip
>> 0000000000423479 sp 00007fd6b0e59880 error 4 in btrfs[400000+83000]
>>
>> # btrfs rescue super-recover -v /dev/sda
>> All Devices:
>>          Device: id = 3, name = /dev/sdc
>>          Device: id = 2, name = /dev/sdb
>>          Device: id = 1, name = /dev/sda
>>
>> Before Recovering:
>>          [All good supers]:
>>                  device name = /dev/sdc
>>                  superblock bytenr = 65536
>>
>>                  device name = /dev/sdc
>>                  superblock bytenr = 67108864
>>
>>                  device name = /dev/sdc
>>                  superblock bytenr = 274877906944
>>
>>                  device name = /dev/sdb
>>                  superblock bytenr = 65536
>>
>>                  device name = /dev/sdb
>>                  superblock bytenr = 67108864
>>
>>                  device name = /dev/sdb
>>                  superblock bytenr = 274877906944
>>
>>                  device name = /dev/sda
>>                  superblock bytenr = 65536
>>
>>                  device name = /dev/sda
>>                  superblock bytenr = 67108864
>>
>>                  device name = /dev/sda
>>                  superblock bytenr = 274877906944
>>
>>          [All bad supers]:
>>
>> All supers are valid, no need to recover
>>
>> # btrfs-show-super /dev/sda
>> superblock: bytenr=65536, device=/dev/sda
>> ---------------------------------------------------------
>> csum                    0x61b509bb [match]
>> bytenr                  65536
>> flags                   0x1
>> magic                   _BHRfS_M [match]
>> fsid                    27ef2638-b50a-4243-80ed-40c3733ec11d
>> label
>> generation              69462
>> root                    1648640000
>> sys_array_size          290
>> chunk_root_generation   48545
>> root_level              1
>> chunk_root              21020672
>> chunk_root_level        1
>> log_root                0
>> log_root_transid        0
>> log_root_level          0
>> total_bytes             4000819544064
>> bytes_used              2743528714240
>> sectorsize              4096
>> nodesize                16384
>> leafsize                16384
>> stripesize              4096
>> root_dir                6
>> num_devices             4
>> compat_flags            0x0
>> compat_ro_flags         0x0
>> incompat_flags          0xe1
>>                          ( MIXED_BACKREF |
>>                            BIG_METADATA |
>>                            EXTENDED_IREF |
>>                            RAID56 )
>> csum_type               0
>> csum_size               4
>> cache_generation        69462
>> uuid_tree_generation    69462
>> dev_item.uuid           70f4650c-e01d-4613-bd7a-a6834c1c44bb
>> dev_item.fsid           27ef2638-b50a-4243-80ed-40c3733ec11d [match]
>> dev_item.type           0
>> dev_item.total_bytes    1000204886016
>> dev_item.bytes_used     966057263104
>> dev_item.io_align       4096
>> dev_item.io_width       4096
>> dev_item.sector_size    4096
>> dev_item.devid          1
>> dev_item.dev_group      0
>> dev_item.seek_speed     0
>> dev_item.bandwidth      0
>> dev_item.generation     0
>>
>> thx for helps
>>

-- 
Pozdrawiam Marcin Solecki

