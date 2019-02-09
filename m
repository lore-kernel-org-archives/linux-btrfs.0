Return-Path: <SRS0=H1hn=QQ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 084CEC282C4
	for <linux-btrfs@archiver.kernel.org>; Sat,  9 Feb 2019 13:45:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AA162218D2
	for <linux-btrfs@archiver.kernel.org>; Sat,  9 Feb 2019 13:45:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Ikp9wFtk"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726836AbfBINpF (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sat, 9 Feb 2019 08:45:05 -0500
Received: from mail-wm1-f47.google.com ([209.85.128.47]:33343 "EHLO
        mail-wm1-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726724AbfBINpF (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Sat, 9 Feb 2019 08:45:05 -0500
Received: by mail-wm1-f47.google.com with SMTP id h22so9468039wmb.0
        for <linux-btrfs@vger.kernel.org>; Sat, 09 Feb 2019 05:45:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:subject:to:references:openpgp:autocrypt:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=i3FBX2eGTkIguhFsKt8/fskkVujXB7rR3ZqBRNSLfT8=;
        b=Ikp9wFtkuQf+MeVamkuNBXMrff6JS0dHQINQHIevW2s5SFYWi76tgIfJV529fKIhiS
         XsbZxDKGaaRl8+7buwKM5pmKB3t7t25kcl5+x17GuqRoqhq/L/EeRQZNTG2IkQjmHpi0
         /OtjqdAHFgugi1nZU4ilaPHcCoRO/dc6BlC5WK6JJr3iS9qCDINsbfaHfWNLluDZ+X8H
         8RkKXooaRAfxmpmqscT+kksX+EXNAxCftJIMvB7rLqlXJlMXcDPbWKntetvp7+dKuTDn
         2sxdTMN0D9JOiM9bRI5Rs0CVzPAixIrU5gEEOGRrMHOTdn4wngTuMvgCfHILgM2m359F
         Jmpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:subject:to:references:openpgp:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-transfer-encoding:content-language;
        bh=i3FBX2eGTkIguhFsKt8/fskkVujXB7rR3ZqBRNSLfT8=;
        b=cLMqgSzXQq3RIN0lvTgeTaOo60iOFNSylAgTKdCojJOeYn3CVr2is6+74l4MBkcTP3
         cx2SZLLX7a0Db2uyD363kDs+OBPrFkSz10V1CnGlF5UbjHS+yVuzJldmK4H3Z1IPLZvf
         60CWwOF3o+hmg0PoWdvSnxOlTB21bx9jIzLGkfQjfPJ8QISYbr/Hjd2EAU9jdF/yGyr3
         0RrXVAxp+dMuwdWOwqijyZz5Kw4YtcD37bKwhXE3vRphtJt1xa9V7UP6EGniKOuX7kz0
         rWNkVQJn23FHhW+ACEQ+JVvLLZVxXWVAob9ZST8uICJDVIQfIt7PppgfPCfyNflTZCe+
         LrvA==
X-Gm-Message-State: AHQUAuY0IU7A8FArkpy8jbWyw5qob82qHccJqI/1LEqGK+A2ov1+GDGL
        m06lld//+3GaWB6K47a8Uf3pN5A=
X-Google-Smtp-Source: AHgI3IYzZXoCYRpDvhUYNt05W9C7RifnD/HKsN4nsdY4ptZ4s3nql6YbA066FvRBrprezPp8x3UfcA==
X-Received: by 2002:adf:8251:: with SMTP id 75mr10128628wrb.112.1549719901576;
        Sat, 09 Feb 2019 05:45:01 -0800 (PST)
Received: from [192.168.178.53] (ip2505f80d.dynamic.kabel-deutschland.de. [37.5.248.13])
        by smtp.googlemail.com with ESMTPSA id t12sm6266032wmi.11.2019.02.09.05.45.00
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Sat, 09 Feb 2019 05:45:01 -0800 (PST)
From:   =?UTF-8?Q?Jakob_Sch=c3=b6ttl?= <jschoett@gmail.com>
Subject: Re: Cannot 'mount -o degraded /dev/replacement' after a replace
To:     Qu Wenruo <quwenruo.btrfs@gmx.com>, linux-btrfs@vger.kernel.org
References: <2efee604-e44c-b00b-2ea8-d13ebc8c6355@gmail.com>
 <5441dc9d-a552-e77e-f74d-fe6ef702d400@gmx.com>
Openpgp: preference=signencrypt
Autocrypt: addr=jschoett@gmail.com; prefer-encrypt=mutual; keydata=
 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
Message-ID: <57d3a28d-bf6e-7f89-3a2d-ebcb90fc6e32@gmail.com>
Date:   Sat, 9 Feb 2019 14:45:00 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.0
MIME-Version: 1.0
In-Reply-To: <5441dc9d-a552-e77e-f74d-fe6ef702d400@gmx.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: de-DE
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Thanks Qu,

Am 09.02.19 um 13:16 schrieb Qu Wenruo:
> On 2019/2/9 下午6:36, Jakob Schöttl wrote:
>> Hi,
>>
>> I've setup a RAID1 with two disks (disk1 and disk2) and I'm testing the
>> btrfs replace command.
>>
>> After replacing disk2 with disk3, I can only mount
>> (a) disk1 or disk3 (if both disk are plugged) and
>> (b) the original disk1 (degraded, if disk3 is unplugged).
>>
>> I cannot mount the replacement disk3 if disk1 is unplugged.
> Sounds like there is one single chunk on disk1, which caused the problem.
>
>>> mount: /mnt: wrong fs type, bad option, bad superblock on /dev/loop3,
>> missing codepage or helper program, or other error.
> dmesg please.
[60456.856883] BTRFS: device label datavol devid 1 transid 5 /dev/loop1
[60456.940785] BTRFS: device label datavol devid 2 transid 5 /dev/loop2
[60525.211389] BTRFS info (device loop1): allowing degraded mounts
[60525.211395] BTRFS info (device loop1): disk space caching is enabled
[60525.211398] BTRFS info (device loop1): has skinny extents
[60525.211401] BTRFS info (device loop1): flagging fs with big metadata 
feature
[60525.213854] BTRFS warning (device loop1): devid 2 uuid 
0b4e0b31-e2b1-40a0-8360-09978f58a2e4 is missing
[60525.214639] BTRFS info (device loop1): checking UUID tree
[60525.386695] BTRFS info (device loop1): dev_replace from <missing 
disk> (devid 2) to /dev/loop3 started
[60525.394403] BTRFS info (device loop1): dev_replace from <missing 
disk> (devid 2) to /dev/loop3 finished
[60533.721841] BTRFS info (device loop3): allowing degraded mounts
[60533.721846] BTRFS info (device loop3): disk space caching is enabled
[60533.721850] BTRFS info (device loop3): has skinny extents
[60533.723703] BTRFS error (device loop3): failed to read chunk root
[60533.773553] BTRFS error (device loop3): open_ctree failed

> And btrfs-progs version please.
$ pacman -Q btrfs-progs
btrfs-progs 4.20.1-2
$ uname -a
Linux jathink 4.20.7-arch1-1-ARCH #1 SMP PREEMPT Wed Feb 6 18:42:40 UTC 
2019 x86_64 GNU/Linux

> Maybe mkfs is too old to leave SINGLE profile chunks on the original fs.
>
> And you could verify the chunk mapping by executing 'btrfs ins dump-tree
> -t chunk <device>' and paste the output.

When only /dev/loop3 is plugged:

# btrfs inspect-internal dump-tree -t chunk /dev/loop3
btrfs-progs v4.20.1
warning, device 1 is missing
warning, device 1 is missing
warning, device 1 is missing
warning, device 1 is missing
bad tree block 198180864, bytenr mismatch, want=198180864, have=0
ERROR: cannot read chunk root
ERROR: unable to open /dev/loop3

When only /dev/loop1 is plugged:

# btrfs inspect-internal dump-tree -t chunk /dev/loop1
btrfs-progs v4.20.1
warning, device 2 is missing
chunk tree
leaf 198180864 items 10 free space 15005 generation 8 owner CHUNK_TREE
leaf 198180864 flags 0x1(WRITTEN) backref revision 1
fs uuid 005a8d59-a561-4371-869e-b0ccc4a4862b
chunk uuid b3e609f1-a7fe-4add-bc51-6231f0bbf320
     item 0 key (DEV_ITEMS DEV_ITEM 1) itemoff 16185 itemsize 98
         devid 1 total_bytes 307200000 bytes_used 306053120
         io_align 4096 io_width 4096 sector_size 4096 type 0
         generation 0 start_offset 0 dev_group 0
         seek_speed 0 bandwidth 0
         uuid 043443c7-ac91-4085-a5e4-983b59dd0803
         fsid 005a8d59-a561-4371-869e-b0ccc4a4862b
     item 1 key (DEV_ITEMS DEV_ITEM 2) itemoff 16087 itemsize 98
         devid 2 total_bytes 307200000 bytes_used 109051904
         io_align 4096 io_width 4096 sector_size 4096 type 0
         generation 0 start_offset 0 dev_group 0
         seek_speed 0 bandwidth 0
         uuid 0b4e0b31-e2b1-40a0-8360-09978f58a2e4
         fsid 005a8d59-a561-4371-869e-b0ccc4a4862b
     item 2 key (FIRST_CHUNK_TREE CHUNK_ITEM 22020096) itemoff 15975 
itemsize 112
         length 8388608 owner 2 stripe_len 65536 type SYSTEM|RAID1
         io_align 65536 io_width 65536 sector_size 4096
         num_stripes 2 sub_stripes 0
             stripe 0 devid 2 offset 1048576
             dev_uuid 0b4e0b31-e2b1-40a0-8360-09978f58a2e4
             stripe 1 devid 1 offset 22020096
             dev_uuid 043443c7-ac91-4085-a5e4-983b59dd0803
     item 3 key (FIRST_CHUNK_TREE CHUNK_ITEM 30408704) itemoff 15863 
itemsize 112
         length 33554432 owner 2 stripe_len 65536 type METADATA|RAID1
         io_align 65536 io_width 65536 sector_size 4096
         num_stripes 2 sub_stripes 0
             stripe 0 devid 2 offset 9437184
             dev_uuid 0b4e0b31-e2b1-40a0-8360-09978f58a2e4
             stripe 1 devid 1 offset 30408704
             dev_uuid 043443c7-ac91-4085-a5e4-983b59dd0803
     item 4 key (FIRST_CHUNK_TREE CHUNK_ITEM 63963136) itemoff 15751 
itemsize 112
         length 67108864 owner 2 stripe_len 65536 type DATA|RAID1
         io_align 65536 io_width 65536 sector_size 4096
         num_stripes 2 sub_stripes 0
             stripe 0 devid 2 offset 42991616
             dev_uuid 0b4e0b31-e2b1-40a0-8360-09978f58a2e4
             stripe 1 devid 1 offset 63963136
             dev_uuid 043443c7-ac91-4085-a5e4-983b59dd0803
     item 5 key (FIRST_CHUNK_TREE CHUNK_ITEM 131072000) itemoff 15671 
itemsize 80
         length 33554432 owner 2 stripe_len 65536 type METADATA
         io_align 65536 io_width 65536 sector_size 4096
         num_stripes 1 sub_stripes 1
             stripe 0 devid 1 offset 131072000
             dev_uuid 043443c7-ac91-4085-a5e4-983b59dd0803
     item 6 key (FIRST_CHUNK_TREE CHUNK_ITEM 164626432) itemoff 15591 
itemsize 80
         length 33554432 owner 2 stripe_len 65536 type SYSTEM
         io_align 65536 io_width 65536 sector_size 4096
         num_stripes 1 sub_stripes 1
             stripe 0 devid 1 offset 164626432
             dev_uuid 043443c7-ac91-4085-a5e4-983b59dd0803
     item 7 key (FIRST_CHUNK_TREE CHUNK_ITEM 198180864) itemoff 15479 
itemsize 112
         length 33554432 owner 2 stripe_len 65536 type SYSTEM|DUP
         io_align 65536 io_width 65536 sector_size 4096
         num_stripes 2 sub_stripes 1
             stripe 0 devid 1 offset 198180864
             dev_uuid 043443c7-ac91-4085-a5e4-983b59dd0803
             stripe 1 devid 1 offset 231735296
             dev_uuid 043443c7-ac91-4085-a5e4-983b59dd0803
     item 8 key (FIRST_CHUNK_TREE CHUNK_ITEM 231735296) itemoff 15367 
itemsize 112
         length 20905984 owner 2 stripe_len 65536 type METADATA|DUP
         io_align 65536 io_width 65536 sector_size 4096
         num_stripes 2 sub_stripes 1
             stripe 0 devid 1 offset 265289728
             dev_uuid 043443c7-ac91-4085-a5e4-983b59dd0803
             stripe 1 devid 1 offset 286195712
             dev_uuid 043443c7-ac91-4085-a5e4-983b59dd0803
     item 9 key (FIRST_CHUNK_TREE CHUNK_ITEM 252641280) itemoff 15255 
itemsize 112
         length 10485760 owner 2 stripe_len 65536 type DATA|DUP
         io_align 65536 io_width 65536 sector_size 4096
         num_stripes 2 sub_stripes 1
             stripe 0 devid 1 offset 1048576
             dev_uuid 043443c7-ac91-4085-a5e4-983b59dd0803
             stripe 1 devid 1 offset 11534336
             dev_uuid 043443c7-ac91-4085-a5e4-983b59dd0803


