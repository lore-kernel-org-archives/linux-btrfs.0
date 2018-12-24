Return-Path: <SRS0=Gb2+=PB=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2C2C2C64E75
	for <linux-btrfs@archiver.kernel.org>; Mon, 24 Dec 2018 23:20:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D14E421850
	for <linux-btrfs@archiver.kernel.org>; Mon, 24 Dec 2018 23:20:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=colorremedies-com.20150623.gappssmtp.com header.i=@colorremedies-com.20150623.gappssmtp.com header.b="mNGfx7cR"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725806AbeLXXUr (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 24 Dec 2018 18:20:47 -0500
Received: from mail-lj1-f170.google.com ([209.85.208.170]:34050 "EHLO
        mail-lj1-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725788AbeLXXUr (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 24 Dec 2018 18:20:47 -0500
Received: by mail-lj1-f170.google.com with SMTP id u89-v6so11208549lje.1
        for <linux-btrfs@vger.kernel.org>; Mon, 24 Dec 2018 15:20:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=colorremedies-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=I2kSTeeetQjVfJbJtvLANwaPgzelG4R2XuXTYkVmWe4=;
        b=mNGfx7cR8BsaiX3iqvuOdIyEz3fUhw7K+dy/GHHu7gkItf9aR+wGfwiyY4c0XPrIoz
         OETy9S2pI55qImLmg7nPlpy4lY6QFnfDsTwot4wdKM3V+toGp/4079peiKxwiQDNDJF+
         T+a50HjxJOfLn4eWjDpkegz78O5c0pruk8yfSyhCSmsyCy8toGXHuVOdmkFbQCD2dB3B
         ey+9zJIlXhObfMJb4tT380fWPMRU1Vp/sxo1IUhRKrcvc1Pw0NB0qxHd+7Jbm+aS/Vc1
         9sA4QMAiP6ulr06R8j20oDfh4dQ8sAbdYQ/0mzQhqj/K3OVmjPNF1SVwyFbSpIw4r2zo
         pC4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=I2kSTeeetQjVfJbJtvLANwaPgzelG4R2XuXTYkVmWe4=;
        b=cnWsRR8kwBXHtiGn8FR16L2A3EXC80LhrFcO+4hldKuyI5mssYV13u6eGbIqhI2a4F
         QPQM4ZbitTaHxB0ZVM/rIoCFtn/lmJJlJfqiLLOWRCOnqxHPD2S/ddqQ70e68Z1m6Ovs
         tc0NN+lPJB6u+Fv0b8KOHXz/R7cMAlnLHh0DtRw5NblqhfngRIx4Eaq8oB1SRxCQ+IZD
         0TwHBANNPrV0Q7bb2Ys/Z1gkl3eB9L3Ru2khc+FmoAepJcuJQQP4e2GWrLxmT6bGQI2N
         og94hmB7wMkoWseJv97i9cx1w9ZDWEbHk3GbH+mohN3NfXsORFNIiXbi1mHZIMYWMtwu
         M2cA==
X-Gm-Message-State: AA+aEWaQdSKV69eUER5cbC7yYYZDcJGLC8na4GXWWwAhIqYD6NWLDgvY
        OLtGAxXPChLGei4mvy1ls4JR66Zj8P4sI5V+pA7nWw==
X-Google-Smtp-Source: ALg8bN4fjEAsI64r18ozXqvyp4qii8A/Y9tj6WUHoVWptw4e+UOiwe74SlZkOB56wFSmAtGuVOZvX4sAnGh6+9wnfuU=
X-Received: by 2002:a2e:880a:: with SMTP id x10-v6mr8973621ljh.174.1545693645167;
 Mon, 24 Dec 2018 15:20:45 -0800 (PST)
MIME-Version: 1.0
References: <1aa82e28-3331-bc64-071c-6cf87b08ad94@petezilla.co.uk>
 <CAJCQCtRY-=AoHDxu--YOWfrs774QzrYj-AwvwD3H_YpTzDKfZw@mail.gmail.com>
 <3b4d0ed3-4151-50b9-b1da-6be240bb58b3@petezilla.co.uk> <CAJCQCtRv2NOabzMB0A9A7hoZcu_-6Fy2+umc8+qYcWnv=wn7bQ@mail.gmail.com>
 <99716398-e99c-6ee9-e256-6d05fdc48122@petezilla.co.uk>
In-Reply-To: <99716398-e99c-6ee9-e256-6d05fdc48122@petezilla.co.uk>
From:   Chris Murphy <lists@colorremedies.com>
Date:   Mon, 24 Dec 2018 16:20:33 -0700
Message-ID: <CAJCQCtT9oWMgtn4nfEjGcXyih4_F7s9=f6VVEON+=DKFw2b27g@mail.gmail.com>
Subject: Re: Mount issue, mount /dev/sdc2: can't read superblock
To:     Peter Chant <pete@petezilla.co.uk>
Cc:     Chris Murphy <lists@colorremedies.com>,
        Qu Wenruo <quwenruo.btrfs@gmx.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Mon, Dec 24, 2018 at 4:31 AM Peter Chant <pete@petezilla.co.uk> wrote:

>
> Just done that:
> bash-4.3# btrfs-image -ss -c9 -t4 /dev/sdd2
> /mnt/backup/btrfs_issue_dec_2018/btrfs_root_image_error_20181224.img
> WARNING: cannot find a hash collision for '..', generating garbage, it
> won't match indexes

normal for some files including .. and files with really short names


> Now seems to stopped producing output.  Can't see if it is doing
> something useful.  (note, started again, more such messages)

You can watch if the file size of the image is increasing. With SSD
it's maybe around 4MB/s throughput, depending on the CPU.

>
>
> >
> > There is no log listed in the super so zero-log isn't indicated, and
> > also tells me there were no fsync's still flushing at the time of the
> > crash. The loss should be at most a minute of data, not an
> > inconsistent file system that can't be mounted anymore. Pretty weird.
> >
>
> I think I ran zero-log to see if that helped.  Given that there was no
> important data and I'd assume I'd either easily fix it, or wipe it and
> start over I may have taken the 'monkey radomly pounding the buttons'
> approach, short of 'btrfs check --repair'.  I only posted here as I
> though I'd fixed it apart from the one error!  If it were a simple fix
> then it was worth asking.

Yeah I don't know how zero-log actually works, if it just removes the
log tree address in the superblock or if it's more involved than that,
and also changes root tree address+generation.



>
>
> > What were your mount options? Defaults? Anything custom like discard,
> > commit=, notreelog? Any non-default mount options themselves would not
> > be the cause of the problem, but might suggest partial ideas for what
> > might have happened.
> >
> fstab states:
> autodefrag,ssd,discard,noatime,defaults,subvol=_r_sl14.
> 2,compress=lzo

I suggest not using discard when it passes through to the SSD. There
are firmware bugs abound that can cause weird problems. And Btrfs does
not delay discarding any backup metadata once it's dereferenced. So
all the backup trees in the super, once dereferenced also get TRIM'd
by the SSD, rendering them useless.

I was running with discard mount option on an NVMe drive in my laptop,
with no problems. But once I learned how aggressively it TRIMs metdata
subject to the discard mount option, I dropped it. These days I just
depend on the included systemd fstrim.service to issue TRIM once a
week.

I supposed it's possible your problem could be discard/TRIM related,
but somehow I kinda doubt it. Usually such bugs show up with entire
block ranges being wiped out when they shouldn't be (either with zeros
or returning corrupt data). In the meantime, drop it for all file
systems. And also check to make sure the SSD has the latest firmware
version.


-- 
Chris Murphy
