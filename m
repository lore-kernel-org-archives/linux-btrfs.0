Return-Path: <SRS0=hUT/=SD=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0ECA7C4360F
	for <linux-btrfs@archiver.kernel.org>; Mon,  1 Apr 2019 18:10:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C4FF12070D
	for <linux-btrfs@archiver.kernel.org>; Mon,  1 Apr 2019 18:10:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=colorremedies-com.20150623.gappssmtp.com header.i=@colorremedies-com.20150623.gappssmtp.com header.b="LT0WYCoa"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729266AbfDARIe (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 1 Apr 2019 13:08:34 -0400
Received: from mail-lj1-f194.google.com ([209.85.208.194]:36688 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729638AbfDARId (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 1 Apr 2019 13:08:33 -0400
Received: by mail-lj1-f194.google.com with SMTP id r24so8916008ljg.3
        for <linux-btrfs@vger.kernel.org>; Mon, 01 Apr 2019 10:08:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=colorremedies-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=sMHa8kkKJSoEGHqSpxIHAfjp0hyRFKxeMxoQkXRrZCE=;
        b=LT0WYCoa/p2yP9cqAslm59gB9o3aQ0JANHFJZMJ86oPBFliWvcd7AdQaUPttYYQybi
         FhGfQleP3iWVgPokara5AML8w7r81tBkSCftEeKIfJF+Y3lKEHwW9zcCrpoNBVvhFtDv
         YLQb5ESvJWbO2pjYfquBY4uA91vmoltL1Y8Cg8HrxXvCtyKjTpsyUbyYXIwnc0twfEqN
         dHq7Xk8EZXxL8RBjY4xtQdFVQB4+j+wbBd1u5yMcxAQHkOF4aOi5YsUv/Rq3H+XdJcEo
         12H0oVa4uCy+UtB2Da1KZbn7BEurhUZ4/p5NnRhMZ+1tUD4WeV++KSxlJ4gSbSu883k4
         NIfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=sMHa8kkKJSoEGHqSpxIHAfjp0hyRFKxeMxoQkXRrZCE=;
        b=CFabnzVNM3L3fhnI9L1lP4e8ll3EbsC9tE4uIRJubDnAGDfhf/PB9Z3y/Gx2k9HiM8
         +YIcG+dfoGUVkT/7cHPezWDFx2MJixVb2QmLNrsDa1MD3p4RzUXEsp2VuCOIXkyY4372
         22ssRkHCBxtXlViKVHZPMyHDdv9kd4UL5y3qEOnbSpHpcnnWqvw6JeQclmCu8Hb4m/oy
         /Px+w4lnCmwQ3suvTXemeJzay51W9bx1r0hkBj6Fs7Bzux5ewZVo9uchgfXZyPde+WrB
         4JCgbBx4y1Cb/hlYQA9BEyYYJ2xQbVyZfGUCvSoZgOqiGp9QijFyqGt0B7+MifkICro3
         46UQ==
X-Gm-Message-State: APjAAAVuhZ/NEb7gop/Pu9MDY3NI+doSj7eG4NmKE8XvNF/QPyUTpPBj
        hCimURlrs3LXGS62bgHm6ohHbd4t9f9C0yTKOc7VfA==
X-Google-Smtp-Source: APXvYqz0MIDuzINTP/UouDm1nruPm7eGWhRVr5Y5w38NuQBd3THBW3QXU+xU0N5fT1fu5xaJ8Tm55XmzUDa1Kasm7T4=
X-Received: by 2002:a2e:380c:: with SMTP id f12mr34839433lja.116.1554138511604;
 Mon, 01 Apr 2019 10:08:31 -0700 (PDT)
MIME-Version: 1.0
References: <OBcqa2Fc0jqI9Dnn8nBkHh_ywiNByvFWAIUiQ9VSYP2TTQKacDXe-gmeqXmEeWg4JXwFN0abkfoVjdgfkkLj0-Z9SpinIg6uvM0ALCKkTY8=@protonmail.com>
 <T4L8uzfFCkKlUCEdxlfLO__xJm-Mgx7cNxaG9f0MoHLC1J4iotdvlcyBvErwcHGYPhaH5v6PgW7dNdoRnKKYcLpydgp1LAOCc0kWuZcva8k=@protonmail.com>
 <GTGCjkZs1S7dOu-dFVn7VvBHWYxNYKpZM1nK6cqBY-8aB6MhGmD5Kz8Ya46OpTWgK2UoZRfLJIAdfvQpD8l_rwgW1pSfHKXzjjnkr8COYss=@protonmail.com>
In-Reply-To: <GTGCjkZs1S7dOu-dFVn7VvBHWYxNYKpZM1nK6cqBY-8aB6MhGmD5Kz8Ya46OpTWgK2UoZRfLJIAdfvQpD8l_rwgW1pSfHKXzjjnkr8COYss=@protonmail.com>
From:   Chris Murphy <lists@colorremedies.com>
Date:   Mon, 1 Apr 2019 11:08:19 -0600
Message-ID: <CAJCQCtT8-M5w8-oFpUTk_YuSc6HD+j60QNaTt_eFkwb-QXxWVw@mail.gmail.com>
Subject: Re: volumes.c:1762: btrfs_chunk_readonly: BUG_ON `!ce` triggered,
 value 1
To:     berodual_xyz <berodual_xyz@protonmail.com>
Cc:     "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Mon, Apr 1, 2019 at 6:40 AM berodual_xyz <berodual_xyz@protonmail.com> wrote:
>
> Dear all,
>
> "btrfs rescue chunk-recover" also crashes. I wonder if having this crash fixed in the tools is preventing me from restoring the filesystem?

The crashing could in fact make the problem worse if it's also writing
any changes to disk that are interrupted by the crash. So yeah, until
the crasher is fixed, it's not going to improve the situation.

>Or maybe manually fixing the data corruption that causes this?

I don't understand the question. If you use --init-extent-tree it
almost immediately starts writing a new extent tree. And if that's
interrupted at all or does not otherwise succeed, the file system is
useless for anything else. You'd need to reimage your clones from
source.

Over on the linux-raid@ list, they do this, which I think also works
for LVM. It definitely doesn't work with Btrfs.
https://raid.wiki.kernel.org/index.php/Recovering_a_failed_software_RAID#Making_the_harddisks_read-only_using_an_overlay_file

The reason why is because the overlays and original block devices are
indistinguishable to Btrfs. And the user space tools have no way of
explicitly specifying the block device. You pick one device, and it
uses UUID to infer the rest of the members, and it's uncontrollable
which ones it'll pick. If you have a separate computer, you could
export only the rw overlays via iSCSI to another computer, and that
would likely work. The one thing I'd add to the overlay recipe, is
using `blockdev --setro` on all the original drives, just to make
certain they aren't written to.

It's more than a little frustrating we don't have non-destructive
repair on Btrfs. Btrfs has a full volume snapshot via the seed device
feature, so a future repair feature could just do that automatically
and write out the repair to another volume or to a file. And then that
repair attempt could be sanity checked just by mounting the sprout
device containing the repaired file system. Even if it's not a perfect
repair it might allow a read only mount, and permit normal extraction
methods. It would also be better for developers to always have access
to the before repair state, and after repair state. But right now
we've got numerous cases for a long time of `btrfs check --repair`
blowing up file systems worse than they were before the repair was
tried, and in the process the file system is so badly damaged it's not
even useful for user or developer.


-- 
Chris Murphy
