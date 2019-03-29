Return-Path: <SRS0=qcGt=SA=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1CCC2C43381
	for <linux-btrfs@archiver.kernel.org>; Fri, 29 Mar 2019 00:54:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D378B2082F
	for <linux-btrfs@archiver.kernel.org>; Fri, 29 Mar 2019 00:54:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="sZvzbCSr"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728022AbfC2AyI (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 28 Mar 2019 20:54:08 -0400
Received: from mail-oi1-f193.google.com ([209.85.167.193]:33247 "EHLO
        mail-oi1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727929AbfC2AyI (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 28 Mar 2019 20:54:08 -0400
Received: by mail-oi1-f193.google.com with SMTP id e5so409979oii.0
        for <linux-btrfs@vger.kernel.org>; Thu, 28 Mar 2019 17:54:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to;
        bh=jfQh6XwAxAp9FrMQTk9hIfwRvoIeOZYSA8vr+oG9jyM=;
        b=sZvzbCSrp/ff3zvGIFRF74R5uvZfBYKDi1tGd2rdsWtpYj6e7yia6kRRHSgWbThdZX
         mTEIZW5X2VZ0Ge9Uq+oxCDqYDAOTQqgC3YC2jbWrRv7SMh8qOJAZnINLTAPmH4g1Hyrj
         t6R8fuDfY2ti5nu8/helQRSpCwcxE/iMTz6gH8jZ8yr0mq4SPywtrioNWlTqbvp/NBCg
         fzz6BZVd3sP3b/m/3U5L0eG6JnBd1I8yE0W0BaqqpmEwqKN4g7ttvl0CISIAyaVd7rhl
         Vv2SxHN5Pw6bekYOJl9LH59i8kwl19U7UAGrtWEorWS50CIB5xXCy5e6yDu6n4h+bt/T
         02FA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to;
        bh=jfQh6XwAxAp9FrMQTk9hIfwRvoIeOZYSA8vr+oG9jyM=;
        b=l9V31aRlz3YGDOrIe55B7ffFyPDWPukCleUGnYXAO+b4XJBJNhJB1ILtefsEFffhmK
         t1dlOWirKP1mrtWUQHZs2jxKeJhvwfuTFQ9zsmvu3sNMJjkI5KdDHw9AHpeg9UB0rZ/K
         mddWqdhW1PvzUOXWKBOn8KUH6DHwe0SF3sQyzuU/sDnzqY16clMMR42wr4x4sGqpdHBt
         YL4Obn12MIKZuXCRXIZn3qCYqvJYcpo/654AIkuWYiIk1bEQbSLupzIdsPBqOjAeR8qT
         er8kqOfwnkzWCvLmPETNTMiXB/tbN3+MsrgDK7UAu36lMU5/9jXpY1JT76CW3SbUNGkB
         bqsQ==
X-Gm-Message-State: APjAAAV4OSm9NfrJRLyOJMq4UEP/D4WTLE74sbewyGlAk4RXPnI7aYUL
        2gH08PsVPxvY5XoHS8ZXB0oIDD6WjZjGzHwVzmZpwg==
X-Google-Smtp-Source: APXvYqwOG7N99q63LWwcBgA2iT2Gd2uiVUxzEYUg9PppjidKFcyT45caMmtmXfWNZra87a7pSu+6M+8p8oLhtDc4XAo=
X-Received: by 2002:aca:df09:: with SMTP id w9mr1887921oig.94.1553820847415;
 Thu, 28 Mar 2019 17:54:07 -0700 (PDT)
MIME-Version: 1.0
References: <CAG3pWAmvekNpnBsQTaMrefKe6pvMSZjPm+SOxnKkMkpGO_1msQ@mail.gmail.com>
 <CAG3pWAkpKGE+MZQ9BVWtgk7Y6_yne_VErtsEgD4oVPz5tuOTWQ@mail.gmail.com>
In-Reply-To: <CAG3pWAkpKGE+MZQ9BVWtgk7Y6_yne_VErtsEgD4oVPz5tuOTWQ@mail.gmail.com>
From:   Glenn Trigg <ggtrigg@gmail.com>
Date:   Fri, 29 Mar 2019 11:53:56 +1100
Message-ID: <CAG3pWA=k-iZ9ZCpew1vXBh-SrSSuHMqkD1v_V+22bGvnZGDrkQ@mail.gmail.com>
Subject: Re: help request for an unmountable raid1 filesystem
To:     linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

I wonder why this is not getting any replies?

On Sat, 23 Mar 2019 at 11:45, Glenn Trigg <ggtrigg@gmail.com> wrote:
>
> Hi,
>
> Since mailing this I have tried using the more recent utils - version
> btrfs-progs v4.20.2.
>
> I still have not had any success in getting the filesystem to a
> mountable state and I have now also tried recovering files with btrfs
> restore, also with no success. The restore output is:
>
> % ./btrfs restore -D /dev/sdc1 /data2/
> This is a dry-run, no files are going to be restored
> parent transid verify failed on 628168376320 wanted 37601 found 37712
> parent transid verify failed on 628168376320 wanted 37601 found 37712
> parent transid verify failed on 628168376320 wanted 37601 found 37712
> parent transid verify failed on 628168376320 wanted 37601 found 37712
> Ignoring transid failure
> ERROR: child eb corrupted: parent bytenr=628624064512 item=0 parent
> level=1 child level=1
> Error searching -5
>
> Is there something else I could do to recover either the filesystem or
> at least the files?
>
> Regards,
> Glenn
>
> On Sun, 10 Mar 2019 at 08:35, Glenn Trigg <ggtrigg@gmail.com> wrote:
> >
> > Hello,
> >
> > I had some random machine freezing events which I suspected was due to
> > issues with a raid1 filesystem and kernel module crashes. I attempted
> > to use the information available to get the filesystem into a good
> > state where "btrfs check" and "btrfs scrub" would not have any errors,
> > however I fear things have become worse.
> >
> > The current state of things is that the filesystem won't mount at all now.
> >
> > % mount -r /dev/sda1 /data
> > mount: /data: can't read superblock on /dev/sda1.
> >
> > and dmesg says:
> >
> > [15944.017629] BTRFS info (device sda1): disk space caching is enabled
> > [15944.017632] BTRFS info (device sda1): has skinny extents
> > [15944.024480] BTRFS info (device sda1): bdev /dev/sda1 errs: wr 0, rd
> > 0, flush 0, corrupt 1, gen 0
> > [15944.024487] BTRFS info (device sda1): bdev /dev/sdb1 errs: wr 0, rd
> > 0, flush 0, corrupt 4, gen 0
> > [15944.029292] BTRFS error (device sda1): parent transid verify failed
> > on 628168376320 wanted 37601 found 37700
> > [15944.029466] BTRFS error (device sda1): parent transid verify failed
> > on 628168376320 wanted 37601 found 37700
> >
> > Other system information is:
> > % uname -a
> > Linux izen 4.18.0-16-generic #17-Ubuntu SMP Fri Feb 8 00:06:57 UTC
> > 2019 x86_64 x86_64 x86_64 GNU/Linux
> >
> > % btrfs --version
> > btrfs-progs v4.16.1
> >
> > % btrfs fi show
> > Label: 'root'  uuid: 65fd7f11-4f60-435f-928b-6d15f12bc417
> > Total devices 1 FS bytes used 101.75GiB
> > devid    1 size 232.88GiB used 232.85GiB path /dev/nvme0n1p1
> >
> > Label: 'data'  uuid: d5e50511-3e31-4de6-ba37-c5841895be9f
> > Total devices 2 FS bytes used 830.44GiB
> > devid    1 size 1.82TiB used 669.03GiB path /dev/sda1
> > devid    2 size 1.82TiB used 817.06GiB path /dev/sdb1
> >
> > % btrfs check /dev/sda1
> > Checking filesystem on /dev/sda1
> > UUID: d5e50511-3e31-4de6-ba37-c5841895be9f
> > checking extents
> > parent transid verify failed on 628168343552 wanted 28163 found 37700
> > parent transid verify failed on 628168343552 wanted 28163 found 37700
> > parent transid verify failed on 628168343552 wanted 28163 found 37700
> > parent transid verify failed on 628168343552 wanted 28163 found 37700
> > Ignoring transid failure
> > bad block 628168343552
> > ERROR: errors found in extent allocation tree or chunk allocation
> > checking free space cache
> > cache and super generation don't match, space cache will be invalidated
> > checking fs roots
> > root 5 root dir 256 not found
> > ERROR: errors found in fs roots
> > found 528138240 bytes used, error(s) found
> > total csum bytes: 0
> > total tree bytes: 1785856
> > total fs tree bytes: 1064960
> > total extent tree bytes: 81920
> > btree space waste bytes: 606983
> > file data blocks allocated: 215220224
> >  referenced 215220224
> >
> > % btrfs rescue super-recover /dev/sda1
> > All supers are valid, no need to recover
> >
> > Where do I go from here?
> >
> > Regards,
> > Glenn
