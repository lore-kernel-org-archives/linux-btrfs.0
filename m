Return-Path: <SRS0=H1hn=QQ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=0.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,TRACKER_ID
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2FECAC282C4
	for <linux-btrfs@archiver.kernel.org>; Sat,  9 Feb 2019 15:32:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CFFD221773
	for <linux-btrfs@archiver.kernel.org>; Sat,  9 Feb 2019 15:32:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HDKymA0G"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726896AbfBIPcP (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sat, 9 Feb 2019 10:32:15 -0500
Received: from mail-lj1-f178.google.com ([209.85.208.178]:35727 "EHLO
        mail-lj1-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726880AbfBIPcP (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Sat, 9 Feb 2019 10:32:15 -0500
Received: by mail-lj1-f178.google.com with SMTP id j13-v6so5453788ljc.2
        for <linux-btrfs@vger.kernel.org>; Sat, 09 Feb 2019 07:32:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:openpgp:autocrypt:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=inCX3cXUY7JjxGNYzCpiBn4XgQSD7zYAinw4pQ+L1eI=;
        b=HDKymA0G9pnxN/V3Mm5GXzBgod6xKLSSrLilRt0TDQY60gD3Vy9kaofkhOB3P0wbWl
         3/E9wO+dPX6YyQxR8WMnS/JHeUNmQ6jigxVRRHLGsAbjvUS50xqr67Q7E9rFY/kaxoHm
         j4xBSugK0q4WkwitpJJAs5kyJFcqpzggOX6BkNtZX76Pyruc0xNVmmZ5T8ecKxE3etqV
         ncWX1P5x3eNJ2T1qKdbHXdrjrq4faQMhBXni9u0i2FqYXKs8RulwaVUduxo7KbWJLHB6
         TIgfAFEhIaCTcTCu5FmIUc3SN5SKAvXckJAVLQkNNsfILPd2Hxu8kdXzUmv2YJX9zfJY
         0DKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:openpgp:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=inCX3cXUY7JjxGNYzCpiBn4XgQSD7zYAinw4pQ+L1eI=;
        b=q6GSHeEteumojqp4r+SvFX9THgVAjmCQZYl07tggyocuDV/DQRffSfN59p/34R3jHu
         OY2glDOrCygTRoGxMuxIDsq2FaOv2iW5GKCq284a02re51G6VfLmt3aoUbQQD02LCFAN
         dkG+O5mibc2Z1BN3GSUPTHI46k0/+yf4LoaOLyMiHq6c8vrgZpQJbODKw93Ggh9eUSF/
         H2QCjUyXyzuz3YQU6uAIQoKE6RHYPTp9JjXhOxGDcX+LvuBX/Ykemvu08SvSNdK6P1qK
         OaHiNlf09FZqkbbGkb/lhvDgwFG81UMUvfp1c1vCQbmJ+77SEh2R4zc2epVLo+yBdj0E
         0yVQ==
X-Gm-Message-State: AHQUAuZjXcAtUTMCdB06p9l1B1nqj1y1RIeCRAO9rsB8h29CyS91XAQF
        RklW/CmOI3JTKfrRjl3yozREymwt
X-Google-Smtp-Source: AHgI3IZMdOAWjlSch4gjD3N+JTXUCOJMd86dyWKHAVR2U2rWMt2UkPsFsjHNpYxh+GJ6rbMLsXJEgg==
X-Received: by 2002:a2e:99c6:: with SMTP id l6-v6mr1194246ljj.94.1549726330692;
        Sat, 09 Feb 2019 07:32:10 -0800 (PST)
Received: from [192.168.1.4] (109-252-90-29.nat.spd-mgts.ru. [109.252.90.29])
        by smtp.gmail.com with ESMTPSA id y23-v6sm1081991ljk.95.2019.02.09.07.32.09
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 09 Feb 2019 07:32:09 -0800 (PST)
Subject: Re: Cannot 'mount -o degraded /dev/replacement' after a replace
To:     =?UTF-8?Q?Jakob_Sch=c3=b6ttl?= <jschoett@gmail.com>,
        Qu Wenruo <quwenruo.btrfs@gmx.com>, linux-btrfs@vger.kernel.org
References: <2efee604-e44c-b00b-2ea8-d13ebc8c6355@gmail.com>
 <5441dc9d-a552-e77e-f74d-fe6ef702d400@gmx.com>
 <57d3a28d-bf6e-7f89-3a2d-ebcb90fc6e32@gmail.com>
From:   Andrei Borzenkov <arvidjaar@gmail.com>
Openpgp: preference=signencrypt
Autocrypt: addr=arvidjaar@gmail.com; prefer-encrypt=mutual; keydata=
 xsDiBDxiRwwRBAC3CN9wdwpVEqUGmSoqF8tWVIT4P/bLCSZLkinSZ2drsblKpdG7x+guxwts
 +LgI8qjf/q5Lah1TwOqzDvjHYJ1wbBauxZ03nDzSLUhD4Ms1IsqlIwyTLumQs4vcQdvLxjFs
 G70aDglgUSBogtaIEsiYZXl4X0j3L9fVstuz4/wXtwCg1cN/yv/eBC0tkcM1nsJXQrC5Ay8D
 /1aA5qPticLBpmEBxqkf0EMHuzyrFlqVw1tUjZ+Ep2LMlem8malPvfdZKEZ71W1a/XbRn8FE
 SOp0tUa5GwdoDXgEp1CJUn+WLurR0KPDf01E4j/PHHAoABgrqcOTcIVoNpv2gNiBySVsNGzF
 XTeY/Yd6vQclkqjBYONGN3r9R8bWA/0Y1j4XK61qjowRk3Iy8sBggM3PmmNRUJYgroerpcAr
 2byz6wTsb3U7OzUZ1Llgisk5Qum0RN77m3I37FXlIhCmSEY7KZVzGNW3blugLHcfw/HuCB7R
 1w5qiLWKK6eCQHL+BZwiU8hX3dtTq9d7WhRW5nsVPEaPqudQfMSi/Ux1kc0mQW5kcmVpIEJv
 cnplbmtvdiA8YXJ2aWRqYWFyQGdtYWlsLmNvbT7CZQQTEQIAJQIbAwYLCQgHAwIGFQgCCQoL
 BBYCAwECHgECF4AFAliWAiQCGQEACgkQR6LMutpd94wFGwCeNuQnMDxve/Fo3EvYIkAOn+zE
 21cAnRCQTXd1hTgcRHfpArEd/Rcb5+SczsBNBDxiRyQQBACQtME33UHfFOCApLki4kLFrIw1
 5A5asua10jm5It+hxzI9jDR9/bNEKDTKSciHnM7aRUggLwTt+6CXkMy8an+tVqGL/MvDc4/R
 KKlZxj39xP7wVXdt8y1ciY4ZqqZf3tmmSN9DlLcZJIOT82DaJZuvr7UJ7rLzBFbAUh4yRKaN
 nwADBwQAjNvMr/KBcGsV/UvxZSm/mdpvUPtcw9qmbxCrqFQoB6TmoZ7F6wp/rL3TkQ5UElPR
 gsG12+Dk9GgRhnnxTHCFgN1qTiZNX4YIFpNrd0au3W/Xko79L0c4/49ten5OrFI/psx53fhY
 vLYfkJnc62h8hiNeM6kqYa/x0BEddu92ZG7CRgQYEQIABgUCPGJHJAAKCRBHosy62l33jMhd
 AJ48P7WDvKLQQ5MKnn2D/TI337uA/gCgn5mnvm4SBctbhaSBgckRmgSxfwQ=
Message-ID: <0680cf0a-5a03-086f-d3f7-3317655401f0@gmail.com>
Date:   Sat, 9 Feb 2019 18:32:08 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <57d3a28d-bf6e-7f89-3a2d-ebcb90fc6e32@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

09.02.2019 16:45, Jakob Schöttl пишет:
> Thanks Qu,
> 
> Am 09.02.19 um 13:16 schrieb Qu Wenruo:
>> On 2019/2/9 下午6:36, Jakob Schöttl wrote:
>>> Hi,
>>>
>>> I've setup a RAID1 with two disks (disk1 and disk2) and I'm testing the
>>> btrfs replace command.
>>>
>>> After replacing disk2 with disk3, I can only mount
>>> (a) disk1 or disk3 (if both disk are plugged) and
>>> (b) the original disk1 (degraded, if disk3 is unplugged).
>>>
>>> I cannot mount the replacement disk3 if disk1 is unplugged.
>> Sounds like there is one single chunk on disk1, which caused the problem.
>>
>>>> mount: /mnt: wrong fs type, bad option, bad superblock on /dev/loop3,
>>> missing codepage or helper program, or other error.
>> dmesg please.
> [60456.856883] BTRFS: device label datavol devid 1 transid 5 /dev/loop1
> [60456.940785] BTRFS: device label datavol devid 2 transid 5 /dev/loop2
> [60525.211389] BTRFS info (device loop1): allowing degraded mounts
> [60525.211395] BTRFS info (device loop1): disk space caching is enabled
> [60525.211398] BTRFS info (device loop1): has skinny extents
> [60525.211401] BTRFS info (device loop1): flagging fs with big metadata
> feature
> [60525.213854] BTRFS warning (device loop1): devid 2 uuid
> 0b4e0b31-e2b1-40a0-8360-09978f58a2e4 is missing
> [60525.214639] BTRFS info (device loop1): checking UUID tree
> [60525.386695] BTRFS info (device loop1): dev_replace from <missing
> disk> (devid 2) to /dev/loop3 started
> [60525.394403] BTRFS info (device loop1): dev_replace from <missing
> disk> (devid 2) to /dev/loop3 finished
> [60533.721841] BTRFS info (device loop3): allowing degraded mounts
> [60533.721846] BTRFS info (device loop3): disk space caching is enabled
> [60533.721850] BTRFS info (device loop3): has skinny extents
> [60533.723703] BTRFS error (device loop3): failed to read chunk root
> [60533.773553] BTRFS error (device loop3): open_ctree failed
> 
>> And btrfs-progs version please.
> $ pacman -Q btrfs-progs
> btrfs-progs 4.20.1-2
> $ uname -a
> Linux jathink 4.20.7-arch1-1-ARCH #1 SMP PREEMPT Wed Feb 6 18:42:40 UTC
> 2019 x86_64 GNU/Linux
> 
>> Maybe mkfs is too old to leave SINGLE profile chunks on the original fs.
>>
>> And you could verify the chunk mapping by executing 'btrfs ins dump-tree
>> -t chunk <device>' and paste the output.
> 
> When only /dev/loop3 is plugged:
> 
> # btrfs inspect-internal dump-tree -t chunk /dev/loop3
> btrfs-progs v4.20.1
> warning, device 1 is missing
> warning, device 1 is missing
> warning, device 1 is missing
> warning, device 1 is missing
> bad tree block 198180864, bytenr mismatch, want=198180864, have=0
> ERROR: cannot read chunk root
> ERROR: unable to open /dev/loop3
> 
> When only /dev/loop1 is plugged:
> 
> # btrfs inspect-internal dump-tree -t chunk /dev/loop1
> btrfs-progs v4.20.1
> warning, device 2 is missing
> chunk tree
> leaf 198180864 items 10 free space 15005 generation 8 owner CHUNK_TREE
> leaf 198180864 flags 0x1(WRITTEN) backref revision 1
> fs uuid 005a8d59-a561-4371-869e-b0ccc4a4862b
> chunk uuid b3e609f1-a7fe-4add-bc51-6231f0bbf320
>     item 0 key (DEV_ITEMS DEV_ITEM 1) itemoff 16185 itemsize 98
>         devid 1 total_bytes 307200000 bytes_used 306053120
>         io_align 4096 io_width 4096 sector_size 4096 type 0
>         generation 0 start_offset 0 dev_group 0
>         seek_speed 0 bandwidth 0
>         uuid 043443c7-ac91-4085-a5e4-983b59dd0803
>         fsid 005a8d59-a561-4371-869e-b0ccc4a4862b
>     item 1 key (DEV_ITEMS DEV_ITEM 2) itemoff 16087 itemsize 98
>         devid 2 total_bytes 307200000 bytes_used 109051904
>         io_align 4096 io_width 4096 sector_size 4096 type 0
>         generation 0 start_offset 0 dev_group 0
>         seek_speed 0 bandwidth 0
>         uuid 0b4e0b31-e2b1-40a0-8360-09978f58a2e4
>         fsid 005a8d59-a561-4371-869e-b0ccc4a4862b
>     item 2 key (FIRST_CHUNK_TREE CHUNK_ITEM 22020096) itemoff 15975
> itemsize 112
>         length 8388608 owner 2 stripe_len 65536 type SYSTEM|RAID1
>         io_align 65536 io_width 65536 sector_size 4096
>         num_stripes 2 sub_stripes 0
>             stripe 0 devid 2 offset 1048576
>             dev_uuid 0b4e0b31-e2b1-40a0-8360-09978f58a2e4
>             stripe 1 devid 1 offset 22020096
>             dev_uuid 043443c7-ac91-4085-a5e4-983b59dd0803
>     item 3 key (FIRST_CHUNK_TREE CHUNK_ITEM 30408704) itemoff 15863
> itemsize 112
>         length 33554432 owner 2 stripe_len 65536 type METADATA|RAID1
>         io_align 65536 io_width 65536 sector_size 4096
>         num_stripes 2 sub_stripes 0
>             stripe 0 devid 2 offset 9437184
>             dev_uuid 0b4e0b31-e2b1-40a0-8360-09978f58a2e4
>             stripe 1 devid 1 offset 30408704
>             dev_uuid 043443c7-ac91-4085-a5e4-983b59dd0803
>     item 4 key (FIRST_CHUNK_TREE CHUNK_ITEM 63963136) itemoff 15751
> itemsize 112
>         length 67108864 owner 2 stripe_len 65536 type DATA|RAID1
>         io_align 65536 io_width 65536 sector_size 4096
>         num_stripes 2 sub_stripes 0
>             stripe 0 devid 2 offset 42991616
>             dev_uuid 0b4e0b31-e2b1-40a0-8360-09978f58a2e4
>             stripe 1 devid 1 offset 63963136
>             dev_uuid 043443c7-ac91-4085-a5e4-983b59dd0803
>     item 5 key (FIRST_CHUNK_TREE CHUNK_ITEM 131072000) itemoff 15671
> itemsize 80
>         length 33554432 owner 2 stripe_len 65536 type METADATA
>         io_align 65536 io_width 65536 sector_size 4096
>         num_stripes 1 sub_stripes 1
>             stripe 0 devid 1 offset 131072000
>             dev_uuid 043443c7-ac91-4085-a5e4-983b59dd0803
>     item 6 key (FIRST_CHUNK_TREE CHUNK_ITEM 164626432) itemoff 15591
> itemsize 80
>         length 33554432 owner 2 stripe_len 65536 type SYSTEM
>         io_align 65536 io_width 65536 sector_size 4096
>         num_stripes 1 sub_stripes 1
>             stripe 0 devid 1 offset 164626432
>             dev_uuid 043443c7-ac91-4085-a5e4-983b59dd0803
>     item 7 key (FIRST_CHUNK_TREE CHUNK_ITEM 198180864) itemoff 15479
> itemsize 112
>         length 33554432 owner 2 stripe_len 65536 type SYSTEM|DUP
>         io_align 65536 io_width 65536 sector_size 4096
>         num_stripes 2 sub_stripes 1
>             stripe 0 devid 1 offset 198180864
>             dev_uuid 043443c7-ac91-4085-a5e4-983b59dd0803
>             stripe 1 devid 1 offset 231735296
>             dev_uuid 043443c7-ac91-4085-a5e4-983b59dd0803
>     item 8 key (FIRST_CHUNK_TREE CHUNK_ITEM 231735296) itemoff 15367
> itemsize 112
>         length 20905984 owner 2 stripe_len 65536 type METADATA|DUP
>         io_align 65536 io_width 65536 sector_size 4096
>         num_stripes 2 sub_stripes 1
>             stripe 0 devid 1 offset 265289728
>             dev_uuid 043443c7-ac91-4085-a5e4-983b59dd0803
>             stripe 1 devid 1 offset 286195712
>             dev_uuid 043443c7-ac91-4085-a5e4-983b59dd0803
>     item 9 key (FIRST_CHUNK_TREE CHUNK_ITEM 252641280) itemoff 15255
> itemsize 112
>         length 10485760 owner 2 stripe_len 65536 type DATA|DUP
>         io_align 65536 io_width 65536 sector_size 4096
>         num_stripes 2 sub_stripes 1
>             stripe 0 devid 1 offset 1048576
>             dev_uuid 043443c7-ac91-4085-a5e4-983b59dd0803
>             stripe 1 devid 1 offset 11534336
>             dev_uuid 043443c7-ac91-4085-a5e4-983b59dd0803
> 
> 

Yes, I can trivially reproduce it using commands in original post.

Immediately after mkfs:

10:/home/bor # btrfs inspect-internal dump-tree -t chunk /dev/sdb1
btrfs-progs v4.15
warning, device 2 is missing
chunk tree
leaf 22036480 items 5 free space 15626 generation 5 owner 3
leaf 22036480 flags 0x1(WRITTEN) backref revision 1
fs uuid d33e6bff-5903-449d-b49c-f2d992676e30
chunk uuid ed55b2ad-66c4-4764-acd5-7fa3a9fe619e
	item 0 key (DEV_ITEMS DEV_ITEM 1) itemoff 16185 itemsize 98
		devid 1 total_bytes 5367640064 bytes_used 1081868288
		io_align 4096 io_width 4096 sector_size 4096 type 0
		generation 0 start_offset 0 dev_group 0
		seek_speed 0 bandwidth 0
		uuid 653ea52e-f95f-417b-af6f-feb82ca49cd6
		fsid d33e6bff-5903-449d-b49c-f2d992676e30
	item 1 key (DEV_ITEMS DEV_ITEM 2) itemoff 16087 itemsize 98
		devid 2 total_bytes 5367640064 bytes_used 1081868288
		io_align 4096 io_width 4096 sector_size 4096 type 0
		generation 0 start_offset 0 dev_group 0
		seek_speed 0 bandwidth 0
		uuid 1e91c346-eba9-4a41-aeb2-d7efef64a5ea
		fsid d33e6bff-5903-449d-b49c-f2d992676e30
	item 2 key (FIRST_CHUNK_TREE CHUNK_ITEM 22020096) itemoff 15975
itemsize 112
		length 8388608 owner 2 stripe_len 65536 type SYSTEM|RAID1
		io_align 65536 io_width 65536 sector_size 4096
		num_stripes 2 sub_stripes 0
			stripe 0 devid 2 offset 1048576
			dev_uuid 1e91c346-eba9-4a41-aeb2-d7efef64a5ea
			stripe 1 devid 1 offset 22020096
			dev_uuid 653ea52e-f95f-417b-af6f-feb82ca49cd6
	item 3 key (FIRST_CHUNK_TREE CHUNK_ITEM 30408704) itemoff 15863
itemsize 112
		length 536739840 owner 2 stripe_len 65536 type METADATA|RAID1
		io_align 65536 io_width 65536 sector_size 4096
		num_stripes 2 sub_stripes 0
			stripe 0 devid 2 offset 9437184
			dev_uuid 1e91c346-eba9-4a41-aeb2-d7efef64a5ea
			stripe 1 devid 1 offset 30408704
			dev_uuid 653ea52e-f95f-417b-af6f-feb82ca49cd6
	item 4 key (FIRST_CHUNK_TREE CHUNK_ITEM 567148544) itemoff 15751
itemsize 112
		length 536739840 owner 2 stripe_len 65536 type DATA|RAID1
		io_align 65536 io_width 65536 sector_size 4096
		num_stripes 2 sub_stripes 0
			stripe 0 devid 2 offset 546177024
			dev_uuid 1e91c346-eba9-4a41-aeb2-d7efef64a5ea
			stripe 1 devid 1 offset 567148544
			dev_uuid 653ea52e-f95f-417b-af6f-feb82ca49cd6


Immediately after degraded mount

btrfs-progs v4.15
warning, device 2 is missing
chunk tree
leaf 22020096 items 8 free space 15311 generation 6 owner 3
leaf 22020096 flags 0x1(WRITTEN) backref revision 1
fs uuid e69b93ef-d852-4afa-8c74-50fa07d33a01
chunk uuid 74317bdd-f011-44a8-9c62-0cce665f1b52
	item 0 key (DEV_ITEMS DEV_ITEM 1) itemoff 16185 itemsize 98
		devid 1 total_bytes 5368709120 bytes_used 2994733056
		io_align 4096 io_width 4096 sector_size 4096 type 0
		generation 0 start_offset 0 dev_group 0
		seek_speed 0 bandwidth 0
		uuid 85365dff-ceb8-46bb-a4c5-78ce422a32f8
		fsid e69b93ef-d852-4afa-8c74-50fa07d33a01
	item 1 key (DEV_ITEMS DEV_ITEM 2) itemoff 16087 itemsize 98
		devid 2 total_bytes 5368709120 bytes_used 2155872256
		io_align 4096 io_width 4096 sector_size 4096 type 0
		generation 0 start_offset 0 dev_group 0
		seek_speed 0 bandwidth 0
		uuid 1989d9cd-9f82-4d3a-a577-c7e583157ed3
		fsid e69b93ef-d852-4afa-8c74-50fa07d33a01
	item 2 key (FIRST_CHUNK_TREE CHUNK_ITEM 22020096) itemoff 15975
itemsize 112
		length 8388608 owner 2 stripe_len 65536 type SYSTEM|RAID1
		io_align 65536 io_width 65536 sector_size 4096
		num_stripes 2 sub_stripes 0
			stripe 0 devid 2 offset 1048576
			dev_uuid 1989d9cd-9f82-4d3a-a577-c7e583157ed3
			stripe 1 devid 1 offset 22020096
			dev_uuid 85365dff-ceb8-46bb-a4c5-78ce422a32f8
	item 3 key (FIRST_CHUNK_TREE CHUNK_ITEM 30408704) itemoff 15863
itemsize 112
		length 1073741824 owner 2 stripe_len 65536 type METADATA|RAID1
		io_align 65536 io_width 65536 sector_size 4096
		num_stripes 2 sub_stripes 0
			stripe 0 devid 2 offset 9437184
			dev_uuid 1989d9cd-9f82-4d3a-a577-c7e583157ed3
			stripe 1 devid 1 offset 30408704
			dev_uuid 85365dff-ceb8-46bb-a4c5-78ce422a32f8
	item 4 key (FIRST_CHUNK_TREE CHUNK_ITEM 1104150528) itemoff 15751
itemsize 112
		length 1073741824 owner 2 stripe_len 65536 type DATA|RAID1
		io_align 65536 io_width 65536 sector_size 4096
		num_stripes 2 sub_stripes 0
			stripe 0 devid 2 offset 1083179008
			dev_uuid 1989d9cd-9f82-4d3a-a577-c7e583157ed3
			stripe 1 devid 1 offset 1104150528
			dev_uuid 85365dff-ceb8-46bb-a4c5-78ce422a32f8
	item 5 key (FIRST_CHUNK_TREE CHUNK_ITEM 2177892352) itemoff 15671
itemsize 80
		length 268435456 owner 2 stripe_len 65536 type METADATA
		io_align 65536 io_width 65536 sector_size 4096
		num_stripes 1 sub_stripes 1
			stripe 0 devid 1 offset 2177892352
			dev_uuid 85365dff-ceb8-46bb-a4c5-78ce422a32f8
	item 6 key (FIRST_CHUNK_TREE CHUNK_ITEM 2446327808) itemoff 15591
itemsize 80
		length 33554432 owner 2 stripe_len 65536 type SYSTEM
		io_align 65536 io_width 65536 sector_size 4096
		num_stripes 1 sub_stripes 1
			stripe 0 devid 1 offset 2446327808
			dev_uuid 85365dff-ceb8-46bb-a4c5-78ce422a32f8
	item 7 key (FIRST_CHUNK_TREE CHUNK_ITEM 2479882240) itemoff 15511
itemsize 80
		length 536870912 owner 2 stripe_len 65536 type DATA
		io_align 65536 io_width 65536 sector_size 4096
		num_stripes 1 sub_stripes 1
			stripe 0 devid 1 offset 2479882240
			dev_uuid 85365dff-ceb8-46bb-a4c5-78ce422a32f8


After device replacement completed

10:/home/bor # btrfs replace status /mnt
Started on  9.Feb 18:07:18, finished on  9.Feb 18:07:19, 0 write errs, 0
uncorr. read errs
10:/home/bor # btrfs inspect-internal dump-tree -t chunk /dev/sdb1
btrfs-progs v4.15
chunk tree
leaf 1942749184 items 11 free space 14900 generation 9 owner 3
leaf 1942749184 flags 0x1(WRITTEN) backref revision 1
fs uuid d33e6bff-5903-449d-b49c-f2d992676e30
chunk uuid ed55b2ad-66c4-4764-acd5-7fa3a9fe619e
	item 0 key (DEV_ITEMS DEV_ITEM 1) itemoff 16185 itemsize 98
		devid 1 total_bytes 5367640064 bytes_used 2793144320
		io_align 4096 io_width 4096 sector_size 4096 type 0
		generation 0 start_offset 0 dev_group 0
		seek_speed 0 bandwidth 0
		uuid 653ea52e-f95f-417b-af6f-feb82ca49cd6
		fsid d33e6bff-5903-449d-b49c-f2d992676e30
	item 1 key (DEV_ITEMS DEV_ITEM 2) itemoff 16087 itemsize 98
		devid 2 total_bytes 5367640064 bytes_used 1081868288
		io_align 4096 io_width 4096 sector_size 4096 type 0
		generation 0 start_offset 0 dev_group 0
		seek_speed 0 bandwidth 0
		uuid 1e91c346-eba9-4a41-aeb2-d7efef64a5ea
		fsid d33e6bff-5903-449d-b49c-f2d992676e30
	item 2 key (FIRST_CHUNK_TREE CHUNK_ITEM 22020096) itemoff 15975
itemsize 112
		length 8388608 owner 2 stripe_len 65536 type SYSTEM|RAID1
		io_align 65536 io_width 65536 sector_size 4096
		num_stripes 2 sub_stripes 0
			stripe 0 devid 2 offset 1048576
			dev_uuid 1e91c346-eba9-4a41-aeb2-d7efef64a5ea
			stripe 1 devid 1 offset 22020096
			dev_uuid 653ea52e-f95f-417b-af6f-feb82ca49cd6
	item 3 key (FIRST_CHUNK_TREE CHUNK_ITEM 30408704) itemoff 15863
itemsize 112
		length 536739840 owner 2 stripe_len 65536 type METADATA|RAID1
		io_align 65536 io_width 65536 sector_size 4096
		num_stripes 2 sub_stripes 0
			stripe 0 devid 2 offset 9437184
			dev_uuid 1e91c346-eba9-4a41-aeb2-d7efef64a5ea
			stripe 1 devid 1 offset 30408704
			dev_uuid 653ea52e-f95f-417b-af6f-feb82ca49cd6
	item 4 key (FIRST_CHUNK_TREE CHUNK_ITEM 567148544) itemoff 15751
itemsize 112
		length 536739840 owner 2 stripe_len 65536 type DATA|RAID1
		io_align 65536 io_width 65536 sector_size 4096
		num_stripes 2 sub_stripes 0
			stripe 0 devid 2 offset 546177024
			dev_uuid 1e91c346-eba9-4a41-aeb2-d7efef64a5ea
			stripe 1 devid 1 offset 567148544
			dev_uuid 653ea52e-f95f-417b-af6f-feb82ca49cd6
	item 5 key (FIRST_CHUNK_TREE CHUNK_ITEM 1103888384) itemoff 15671
itemsize 80
		length 268435456 owner 2 stripe_len 65536 type METADATA
		io_align 65536 io_width 65536 sector_size 4096
		num_stripes 1 sub_stripes 1
			stripe 0 devid 1 offset 1103888384
			dev_uuid 653ea52e-f95f-417b-af6f-feb82ca49cd6
	item 6 key (FIRST_CHUNK_TREE CHUNK_ITEM 1372323840) itemoff 15591
itemsize 80
		length 33554432 owner 2 stripe_len 65536 type SYSTEM
		io_align 65536 io_width 65536 sector_size 4096
		num_stripes 1 sub_stripes 1
			stripe 0 devid 1 offset 1372323840
			dev_uuid 653ea52e-f95f-417b-af6f-feb82ca49cd6
	item 7 key (FIRST_CHUNK_TREE CHUNK_ITEM 1405878272) itemoff 15511
itemsize 80
		length 536870912 owner 2 stripe_len 65536 type DATA
		io_align 65536 io_width 65536 sector_size 4096
		num_stripes 1 sub_stripes 1
			stripe 0 devid 1 offset 1405878272
			dev_uuid 653ea52e-f95f-417b-af6f-feb82ca49cd6
	item 8 key (FIRST_CHUNK_TREE CHUNK_ITEM 1942749184) itemoff 15399
itemsize 112
		length 33554432 owner 2 stripe_len 65536 type SYSTEM|DUP
		io_align 65536 io_width 65536 sector_size 4096
		num_stripes 2 sub_stripes 1
			stripe 0 devid 1 offset 1942749184
			dev_uuid 653ea52e-f95f-417b-af6f-feb82ca49cd6
			stripe 1 devid 1 offset 1976303616
			dev_uuid 653ea52e-f95f-417b-af6f-feb82ca49cd6
	item 9 key (FIRST_CHUNK_TREE CHUNK_ITEM 1976303616) itemoff 15287
itemsize 112
		length 134217728 owner 2 stripe_len 65536 type METADATA|DUP
		io_align 65536 io_width 65536 sector_size 4096
		num_stripes 2 sub_stripes 1
			stripe 0 devid 1 offset 2009858048
			dev_uuid 653ea52e-f95f-417b-af6f-feb82ca49cd6
			stripe 1 devid 1 offset 2144075776
			dev_uuid 653ea52e-f95f-417b-af6f-feb82ca49cd6
	item 10 key (FIRST_CHUNK_TREE CHUNK_ITEM 2110521344) itemoff 15175
itemsize 112
		length 268435456 owner 2 stripe_len 65536 type DATA|DUP
		io_align 65536 io_width 65536 sector_size 4096
		num_stripes 2 sub_stripes 1
			stripe 0 devid 1 offset 2278293504
			dev_uuid 653ea52e-f95f-417b-af6f-feb82ca49cd6
			stripe 1 devid 1 offset 2546728960
			dev_uuid 653ea52e-f95f-417b-af6f-feb82ca49cd6
10:/home/bor #



Running

btrfs balance start -f -ssoft,convert=raid1 -dsoft,convert=raid1
-msoft,convert=raid1 /mnt

fixes it. I am not sure whether btrfs is expected to do it automatically
as of now.

