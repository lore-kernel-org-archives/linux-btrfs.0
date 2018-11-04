Return-Path: <SRS0=b0aI=NP=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 92E93ECDE44
	for <linux-btrfs@archiver.kernel.org>; Sun,  4 Nov 2018 15:35:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2E3C02082E
	for <linux-btrfs@archiver.kernel.org>; Sun,  4 Nov 2018 15:35:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="djlXYund"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2E3C02082E
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730519AbeKEAvL (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sun, 4 Nov 2018 19:51:11 -0500
Received: from mail-lf1-f41.google.com ([209.85.167.41]:42598 "EHLO
        mail-lf1-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729687AbeKEAvL (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Sun, 4 Nov 2018 19:51:11 -0500
Received: by mail-lf1-f41.google.com with SMTP id q6-v6so4363633lfh.9
        for <linux-btrfs@vger.kernel.org>; Sun, 04 Nov 2018 07:35:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to;
        bh=MEC0AQuK9d64aaAtNdLTIR6x/0rbY57CVEzYQeeMM9I=;
        b=djlXYundbfGolz/LsY0kZiunNSxQbQW0aRKLGo59RoRcOO8gJWMcujzsBg9gNN2JtG
         OsOoLcCzuy34KZU0o1a/F5UQAQpH+lc9ykReVkkeIYAafxWK1+4jnLL+zkRY0B5FNYrg
         gpwDgrU4rEwZcJVOSwezrhkg5GRMLYqLUBbx9FT6NkvI+WIkPtmzrXiVmx5K2Qq+pev1
         b5brvMSSSj/OUJcb9AIK76/izn/kwOwKBkHKKymEe0gZKF7X0CinA0LUFWzkgG4i15HP
         Amdyd9HQWJjLlEnGHKMwG1JSWaodMtsRJp8xSqLVL7nYg94OKubDoIy5Y2vRyQxyGnZA
         Y92w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to;
        bh=MEC0AQuK9d64aaAtNdLTIR6x/0rbY57CVEzYQeeMM9I=;
        b=oy0HgsWuiq3h+x6eJKm9y3B3HVydb6+ECqMvPjpCgNDIDqj3Co4Br+Pu3SCOAFwAqe
         /ROtk7eliMjhO7rCXeM0pu3JKs4kWwupfv2ddt1s5w6qrcvTPK5LDRXktdw/beizC0FG
         SA2TNd/zaDeyxIAcYq3BZxd6LEIj0PTTlDIxhOjWFahmLCfXFjDoBVj2IQyeQTqdoZik
         2y7udycN/ZPf7YAN5VurxSEBq+G60vfpWD+Auz+2EFjjubD4sJXHipM55sBdb46C17yq
         JChVZfCLEUcnZr/OmAWsBQSFvyPgF5yT/yAdprwaAaRfRHGpE7/MdlW6tP5BeHGMwOks
         MOGg==
X-Gm-Message-State: AGRZ1gJowBTrNZAnIjWzJWKDQ+1H8RwznFnYIdJvBZkHBuA1JUqFTxcU
        tMP/JV1LrtR1CxqDHA0H0GPXh11LnkSoxdXVBWkaRag=
X-Google-Smtp-Source: AJdET5cr81J4iJBYpmW0swIkCFuQpVOqrn6UwogPaYwDmf4t5pxGNoPRZqmiLzwld22hruxcuNLE6notw508h5uFVJ8=
X-Received: by 2002:a19:ae03:: with SMTP id f3mr5083583lfc.86.1541345745321;
 Sun, 04 Nov 2018 07:35:45 -0800 (PST)
MIME-Version: 1.0
References: <d03d611b-cd2e-d267-268a-255f90348e43@dirtcellar.net>
In-Reply-To: <d03d611b-cd2e-d267-268a-255f90348e43@dirtcellar.net>
From:   Sterling Windmill <swindmill@gmail.com>
Date:   Sun, 4 Nov 2018 10:35:33 -0500
Message-ID: <CAMOu_z0879AZEKHPDFOFeGL8H4E2Uj+CzFYV6tSdqHoHF5NyNg@mail.gmail.com>
Subject: Re: BTRFS did it's job nicely (thanks!)
To:     linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Out of curiosity, what led to you choosing RAID1 for data but RAID10
for metadata?

I've flip flipped between these two modes myself after finding out
that BTRFS RAID10 doesn't work how I would've expected.

Wondering what made you choose your configuration.

Thanks!

On Fri, Nov 2, 2018 at 3:55 PM waxhead <waxhead@dirtcellar.net> wrote:
>
> Hi,
>
> my main computer runs on a 7x SSD BTRFS as rootfs with
> data:RAID1 and metadata:RAID10.
>
> One SSD is probably about to fail, and it seems that BTRFS fixed it
> nicely (thanks everyone!)
>
> I decided to just post the ugly details in case someone just wants to
> have a look. Note that I tend to interpret the btrfs de st / output as
> if the error was NOT fixed even if (seems clearly that) it was, so I
> think the output is a bit misleading... just saying...
>
>
>
> -- below are the details for those curious (just for fun) ---
>
> scrub status for [YOINK!]
>          scrub started at Fri Nov  2 17:49:45 2018 and finished after
> 00:29:26
>          total bytes scrubbed: 1.15TiB with 1 errors
>          error details: csum=1
>          corrected errors: 1, uncorrectable errors: 0, unverified errors: 0
>
>   btrfs fi us -T /
> Overall:
>      Device size:                   1.18TiB
>      Device allocated:              1.17TiB
>      Device unallocated:            9.69GiB
>      Device missing:                  0.00B
>      Used:                          1.17TiB
>      Free (estimated):              6.30GiB      (min: 6.30GiB)
>      Data ratio:                       2.00
>      Metadata ratio:                   2.00
>      Global reserve:              512.00MiB      (used: 0.00B)
>
>               Data      Metadata  System
> Id Path      RAID1     RAID10    RAID10    Unallocated
> -- --------- --------- --------- --------- -----------
>   6 /dev/sda1 236.28GiB 704.00MiB  32.00MiB   485.00MiB
>   7 /dev/sdb1 233.72GiB   1.03GiB  32.00MiB     2.69GiB
>   2 /dev/sdc1 110.56GiB 352.00MiB         -   904.00MiB
>   8 /dev/sdd1 234.96GiB   1.03GiB  32.00MiB     1.45GiB
>   1 /dev/sde1 164.90GiB   1.03GiB  32.00MiB     1.72GiB
>   9 /dev/sdf1 109.00GiB   1.03GiB  32.00MiB   744.00MiB
> 10 /dev/sdg1 107.98GiB   1.03GiB  32.00MiB     1.74GiB
> -- --------- --------- --------- --------- -----------
>     Total     598.70GiB   3.09GiB  96.00MiB     9.69GiB
>     Used      597.25GiB   1.57GiB 128.00KiB
>
>
>
> uname -a
> Linux main 4.18.0-2-amd64 #1 SMP Debian 4.18.10-2 (2018-10-07) x86_64
> GNU/Linux
>
> btrfs --version
> btrfs-progs v4.17
>
>
> dmesg | grep -i btrfs
> [    7.801817] Btrfs loaded, crc32c=crc32c-generic
> [    8.163288] BTRFS: device label btrfsroot devid 10 transid 669961
> /dev/sdg1
> [    8.163433] BTRFS: device label btrfsroot devid 9 transid 669961
> /dev/sdf1
> [    8.163591] BTRFS: device label btrfsroot devid 1 transid 669961
> /dev/sde1
> [    8.163734] BTRFS: device label btrfsroot devid 8 transid 669961
> /dev/sdd1
> [    8.163974] BTRFS: device label btrfsroot devid 2 transid 669961
> /dev/sdc1
> [    8.164117] BTRFS: device label btrfsroot devid 7 transid 669961
> /dev/sdb1
> [    8.164262] BTRFS: device label btrfsroot devid 6 transid 669961
> /dev/sda1
> [    8.206174] BTRFS info (device sde1): disk space caching is enabled
> [    8.206236] BTRFS info (device sde1): has skinny extents
> [    8.348610] BTRFS info (device sde1): enabling ssd optimizations
> [    8.854412] BTRFS info (device sde1): enabling free space tree
> [    8.854471] BTRFS info (device sde1): using free space tree
> [   68.170580] BTRFS warning (device sde1): csum failed root 3760 ino
> 3247424 off 125434560512 csum 0x2e395164 expected csum 0x6514b2c2 mirror 2
> [   68.185973] BTRFS warning (device sde1): csum failed root 3760 ino
> 3247424 off 125434560512 csum 0x2e395164 expected csum 0x6514b2c2 mirror 2
> [   68.185991] BTRFS warning (device sde1): csum failed root 3760 ino
> 3247424 off 125434560512 csum 0x2e395164 expected csum 0x6514b2c2 mirror 2
> [   68.186003] BTRFS warning (device sde1): csum failed root 3760 ino
> 3247424 off 125434560512 csum 0x2e395164 expected csum 0x6514b2c2 mirror 2
> [   68.186015] BTRFS warning (device sde1): csum failed root 3760 ino
> 3247424 off 125434560512 csum 0x2e395164 expected csum 0x6514b2c2 mirror 2
> [   68.186028] BTRFS warning (device sde1): csum failed root 3760 ino
> 3247424 off 125434560512 csum 0x2e395164 expected csum 0x6514b2c2 mirror 2
> [   68.186041] BTRFS warning (device sde1): csum failed root 3760 ino
> 3247424 off 125434560512 csum 0x2e395164 expected csum 0x6514b2c2 mirror 2
> [   68.186052] BTRFS warning (device sde1): csum failed root 3760 ino
> 3247424 off 125434560512 csum 0x2e395164 expected csum 0x6514b2c2 mirror 2
> [   68.186063] BTRFS warning (device sde1): csum failed root 3760 ino
> 3247424 off 125434560512 csum 0x2e395164 expected csum 0x6514b2c2 mirror 2
> [   68.186075] BTRFS warning (device sde1): csum failed root 3760 ino
> 3247424 off 125434560512 csum 0x2e395164 expected csum 0x6514b2c2 mirror 2
> [   68.199237] BTRFS info (device sde1): read error corrected: ino
> 3247424 off 36700160 (dev /dev/sda1 sector 244987192)
> [   68.202602] BTRFS info (device sde1): read error corrected: ino
> 3247424 off 36704256 (dev /dev/sda1 sector 244987192)
> [   68.203176] BTRFS info (device sde1): read error corrected: ino
> 3247424 off 36712448 (dev /dev/sda1 sector 244987192)
> [   68.206762] BTRFS info (device sde1): read error corrected: ino
> 3247424 off 36708352 (dev /dev/sda1 sector 244987192)
> [   68.212071] BTRFS info (device sde1): read error corrected: ino
> 3247424 off 36720640 (dev /dev/sda1 sector 244987192)
> [   68.217220] BTRFS info (device sde1): read error corrected: ino
> 3247424 off 36716544 (dev /dev/sda1 sector 244987192)
> [   68.229984] BTRFS info (device sde1): read error corrected: ino
> 3247424 off 36724736 (dev /dev/sda1 sector 244987192)
> [   68.231579] BTRFS info (device sde1): read error corrected: ino
> 3247424 off 36728832 (dev /dev/sda1 sector 244987192)
> [   68.231725] BTRFS info (device sde1): read error corrected: ino
> 3247424 off 36732928 (dev /dev/sda1 sector 244987192)
> [   68.231772] BTRFS info (device sde1): read error corrected: ino
> 3247424 off 36737024 (dev /dev/sda1 sector 244987192)
> [  912.685787] btrfs_print_data_csum_error: 23 callbacks suppressed
> [  912.685792] BTRFS warning (device sde1): csum failed root 3760 ino
> 3247424 off 125434560512 csum 0xb9ad3e35 expected csum 0x6514b2c2 mirror 2
> [  912.686107] BTRFS warning (device sde1): csum failed root 3760 ino
> 3247424 off 125434560512 csum 0xb9ad3e35 expected csum 0x6514b2c2 mirror 2
> [  912.686335] BTRFS warning (device sde1): csum failed root 3760 ino
> 3247424 off 125434560512 csum 0xb9ad3e35 expected csum 0x6514b2c2 mirror 2
> [  912.695110] BTRFS warning (device sde1): csum failed root 3760 ino
> 3247424 off 125434560512 csum 0xb9ad3e35 expected csum 0x6514b2c2 mirror 2
> [  912.695138] BTRFS warning (device sde1): csum failed root 3760 ino
> 3247424 off 125434560512 csum 0xb9ad3e35 expected csum 0x6514b2c2 mirror 2
> [  912.695150] BTRFS warning (device sde1): csum failed root 3760 ino
> 3247424 off 125434560512 csum 0xb9ad3e35 expected csum 0x6514b2c2 mirror 2
> [  912.695162] BTRFS warning (device sde1): csum failed root 3760 ino
> 3247424 off 125434560512 csum 0xb9ad3e35 expected csum 0x6514b2c2 mirror 2
> [  912.695173] BTRFS warning (device sde1): csum failed root 3760 ino
> 3247424 off 125434560512 csum 0xb9ad3e35 expected csum 0x6514b2c2 mirror 2
> [  912.695185] BTRFS warning (device sde1): csum failed root 3760 ino
> 3247424 off 125434560512 csum 0xb9ad3e35 expected csum 0x6514b2c2 mirror 2
> [  912.695225] BTRFS warning (device sde1): csum failed root 3760 ino
> 3247424 off 125434560512 csum 0xb9ad3e35 expected csum 0x6514b2c2 mirror 2
> [  912.737998] BTRFS info (device sde1): read error corrected: ino
> 3247424 off 36753408 (dev /dev/sda1 sector 244987192)
> [  912.747407] BTRFS info (device sde1): read error corrected: ino
> 3247424 off 36810752 (dev /dev/sda1 sector 244987192)
> [  912.755449] BTRFS info (device sde1): read error corrected: ino
> 3247424 off 36782080 (dev /dev/sda1 sector 244987192)
> [  912.758745] BTRFS info (device sde1): read error corrected: ino
> 3247424 off 36720640 (dev /dev/sda1 sector 244987192)
> [  912.759945] BTRFS info (device sde1): read error corrected: ino
> 3247424 off 36728832 (dev /dev/sda1 sector 244987192)
> [  912.768136] BTRFS info (device sde1): read error corrected: ino
> 3247424 off 36724736 (dev /dev/sda1 sector 244987192)
> [  912.776749] BTRFS info (device sde1): read error corrected: ino
> 3247424 off 36716544 (dev /dev/sda1 sector 244987192)
> [  912.784312] BTRFS info (device sde1): read error corrected: ino
> 3247424 off 36704256 (dev /dev/sda1 sector 244987192)
> [  912.784456] BTRFS info (device sde1): read error corrected: ino
> 3247424 off 36790272 (dev /dev/sda1 sector 244987192)
> [  912.784519] BTRFS info (device sde1): read error corrected: ino
> 3247424 off 36798464 (dev /dev/sda1 sector 244987192)
> [ 1298.747500] btrfs_print_data_csum_error: 7 callbacks suppressed
> [ 1298.747505] BTRFS warning (device sde1): csum failed root 3760 ino
> 3247424 off 125434560512 csum 0xe7cb8d8c expected csum 0x6514b2c2 mirror 2
> [ 1298.747529] BTRFS warning (device sde1): csum failed root 3760 ino
> 3247424 off 125434560512 csum 0xe7cb8d8c expected csum 0x6514b2c2 mirror 2
> [ 1298.748379] BTRFS warning (device sde1): csum failed root 3760 ino
> 3247424 off 125434560512 csum 0xe7cb8d8c expected csum 0x6514b2c2 mirror 2
> [ 1298.763245] BTRFS warning (device sde1): csum failed root 3760 ino
> 3247424 off 125434560512 csum 0xe7cb8d8c expected csum 0x6514b2c2 mirror 2
> [ 1298.763264] BTRFS warning (device sde1): csum failed root 3760 ino
> 3247424 off 125434560512 csum 0xe7cb8d8c expected csum 0x6514b2c2 mirror 2
> [ 1298.763290] BTRFS warning (device sde1): csum failed root 3760 ino
> 3247424 off 125434560512 csum 0xe7cb8d8c expected csum 0x6514b2c2 mirror 2
> [ 1298.763305] BTRFS warning (device sde1): csum failed root 3760 ino
> 3247424 off 125434560512 csum 0xe7cb8d8c expected csum 0x6514b2c2 mirror 2
> [ 1298.763320] BTRFS warning (device sde1): csum failed root 3760 ino
> 3247424 off 125434560512 csum 0xe7cb8d8c expected csum 0x6514b2c2 mirror 2
> [ 1298.764537] BTRFS warning (device sde1): csum failed root 3760 ino
> 3247424 off 125434560512 csum 0xe7cb8d8c expected csum 0x6514b2c2 mirror 2
> [ 1298.764560] BTRFS warning (device sde1): csum failed root 3760 ino
> 3247424 off 125434560512 csum 0xe7cb8d8c expected csum 0x6514b2c2 mirror 2
> [ 1298.788874] BTRFS info (device sde1): read error corrected: ino
> 3247424 off 36704256 (dev /dev/sda1 sector 244987192)
> [ 1298.795023] BTRFS info (device sde1): read error corrected: ino
> 3247424 off 36728832 (dev /dev/sda1 sector 244987192)
> [ 1298.804992] BTRFS info (device sde1): read error corrected: ino
> 3247424 off 36753408 (dev /dev/sda1 sector 244987192)
> [ 1298.819343] BTRFS info (device sde1): read error corrected: ino
> 3247424 off 36724736 (dev /dev/sda1 sector 244987192)
> [ 1298.824461] BTRFS info (device sde1): read error corrected: ino
> 3247424 off 36732928 (dev /dev/sda1 sector 244987192)
> [ 1298.827573] BTRFS info (device sde1): read error corrected: ino
> 3247424 off 36720640 (dev /dev/sda1 sector 244987192)
> [ 1298.935345] BTRFS info (device sde1): read error corrected: ino
> 3247424 off 36712448 (dev /dev/sda1 sector 244987192)
> [ 1298.935474] BTRFS info (device sde1): read error corrected: ino
> 3247424 off 36794368 (dev /dev/sda1 sector 244987192)
> [ 1298.935583] BTRFS info (device sde1): read error corrected: ino
> 3247424 off 36790272 (dev /dev/sda1 sector 244987192)
> [ 1298.935690] BTRFS info (device sde1): read error corrected: ino
> 3247424 off 36806656 (dev /dev/sda1 sector 244987192)
> [ 1326.930851] BTRFS warning (device sde1): checksum error at logical
> 4996352077824 on dev /dev/sda1, physical 125433442304, root 3760, inode
> 3247424, offset 36700160, length 4096, links 1 (path: seamonkey/libxul.so)
> [ 1326.930862] BTRFS error (device sde1): bdev /dev/sda1 errs: wr 0, rd
> 0, flush 0, corrupt 1, gen 0
> [ 1326.988294] BTRFS error (device sde1): fixed up error at logical
> 4996352077824 on dev /dev/sda1
>
> btrfs de st /
> [/dev/sde1].write_io_errs    0
> [/dev/sde1].read_io_errs     0
> [/dev/sde1].flush_io_errs    0
> [/dev/sde1].corruption_errs  0
> [/dev/sde1].generation_errs  0
> [/dev/sdc1].write_io_errs    0
> [/dev/sdc1].read_io_errs     0
> [/dev/sdc1].flush_io_errs    0
> [/dev/sdc1].corruption_errs  0
> [/dev/sdc1].generation_errs  0
> [/dev/sda1].write_io_errs    0
> [/dev/sda1].read_io_errs     0
> [/dev/sda1].flush_io_errs    0
> [/dev/sda1].corruption_errs  1 **** <- Look ma! here I am!
> [/dev/sda1].generation_errs  0
> [/dev/sdb1].write_io_errs    0
> [/dev/sdb1].read_io_errs     0
> [/dev/sdb1].flush_io_errs    0
> [/dev/sdb1].corruption_errs  0
> [/dev/sdb1].generation_errs  0
> [/dev/sdd1].write_io_errs    0
> [/dev/sdd1].read_io_errs     0
> [/dev/sdd1].flush_io_errs    0
> [/dev/sdd1].corruption_errs  0
> [/dev/sdd1].generation_errs  0
> [/dev/sdf1].write_io_errs    0
> [/dev/sdf1].read_io_errs     0
> [/dev/sdf1].flush_io_errs    0
> [/dev/sdf1].corruption_errs  0
> [/dev/sdf1].generation_errs  0
> [/dev/sdg1].write_io_errs    0
> [/dev/sdg1].read_io_errs     0
> [/dev/sdg1].flush_io_errs    0
> [/dev/sdg1].corruption_errs  0
> [/dev/sdg1].generation_errs  0
