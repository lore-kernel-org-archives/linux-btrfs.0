Return-Path: <SRS0=1LDH=ON=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 32476C04EBF
	for <linux-btrfs@archiver.kernel.org>; Tue,  4 Dec 2018 06:46:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E45F620834
	for <linux-btrfs@archiver.kernel.org>; Tue,  4 Dec 2018 06:46:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="gmC8LIb5"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E45F620834
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726070AbeLDGq1 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 4 Dec 2018 01:46:27 -0500
Received: from mail-it1-f195.google.com ([209.85.166.195]:38741 "EHLO
        mail-it1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726065AbeLDGq0 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 4 Dec 2018 01:46:26 -0500
Received: by mail-it1-f195.google.com with SMTP id h65so12750869ith.3
        for <linux-btrfs@vger.kernel.org>; Mon, 03 Dec 2018 22:46:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Zs2FnWRhF1GB44BZU5BjuSNPbL4u+/IbzeLj+nlp8aY=;
        b=gmC8LIb5orpTet2WC06I9rrE7hyn4ApfDRs1XAmU3HLr7RkrYi+tTe3M/ca9EwKZzU
         ROS9WJ7aV+ugWwR+NfrJ3Pxf8+oeIkbBk8DB82eESKR+RoGV1ZhgaqIU8BeX5n9GqTFe
         uqC2rFG/nGTT7sSMhy6bASRwWUbnz8BmYl5Os/mB2Sag+7fTjnPCF2GBPu6iV7+C+kr0
         Ek0eQllrn0LM8NZXmuHLCt6Ugj72auEQtVieL1FPIQzwpP7T9PDohPTRypYI9Fc8gkvQ
         RoqrzKXfEeK8s4tpJks2rBsYbn8P34qI8Q0SW9Th3QGxau0EdeSnj8IJ3lJeOn6X3S1j
         aBbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Zs2FnWRhF1GB44BZU5BjuSNPbL4u+/IbzeLj+nlp8aY=;
        b=Pfi7/P0EN8n1T5fU7miVw2l+FBGFP/mEaoYIsV5tLFy/5TArW3dm2VlTdrSrOpQPSQ
         EmLaODN1hrEoWJ+hwzuC485so7svMjNoNHyF6bv2/4NCqzBUzaUlbwMjP05gZkjTuI3X
         1qn7Rdhy95WQrwbffXQyhonyaRVM/0aG4x/5/ebE1plIuzmBvZddShZLr4njhWty8tTj
         BlSyKmCwOMjfiF9K2d1CjmfCzAVk+ZYX+3meb4OawXkdisYp494Eaq1OIJndTEQC08lz
         j7tFqcVJKk86GDxY8BA5kVoT0HjO3czLPzjHNq60OVBTwyiW9jBzN60+towJtowGIKMf
         YbiA==
X-Gm-Message-State: AA+aEWYm1sh0we6uWJFZIoZ9oWPapKng7EdSjANCMbK51kdVLr9xKGBy
        gh8pC9XC8HzbsTTQvhm6hM/TEawJK8i/aBy0/4YnFkIfUQ4=
X-Google-Smtp-Source: AFSGD/V4bxasd3JhZJAa1ugMFr4sd5w5onbUAbJRnv6/6bOS02yfdu3GPW83fXDNRQY6ofd9Slh3cfflfH5I78DEFLo=
X-Received: by 2002:a24:43c5:: with SMTP id s188mr10937807itb.150.1543905985694;
 Mon, 03 Dec 2018 22:46:25 -0800 (PST)
MIME-Version: 1.0
References: <CAOv1SKD46XeF=iqi4At-0YJpK6nHQ+3ErKDN_sW_4fAPMyAgMw@mail.gmail.com>
 <CAJCQCtRUTavGyh2A4qZe=yT=ydcu1byBy-LKF0jKZwNdZqaEWA@mail.gmail.com>
In-Reply-To: <CAJCQCtRUTavGyh2A4qZe=yT=ydcu1byBy-LKF0jKZwNdZqaEWA@mail.gmail.com>
From:   Mike Javorski <mike.javorski@gmail.com>
Date:   Mon, 3 Dec 2018 22:46:14 -0800
Message-ID: <CAOv1SKDiRwMP8ffLS5po6zecqmEgd4ywau4jhE1G_MC0bSJLgA@mail.gmail.com>
Subject: Re: Ran into "invalid block group size" bug, unclear how to proceed.
To:     lists@colorremedies.com
Cc:     linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Apologies for the dupe Chris, I neglected to hit Reply-All.. Comments below.

On Mon, Dec 3, 2018 at 9:56 PM Chris Murphy <lists@colorremedies.com> wrote:
>
> On Mon, Dec 3, 2018 at 8:32 PM Mike Javorski <mike.javorski@gmail.com> wrote:
> >
> > Need a bit of advice here ladies / gents. I am running into an issue
> > which Qu Wenruo seems to have posted a patch for several weeks ago
> > (see https://patchwork.kernel.org/patch/10694997/).
> >
> > Here is the relevant dmesg output which led me to Qu's patch.
> > ----
> > [   10.032475] BTRFS critical (device sdb): corrupt leaf: root=2
> > block=24655027060736 slot=20 bg_start=13188988928 bg_len=10804527104,
> > invalid block group size, have 10804527104 expect (0, 10737418240]
> > [   10.032493] BTRFS error (device sdb): failed to read block groups: -5
> > [   10.053365] BTRFS error (device sdb): open_ctree failed
> > ----
> >
> > This server has a 16 disk btrfs filesystem (RAID6) which I boot
> > periodically to btrfs-send snapshots to. This machine is running
> > ArchLinux and I had just updated  to their latest 4.19.4 kernel
> > package (from 4.18.10 which was working fine). I've tried updating to
> > the 4.19.6 kernel that is in testing, but that doesn't seem to resolve
> > the issue. From what I can see on kernel.org, the patch above is not
> > pushed to stable or to Linus' tree.
> >
> > At this point the question is what to do. Is my FS toast? Could I
> > revert to the 4.18.10 kernel and boot safely? I don't know if the 4.19
> > boot process may have flipped some bits which would make reverting
> > problematic.
>
> That patch is not yet merged in linux-next so to use it, you'd need to
> apply yourself and compile a kernel. I can't tell for sure if it'd
> help.
>
> But, the less you change the file system, the better chance of saving
> it. I have no idea why there'd be a corrupt leaf just due to a kernel
> version change, though.
>
> Needless to say, raid56 just seems fragile once it runs into any kind
> of trouble. I personally wouldn't boot off it at all. I would only
> mount it from another system, ideally an installed system but a live
> system with the kernel versions you need would also work. That way you
> can get more information without changes, and booting will almost
> immediately mount rw, if mount succeeds at all, and will write a bunch
> of changes to the file system.
>

If the boot could corrupt the disk, that ship has already sailed as I
have previously attempted to mount the volume with the 4.19.4 and
4.19.6 kernels, but they both failed reporting the log lines in my
original message. I am hoping that Qu notices this thread at some
point as they are the author of the original patch which introduced
the check which is now failing, as well as the un-merged patch linked
earlier that adjusts the check condition.

What I don't know is if the checks up until that mount failure have
been read-only and thus I can revert to the older kernel, or if
something would have been written to disk prior to the mount call
failing. I don't want to risk the 23 TiB of snapshot data stored if
it's an easy workaround :-).  I realize there are risks with the
RAID56 code, but I've done my best to mitigate with server-grade
hardware, ECC memory, a UPS and a redundant copy of the data via
btrfs-send to this machine. Losing this snapshot volume is not the end
of the world, but I am about to upgrade the primary server (which is
currently running 4.19.4 without issue btw) and want to have a best
effort snapshot/backup in place before I do so.

> Whether it's a case of 4.18.10 not detecting corruption that 4.19
> sees, or if 4.19 already caused it, the best chance is to not mount it
> rw, and not run check --repair, until you get some feedback from a
> developer.
>

+1

> The thing I'd like to see is
> # btrfs rescue super -v /anydevice/
> # btrfs insp dump-s -f /anydevice/
>
> First command will tell us if all the supers are the same and valid
> across all devices. And the second one, hopefully it's pointed to a
> device with valid super, will tell us if there's a log root value
> other than 0. Both of those are read only commands.
>

It was my understanding that rescue writes to the disk (the man page
indicates it recovers superblocks which would imply writes). If you
are sure they both leave the on-disk data structures completely
intact, I would be willing to run them.

- mike
