Return-Path: <SRS0=Gb2+=PB=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 33B72C43387
	for <linux-btrfs@archiver.kernel.org>; Mon, 24 Dec 2018 00:58:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E1381217D7
	for <linux-btrfs@archiver.kernel.org>; Mon, 24 Dec 2018 00:58:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=colorremedies-com.20150623.gappssmtp.com header.i=@colorremedies-com.20150623.gappssmtp.com header.b="hd0bgk9b"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726361AbeLXA6Y (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sun, 23 Dec 2018 19:58:24 -0500
Received: from mail-lf1-f68.google.com ([209.85.167.68]:37154 "EHLO
        mail-lf1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726016AbeLXA6Y (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 23 Dec 2018 19:58:24 -0500
Received: by mail-lf1-f68.google.com with SMTP id y11so7397550lfj.4
        for <linux-btrfs@vger.kernel.org>; Sun, 23 Dec 2018 16:58:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=colorremedies-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=9GXBVZZv8eaeIslJg4uczJKdMZQF0b1StGn9NB0qWGA=;
        b=hd0bgk9bE7IW8ZmoV7MTBWI4kyGgEPqD4DPQL4TSTs3VPLNj3e8QOdDgEFPX9j3RMH
         zn/CHdB9SrZy9DW3DU0FyQmUa2ZvK0FQsn1e0lO3UjH59X8mE63yOy/PJo75e29GF6TN
         G9LfbF/BvE+Le0HOyGNQJ1QpDqw3ue/M5FKc3i/HhLIhDRQLL3oUvcU5qWAnDqyFflJh
         5a2eqsG0ROIUX9vvV6l6sMz72+ReactKI0bnh7EaSreGQaHiX5GLjj8oLi8mC//0I0Nh
         AAgcZdDkiZwVsMI+fRJ/azVa7OG/AqWtZNExq6loS9A9HiCZOyOSdDY9vUnHc0BmIKKF
         nw3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=9GXBVZZv8eaeIslJg4uczJKdMZQF0b1StGn9NB0qWGA=;
        b=PxM2+ZEHxv7y8OLyNs3XMpDfLrYFXKmMy4H1kbyta2XqrxbzBsnlKiMrZOV77Aa0bj
         suf6O2LleKXJnL1Icv5NdETb89iAw2kdHp7fdn1livsDoC/ZPc0/71LL2LbK6pA6xs16
         lrC2uIkDO8hzZqS647DxaDScyBPkbODpY1lYZIFp1sbS9x2zBnnp1Y7bwwPCueHaS5tV
         5M9cGT71/Sh4awkrsPihaPw/ZgMpvjS5l1h4acdERCBlQKdbo1Vb8ZThNXe9ybN4YjoN
         EXmf8Zlswie1rWagBWpj9OSz7F0Qo9L1ya2HkKTt9aTk6GJYMeicj1D1NZtQPxZ40ezk
         dIVQ==
X-Gm-Message-State: AA+aEWZIe+HFdFDejwo2eECWLMbLSqQ+pF/EogegXO9/P5UAiNJXfiut
        nES9h6tsA75vR4XhY6dsabg7NrpsC2LkIaqYvyoEzw==
X-Google-Smtp-Source: AFSGD/WT6X3XZAZLI92KQIrnOdqA5EoB7W35M843Zso5KEA/W0uFp07R9XjFzD14ll8lBBF5FOhGi3qu/jxeDP8iZgY=
X-Received: by 2002:a19:2755:: with SMTP id n82mr5226584lfn.94.1545613102276;
 Sun, 23 Dec 2018 16:58:22 -0800 (PST)
MIME-Version: 1.0
References: <1aa82e28-3331-bc64-071c-6cf87b08ad94@petezilla.co.uk>
 <CAJCQCtRY-=AoHDxu--YOWfrs774QzrYj-AwvwD3H_YpTzDKfZw@mail.gmail.com> <3b4d0ed3-4151-50b9-b1da-6be240bb58b3@petezilla.co.uk>
In-Reply-To: <3b4d0ed3-4151-50b9-b1da-6be240bb58b3@petezilla.co.uk>
From:   Chris Murphy <lists@colorremedies.com>
Date:   Sun, 23 Dec 2018 17:58:08 -0700
Message-ID: <CAJCQCtRv2NOabzMB0A9A7hoZcu_-6Fy2+umc8+qYcWnv=wn7bQ@mail.gmail.com>
Subject: Re: Mount issue, mount /dev/sdc2: can't read superblock
To:     Peter Chant <pete@petezilla.co.uk>,
        Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc:     Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Sat, Dec 22, 2018 at 10:22 AM Peter Chant <pete@petezilla.co.uk> wrote:

> btrfs rescue super -v /dev/sdb2
...
> All supers are valid, no need to recover
>
>
> btrfs insp dump-s -f <dev>
...
> generation              7937947
...
>         backup 0:
>                 backup_tree_root:       1113909100544   gen: 7937935    level: 1
...
>         backup 1:
>                 backup_tree_root:       1113907347456   gen: 7937936    level: 1
...
>         backup 2:
>                 backup_tree_root:       1113911951360   gen: 7937937    level: 1
...
>         backup 3:
>                 backup_tree_root:       1113907494912   gen: 7937934    level: 1
...


The kernel wrote out three valid checksummed supers, with what seems
to be a rather significant sanity violation. The super generation and
tree root address do not match any of the backup tree roots. The
*current* tree root is supposed to be in one of the backups as well.

Qu, any idea how this is even theoretically possible? Bit flip right
before the super is computed and checksummed? Seems like some kind of
corruption before checksum is computed.


> I'm getting suspicious of the drive as when I was trying the various
> btrfs rescue * tools I saw a 'bad block', or similar, error displayed.
> I also have a separate basic install on ext4 on the same disk.  Though
> e2fsck shows no errors and mounts fine I cannot log into that install.
> Maybe a coincidence, but too many bad things thrown up make me
> suspicious.  Whatever is happening this seems to be really fighting me.

I'm not sure how even a bad device accounts for the super generation
and backup mismatches. That's damn strange.

If you get bored with the back and forth and just want to give up,
that's fine. I suggest that if you have the time and space, to take a
btrfs-image in case Qu or some other developer wants to look at this
file system at some point. The btrfs-image is a read only process, can
be set to scrub filenames, and only contains metadata. Size of the
resulting file is around 1/2 of the size of metadata, when doing
'btrfs filesystem usage' or 'btrfs filesystem df'. So you'll need that
much free space to direct the command to.

btrfs-image -ss -c9 -t4 <devicetoimage> pathtofile

It might fail, if so you can try adding -w and see if that helps.

There is no log listed in the super so zero-log isn't indicated, and
also tells me there were no fsync's still flushing at the time of the
crash. The loss should be at most a minute of data, not an
inconsistent file system that can't be mounted anymore. Pretty weird.

What were your mount options? Defaults? Anything custom like discard,
commit=, notreelog? Any non-default mount options themselves would not
be the cause of the problem, but might suggest partial ideas for what
might have happened.



-- 
Chris Murphy
