Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lb0-f169.google.com ([209.85.217.169]:36069 "EHLO
	mail-lb0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753429AbcBYBES (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 24 Feb 2016 20:04:18 -0500
Received: by mail-lb0-f169.google.com with SMTP id x1so20408662lbj.3
        for <linux-btrfs@vger.kernel.org>; Wed, 24 Feb 2016 17:04:17 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <ce805cd7-422c-ab6a-fbf8-18a304aa640d@mokrynskyi.com>
References: <a55e81de-412b-c269-775d-3f8e0d96d7a9@mokrynskyi.com>
	<72cb240a-fdb2-c38b-adb1-2b72847ab29a@mokrynskyi.com>
	<CAPmG0jZvioaxdr4FNHRQJTDZwuxq5EwUTay+VB=c+hKAzdDGYg@mail.gmail.com>
	<ce805cd7-422c-ab6a-fbf8-18a304aa640d@mokrynskyi.com>
Date: Thu, 25 Feb 2016 02:04:16 +0100
Message-ID: <CAPmG0jbRmWeHvL4cUzhPBAfA=_Ue03uC-pLE4O-u5bzFF_kzEQ@mail.gmail.com>
Subject: Re: Major HDD performance degradation on btrfs receive
From: Henk Slager <eye1tm@gmail.com>
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Feb 24, 2016 at 11:45 PM, Nazar Mokrynskyi <nazar@mokrynskyi.com> wrote:
> Here is btrfs-show-super output:
>
>> nazar-pc@nazar-pc ~> sudo btrfs-show-super /dev/sda1
>> superblock: bytenr=65536, device=/dev/sda1
>> ---------------------------------------------------------
>> csum            0x1e3c6fb8 [match]
>> bytenr            65536
>> flags            0x1
>>             ( WRITTEN )
>> magic            _BHRfS_M [match]
>> fsid            40b8240a-a0a2-4034-ae55-f8558c0343a8
>> label            Backup
>> generation        165491
>> root            143985360896
>> sys_array_size        226
>> chunk_root_generation    162837
>> root_level        1
>> chunk_root        247023583232
>> chunk_root_level    1
>> log_root        0
>> log_root_transid    0
>> log_root_level        0
>> total_bytes        858993459200
>> bytes_used        276512202752
>> sectorsize        4096
>> nodesize        16384
>> leafsize        16384
>> stripesize        4096
>> root_dir        6
>> num_devices        1
>> compat_flags        0x0
>> compat_ro_flags        0x0
>> incompat_flags        0x169
>>             ( MIXED_BACKREF |
>>               COMPRESS_LZO |
>>               BIG_METADATA |
>>               EXTENDED_IREF |
>>               SKINNY_METADATA )
>> csum_type        0
>> csum_size        4
>> cache_generation    165491
>> uuid_tree_generation    165491
>> dev_item.uuid        81eee7a6-774e-4bb5-8b72-cebb85a2f2ce
>> dev_item.fsid        40b8240a-a0a2-4034-ae55-f8558c0343a8 [match]
>> dev_item.type        0
>> dev_item.total_bytes    858993459200
>> dev_item.bytes_used    291072114688
>> dev_item.io_align    4096
>> dev_item.io_width    4096
>> dev_item.sector_size    4096
>> dev_item.devid        1
>> dev_item.dev_group    0
>> dev_item.seek_speed    0
>> dev_item.bandwidth    0
>> dev_item.generation    0
>
> It is sad that skinny metadata will only affect new data, probably, I'll end
> up re-creating it:(
>
> Can I rebalance it or something simple for this purpose?

A balance won't help for that and also your metadata does look quite
compact already. But I think you should not expect so much of this
skinny metadata on a PC with 16G RAM

>> Those are quite typical values for an already heavily used btrfs on a HDD.
>
>
> Bad news, since I'm doing mounting/unmounting few times during snapshots
> creation because of how BTRFS works (source code:
> https://github.com/nazar-pc/just-backup-btrfs/blob/master/just-backup-btrfs.php#L148)
>
> So if 10+20 seconds is typical, then in my case HDD can be very busy during
> a minute or sometimes more, this is not good and basically part or even real
> reason of initial question.

Yes indeed! This mount/unmount every 15 minutes (or more times per 15
minutes) is killing for performance IMO. At the moment I don't fully
understand why you are bothered by the limitation you mention in the
php source comments. I think it's definitely worth to change paths
and/or your requirements in such a way that you can avoid the
umount/mount.

As a workaround, bcache with its cache device nicely filled over time,
will absolutely speedup the mount. But as you had some troubles with
btrfs in the past and also you use ext4 on the same disk because it is
a more mature filesystem, you might not want bache+btrfs for backup
storage, it is up to you.
