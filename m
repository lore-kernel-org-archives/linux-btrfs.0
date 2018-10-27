Return-Path: <SRS0=3TJ0=NH=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1F5F5C46475
	for <linux-btrfs@archiver.kernel.org>; Sat, 27 Oct 2018 20:45:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BF6C220831
	for <linux-btrfs@archiver.kernel.org>; Sat, 27 Oct 2018 20:45:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="YeYawios"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org BF6C220831
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728879AbeJ1F1P (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sun, 28 Oct 2018 01:27:15 -0400
Received: from mail-lj1-f180.google.com ([209.85.208.180]:40038 "EHLO
        mail-lj1-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726226AbeJ1F1O (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 28 Oct 2018 01:27:14 -0400
Received: by mail-lj1-f180.google.com with SMTP id t22-v6so4241064lji.7
        for <linux-btrfs@vger.kernel.org>; Sat, 27 Oct 2018 13:45:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:openpgp:autocrypt:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=TOxjopCGD2KM4hu8DyLCPKyv4FTLyr993LiZRMv5cv4=;
        b=YeYawiosU8tmfuOY64uqFvVAZLUGqX6hb8lOPbDWCExfOC6/Ib+6ou88KkpzOy3Z7J
         UpfSs2Tgx2nP7DfRl2xP1k1m3l/RY9BZ718PfE7sky3ijPyqz0Ea7++J7EJVwHJ6gJXB
         50vJoqQLlJ3SbQsBfO+vzl9QP1cQeL8jqVL7DzInPII953IGIyCp1L1pFGwrEsaYZVGq
         yRPqm+ZRdR33iQdL3GP8VAhvKDcWhxdIFQnCZIJcsahDmi74mcV31QUm9504jsUvw1Kj
         jEXpAj0CNItm8eVtRCuO9O7gZ2qHuWJjhwklhOU6y69aGR8yqLXEEeLU3ilzaBntziiu
         nByw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:openpgp:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=TOxjopCGD2KM4hu8DyLCPKyv4FTLyr993LiZRMv5cv4=;
        b=ehYc5bnwhFrIQLzb85fFPxmu9tkoFgtUsRuES8S4PfmTVQxnLzWIVKUe1/ISKgR3NA
         bp2a4Wil8n8EBV/fv9PrnHHKJjQsU+poOMXNWqR6sB/FaAxlNBuReLZ9YIlqVMuyDXhq
         e4dUhdbOnE/8cyU47+frhShphAraM7BD9rsENu9bMBrNE7WhIZRlS0Og/8sn+vhCejRh
         pAkxJU6dOPKKYjO6+34qNzO83FYZVDOPt5LlPdlMoBLY9iD79cvrd0S/+nG/uO+8MTmr
         X08A5U4aS4ZitGxyWISeQNeHGPlqgszd6Ez0dTmvbg/ZE/zMk6hxD7xh+43ywqm4L1lk
         eRCg==
X-Gm-Message-State: AGRZ1gLQjjHIX60EyCVx7Sn7gyPalC0VVFUriIa7rRwdg8OqOD1AMFFp
        +Iq8v9U2hHwblCzBE0gpswa4xvAS
X-Google-Smtp-Source: AJdET5cBxbEntWZkbXKbrTb/MXPFvFw2cFktcPvo01m32Jn2se5VxHRyrKkGBLuvsd6zAMjqSdxO6A==
X-Received: by 2002:a2e:302:: with SMTP id 2-v6mr5543295ljd.152.1540673100046;
        Sat, 27 Oct 2018 13:45:00 -0700 (PDT)
Received: from [192.168.1.4] (109-252-55-124.nat.spd-mgts.ru. [109.252.55.124])
        by smtp.gmail.com with ESMTPSA id y9-v6sm2219286ljk.35.2018.10.27.13.44.58
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 27 Oct 2018 13:44:59 -0700 (PDT)
Subject: Re: Have 15GB missing in btrfs filesystem.
To:     Remi Gauvin <remi@georgianit.com>, Marc MERLIN <marc@merlins.org>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
References: <20181024003613.q5bxmqm4hh5xbgmf@merlins.org>
 <a8500d2d-2747-f250-75a8-2ec4c0533c6c@gmx.com>
 <20181027174245.4isfcb6nv4pkklmd@merlins.org>
 <d530a9d0-4cee-521b-6c95-ff56d0f7c130@georgianit.com>
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
Message-ID: <95329ddd-3e70-7a00-8ca3-f9ba42c98029@gmail.com>
Date:   Sat, 27 Oct 2018 23:44:57 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.2.1
MIME-Version: 1.0
In-Reply-To: <d530a9d0-4cee-521b-6c95-ff56d0f7c130@georgianit.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

27.10.2018 21:12, Remi Gauvin пишет:
> On 2018-10-27 01:42 PM, Marc MERLIN wrote:
> 
>>
>> I've been using btrfs for a long time now but I've never had a
>> filesystem where I had 15GB apparently unusable (7%) after a balance.
>>
> 
> The space isn't unusable.  It's just allocated.. (It's used in the sense
> that it's reserved for data chunks.).  Start writing data to the drive,
> and the data will fill that space before more gets allocated.. (Unless

No (at least, not necessarily).

On empty filesystem:

bor@10:~> df -h /mnt
Filesystem      Size  Used Avail Use% Mounted on
/dev/sdb1      1023M   17M  656M   3% /mnt
bor@10:~> sudo dd if=/dev/zero of=/mnt/foo bs=100M count=1
1+0 records in
1+0 records out
104857600 bytes (105 MB, 100 MiB) copied, 0.260088 s, 403 MB/s
bor@10:~> sync
bor@10:~> df -h /mnt
Filesystem      Size  Used Avail Use% Mounted on
/dev/sdb1      1023M  117M  556M  18% /mnt
bor@10:~> sudo filefrag -v /mnt/foo
Filesystem type is: 9123683e
File size of /mnt/foo is 104857600 (25600 blocks of 4096 bytes)
 ext:     logical_offset:        physical_offset: length:   expected: flags:
   0:        0..   14419:      36272..     50691:  14420:
   1:    14420..   25599:     125312..    136491:  11180:      50692:
last,eof
/mnt/foo: 2 extents found
bor@10:~> sudo dd if=/dev/zero of=/mnt/foo bs=10M count=1 conv=notrunc
seek=2
1+0 records in
1+0 records out
10485760 bytes (10 MB, 10 MiB) copied, 0.0300004 s, 350 MB/s
bor@10:~> sync
bor@10:~> df -h /mnt
Filesystem      Size  Used Avail Use% Mounted on
/dev/sdb1      1023M  127M  546M  19% /mnt
bor@10:~> sudo filefrag -v /mnt/foo
Filesystem type is: 9123683e
File size of /mnt/foo is 104857600 (25600 blocks of 4096 bytes)
 ext:     logical_offset:        physical_offset: length:   expected: flags:
   0:        0..    5119:      36272..     41391:   5120:
   1:     5120..    7679:      33696..     36255:   2560:      41392:
   2:     7680..   14419:      43952..     50691:   6740:      36256:
   3:    14420..   25599:     125312..    136491:  11180:      50692:
last,eof
/mnt/foo: 4 extents found
bor@10:~> sudo dd if=/dev/zero of=/mnt/foo bs=10M count=1 conv=notrunc
seek=7
1+0 records in
1+0 records out
10485760 bytes (10 MB, 10 MiB) copied, 0.0314211 s, 334 MB/s
bor@10:~> sync
bor@10:~> df -h /mnt
Filesystem      Size  Used Avail Use% Mounted on
/dev/sdb1      1023M  137M  536M  21% /mnt
bor@10:~> sudo filefrag -v /mnt/foo
Filesystem type is: 9123683e
File size of /mnt/foo is 104857600 (25600 blocks of 4096 bytes)
 ext:     logical_offset:        physical_offset: length:   expected: flags:
   0:        0..    5119:      36272..     41391:   5120:
   1:     5120..    7679:      33696..     36255:   2560:      41392:
   2:     7680..   14419:      43952..     50691:   6740:      36256:
   3:    14420..   17919:     125312..    128811:   3500:      50692:
   4:    17920..   20479:     136492..    139051:   2560:     128812:
   5:    20480..   25599:     131372..    136491:   5120:     139052:
last,eof
/mnt/foo: 6 extents found
bor@10:~> ll -sh /mnt
total 100M
100M -rw-r--r-- 1 root root 100M Oct 27 23:30 foo
bor@10:~>

So you still have the single file with size of 100M but space consumed
on filesystem is 120M because two initial large extents remain. Each
write of 10M will get new extent allocated, but large extents are not
split. If you look at file details

bor@10:~/python-btrfs/examples> sudo ./show_file.py /mnt/foo
filename /mnt/foo tree 5 inum 259
inode generation 239 transid 242 size 104857600 nbytes 104857600
block_group 0 mode 100644 nlink 1 uid 0 gid 0 rdev 0 flags 0x0(none)
inode ref list size 1
    inode ref index 3 name utf-8 foo
extent data at 0 generation 239 ram_bytes 46563328 compression none type
regular disk_bytenr 148570112 disk_num_bytes 46563328 offset 0 num_bytes
20971520

This extent consumes about 44MB on disk but only 20MB of it is part of file.

extent data at 20971520 generation 241 ram_bytes 10485760 compression
none type regular disk_bytenr 138018816 disk_num_bytes 10485760 offset 0
num_bytes 10485760
extent data at 31457280 generation 239 ram_bytes 46563328 compression
none type regular disk_bytenr 148570112 disk_num_bytes 46563328 offset
31457280 num_bytes 15106048

And another 14MB. So 10MB allocated on disk are "lost".

extent data at 46563328 generation 239 ram_bytes 12500992 compression
none type regular disk_bytenr 195133440 disk_num_bytes 12500992 offset 0
num_bytes 12500992
extent data at 59064320 generation 239 ram_bytes 45793280 compression
none type regular disk_bytenr 513277952 disk_num_bytes 45793280 offset 0
num_bytes 14336000
extent data at 73400320 generation 242 ram_bytes 10485760 compression
none type regular disk_bytenr 559071232 disk_num_bytes 10485760 offset 0
num_bytes 10485760
extent data at 83886080 generation 239 ram_bytes 45793280 compression
none type regular disk_bytenr 513277952 disk_num_bytes 45793280 offset
24821760 num_bytes 20971520

Same here. 10MB in extent at 513277952 are lost.

There is no way to regain them using balance. Only defragmentation can
potentially rewrite file freeing partial extents.

> you are using an older kernel and the filesystem gets mounted with ssd
> option, in which case, you'll want to add nossd option to prevent that
> behaviour.)
> 
> You can use btrfs fi usage to display that more clearly.
> 
> 
>> I can try a defrag next, but since I have COW for snapshots, it's not
>> going to help much, correct?
> 
> The defrag will end up using more space, as the fragmented parts of
> files will get duplicated.  That being said, if you have the luxury to
> defrag *before* taking new snapshots, that would be the time to do it.
> 

