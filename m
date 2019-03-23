Return-Path: <SRS0=xp1I=R2=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 27D60C43381
	for <linux-btrfs@archiver.kernel.org>; Sat, 23 Mar 2019 00:45:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DC5D0218D3
	for <linux-btrfs@archiver.kernel.org>; Sat, 23 Mar 2019 00:45:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FkDbwAdy"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727512AbfCWAp4 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 22 Mar 2019 20:45:56 -0400
Received: from mail-oi1-f193.google.com ([209.85.167.193]:34418 "EHLO
        mail-oi1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727183AbfCWAp4 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 22 Mar 2019 20:45:56 -0400
Received: by mail-oi1-f193.google.com with SMTP id u12so3096097oiv.1
        for <linux-btrfs@vger.kernel.org>; Fri, 22 Mar 2019 17:45:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to;
        bh=yMuToihcca5VoPtOw1XUJpnLTsRXic6pgSr0bO9LKZg=;
        b=FkDbwAdyJQqDJHbHqA0vJBpBK+3T6HvkTSdX3GXnYzTbSqFAi0eHPLwwZ5l0qX6vnA
         XKWHSrdaq2YFSuwIVJH4iN0UFgrRvCjZrIeMBJUm7G+fmVjtcibqQg00UqfvvH+yWrpF
         UMi8raHmNWcVcSZw/FzJgbIKG4JRnEq9+NY1FXDyenJjvRv8PM8pB/dUMIUOeYkyvcHb
         zAFJvnRqbL3CVbf8bt40RjOa7uf9hXVaJbUVt4XIfZKYg/uvZFvGe6gfOU7qQsygyDzQ
         +uG2oadkbGbCQf8aZnZ2RpgAdQobpaWrhLptp1HK1VjE/a4tq3rSTs7sLbs1agY0/6m3
         wgZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to;
        bh=yMuToihcca5VoPtOw1XUJpnLTsRXic6pgSr0bO9LKZg=;
        b=WCTAwVACTOqROvqODxn2M1CBFALFbONxqa+OjcI77P5tyAQxmwlVrWnx7mJ0xARWpC
         RkSg60sJ8Ca1yT36w2JdnVhRn2RQ4RsdKH2HAYJUVxwm8M90rjqfpw0YShJbhHdzEcBo
         jlTMR3bBf4LlJc8FEdMWiLgCG+ItNUGfUvx2ydIm9GnzDX9X1vMdk1WLsVaFED374JaN
         efqLH6+eXTY0aYC34oD/JHoDzM+E8amsrikN/KQW4QcEse6+3ZLZipF6HXTwgB/ECl42
         iQY11jOJzw+VEwTBQRmqpFQTn0qwm7ONp32TzZBRXhiy4IFRfZHWZFhO+MfCdK/KzNYg
         xJUw==
X-Gm-Message-State: APjAAAVydi7HhB1RPixOfdX4jJlu2gOrkqPm512P098fYP1lGUjPUGoX
        JhFyQj0ea8gWww06oo46G5zV6clFqNIgVwWD7DOf4sbi
X-Google-Smtp-Source: APXvYqyJwAFICU9Qb5tmhzR70W8fjqjM4hbyaPQMUVrDkHYNPBd7lAJvCfvrbSgOIX63W8WYtn+XFwr4AWWe7UALLT4=
X-Received: by 2002:aca:5757:: with SMTP id l84mr4045548oib.155.1553301955300;
 Fri, 22 Mar 2019 17:45:55 -0700 (PDT)
MIME-Version: 1.0
References: <CAG3pWAmvekNpnBsQTaMrefKe6pvMSZjPm+SOxnKkMkpGO_1msQ@mail.gmail.com>
In-Reply-To: <CAG3pWAmvekNpnBsQTaMrefKe6pvMSZjPm+SOxnKkMkpGO_1msQ@mail.gmail.com>
From:   Glenn Trigg <ggtrigg@gmail.com>
Date:   Sat, 23 Mar 2019 11:45:43 +1100
Message-ID: <CAG3pWAkpKGE+MZQ9BVWtgk7Y6_yne_VErtsEgD4oVPz5tuOTWQ@mail.gmail.com>
Subject: Re: help request for an unmountable raid1 filesystem
To:     linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Hi,

Since mailing this I have tried using the more recent utils - version
btrfs-progs v4.20.2.

I still have not had any success in getting the filesystem to a
mountable state and I have now also tried recovering files with btrfs
restore, also with no success. The restore output is:

% ./btrfs restore -D /dev/sdc1 /data2/
This is a dry-run, no files are going to be restored
parent transid verify failed on 628168376320 wanted 37601 found 37712
parent transid verify failed on 628168376320 wanted 37601 found 37712
parent transid verify failed on 628168376320 wanted 37601 found 37712
parent transid verify failed on 628168376320 wanted 37601 found 37712
Ignoring transid failure
ERROR: child eb corrupted: parent bytenr=628624064512 item=0 parent
level=1 child level=1
Error searching -5

Is there something else I could do to recover either the filesystem or
at least the files?

Regards,
Glenn

On Sun, 10 Mar 2019 at 08:35, Glenn Trigg <ggtrigg@gmail.com> wrote:
>
> Hello,
>
> I had some random machine freezing events which I suspected was due to
> issues with a raid1 filesystem and kernel module crashes. I attempted
> to use the information available to get the filesystem into a good
> state where "btrfs check" and "btrfs scrub" would not have any errors,
> however I fear things have become worse.
>
> The current state of things is that the filesystem won't mount at all now.
>
> % mount -r /dev/sda1 /data
> mount: /data: can't read superblock on /dev/sda1.
>
> and dmesg says:
>
> [15944.017629] BTRFS info (device sda1): disk space caching is enabled
> [15944.017632] BTRFS info (device sda1): has skinny extents
> [15944.024480] BTRFS info (device sda1): bdev /dev/sda1 errs: wr 0, rd
> 0, flush 0, corrupt 1, gen 0
> [15944.024487] BTRFS info (device sda1): bdev /dev/sdb1 errs: wr 0, rd
> 0, flush 0, corrupt 4, gen 0
> [15944.029292] BTRFS error (device sda1): parent transid verify failed
> on 628168376320 wanted 37601 found 37700
> [15944.029466] BTRFS error (device sda1): parent transid verify failed
> on 628168376320 wanted 37601 found 37700
>
> Other system information is:
> % uname -a
> Linux izen 4.18.0-16-generic #17-Ubuntu SMP Fri Feb 8 00:06:57 UTC
> 2019 x86_64 x86_64 x86_64 GNU/Linux
>
> % btrfs --version
> btrfs-progs v4.16.1
>
> % btrfs fi show
> Label: 'root'  uuid: 65fd7f11-4f60-435f-928b-6d15f12bc417
> Total devices 1 FS bytes used 101.75GiB
> devid    1 size 232.88GiB used 232.85GiB path /dev/nvme0n1p1
>
> Label: 'data'  uuid: d5e50511-3e31-4de6-ba37-c5841895be9f
> Total devices 2 FS bytes used 830.44GiB
> devid    1 size 1.82TiB used 669.03GiB path /dev/sda1
> devid    2 size 1.82TiB used 817.06GiB path /dev/sdb1
>
> % btrfs check /dev/sda1
> Checking filesystem on /dev/sda1
> UUID: d5e50511-3e31-4de6-ba37-c5841895be9f
> checking extents
> parent transid verify failed on 628168343552 wanted 28163 found 37700
> parent transid verify failed on 628168343552 wanted 28163 found 37700
> parent transid verify failed on 628168343552 wanted 28163 found 37700
> parent transid verify failed on 628168343552 wanted 28163 found 37700
> Ignoring transid failure
> bad block 628168343552
> ERROR: errors found in extent allocation tree or chunk allocation
> checking free space cache
> cache and super generation don't match, space cache will be invalidated
> checking fs roots
> root 5 root dir 256 not found
> ERROR: errors found in fs roots
> found 528138240 bytes used, error(s) found
> total csum bytes: 0
> total tree bytes: 1785856
> total fs tree bytes: 1064960
> total extent tree bytes: 81920
> btree space waste bytes: 606983
> file data blocks allocated: 215220224
>  referenced 215220224
>
> % btrfs rescue super-recover /dev/sda1
> All supers are valid, no need to recover
>
> Where do I go from here?
>
> Regards,
> Glenn
