Return-Path: <SRS0=qFN0=RR=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_PASS,URIBL_SBL,URIBL_SBL_A autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A503DC43381
	for <linux-btrfs@archiver.kernel.org>; Thu, 14 Mar 2019 21:32:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6056220854
	for <linux-btrfs@archiver.kernel.org>; Thu, 14 Mar 2019 21:32:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=colorremedies-com.20150623.gappssmtp.com header.i=@colorremedies-com.20150623.gappssmtp.com header.b="AZOss1yC"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727204AbfCNVcE (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 14 Mar 2019 17:32:04 -0400
Received: from mail-lf1-f68.google.com ([209.85.167.68]:44370 "EHLO
        mail-lf1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726399AbfCNVcD (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 14 Mar 2019 17:32:03 -0400
Received: by mail-lf1-f68.google.com with SMTP id u9so5302327lfe.11
        for <linux-btrfs@vger.kernel.org>; Thu, 14 Mar 2019 14:32:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=colorremedies-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=rYOfqluvXUmFoZT6NUJPqprqJ/USM2ilrfOw+D8FA/g=;
        b=AZOss1yC7EGiZI8Jc6+tkQETRBLXE/VsRlG8gvnsdy1mRRz04Pw+rZEaJQT6Cb1eiD
         KjtTmQPRx4gXBvYlGFgAQrHX/BjkrE8vmMIp3se3OJCigbiGzKTg/Z7aoWwJJo0ydKC4
         GGT8rIvlDpOkGdKx/QI1Kzh9xFtJZnl3J+nMaVYJIBuOUpNbJyOE5wNX5MWKdEyLV1Jr
         1NvpD8CfGGdNfW7bpC78yDmTHVLemdAGkbL4i1RCWY/35ppEBXyZwNuw3ztm44d6jCKh
         own3iaXqlbOi/qfwTb9E9LezrBZXpdJgJBbI6QNpS3netPN1gXn2cP9LSDPPo/ySJqEs
         jsAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=rYOfqluvXUmFoZT6NUJPqprqJ/USM2ilrfOw+D8FA/g=;
        b=jJsxI32OV4/xEAAcCIicY794cKORbAb7sPPCFJ79e4JdCzGdxuDsygH9TsUbec6bD7
         YqbTYCypb/dpFvxRz5D1LEBUjADPdyw5Br0XZOh96IsxHHLSUp66fbC86CWnagmbF567
         Li7OZrP1o+CjpnX6hzRTTM3qxX46Q24hpMrNPSF0u8ffO8mHsPbCqIfgOEzZ++3t2ZcU
         cerie/rE3D9/tcVitdzxQE9Wr6dWTgxCcYxj1AgzzkXcuCP+X8OWwOVjqsRsuO5Zbd7p
         xwHWRVB5gOtaMZyPLHgIxZWZyK3KbP7cG+Xw0VGF+uIh/gxb9/l2jA7EmpRQvSwxRJ3z
         8pjg==
X-Gm-Message-State: APjAAAXk8bzmiH85u65YJrXNPIZX19v1I/0POhavaTEZ4bRytgAFq774
        ruFp6ykFMcCVN1U/tW2ogXPZ37rVk8If4YyQFxVcwJZvQd0=
X-Google-Smtp-Source: APXvYqzK2kSuVRLKMPZk7Lfd84IuxduFNUw0olVr5LlQebS/TwknWc/E27MdQjttmcz+KscuetxA4+bY/LSB6081FNU=
X-Received: by 2002:a19:ab1a:: with SMTP id u26mr184185lfe.65.1552599121173;
 Thu, 14 Mar 2019 14:32:01 -0700 (PDT)
MIME-Version: 1.0
References: <d5061586-2395-3c92-d7c5-2691307a0fce@husak.pro>
In-Reply-To: <d5061586-2395-3c92-d7c5-2691307a0fce@husak.pro>
From:   Chris Murphy <lists@colorremedies.com>
Date:   Thu, 14 Mar 2019 15:31:49 -0600
Message-ID: <CAJCQCtQpF6OFZu21bi-BositR+cMrUU1w8Ljd4GeM_hB2SBsjA@mail.gmail.com>
Subject: Re: Balancing raid5 after adding another disk does not move/use any
 data on it
To:     =?UTF-8?B?SmFrdWIgSHVzw6Fr?= <jakub@husak.pro>
Cc:     Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Wed, Mar 13, 2019 at 3:58 PM Jakub Hus=C3=A1k <jakub@husak.pro> wrote:
>
> Hi,
>
> I added another disk to my 3-disk raid5 and ran a balance command.

What exact commands did you use for the two operations?

>After
> few hours I looked to output of `fi usage` to see that no data are being
> used on the new disk. I got the same result even when balancing my raid5
> data or metadata.
>
> Next I tried to convert my raid5 metadata to raid1 (a good idea anyway)
> and the new disk started to fill immediately (even though it received
> the whole amount of metadata with replicas being spread among the other
> drives, instead of being really "balanced". I know why this happened, I
> don't like it but I can live with it, let's not go off topic here :)).

They could be related problems. Unclear.

I suggest grabbing btrfs-debugfs from upstream btrfs-progs and run
`sudo btrfs-debugfs -b /mntpoint/` and let's see what the block group
distribution looks like.

https://github.com/kdave/btrfs-progs/blob/master/btrfs-debugfs

>
> I'm now running `fi balance -dusage=3D10` (and rising the usage limit). I
> can see that the unallocated space is rising as it's freeing the little
> used chunks but still no data are being stored on the new disk.
>
> I it some bug?

It's possible, but not enough information. The balance code is complicated.


> If so, shouldn't it be really balancing (spreading) the data among all
> the drives to use all the IOPS capacity, even when the raid5 redundancy
> constraint is currently satisfied?

I'd expect that it should copy extents from old 3 strip block groups
to new 4 strip block groups. However, there have been some
improvements related to block group management and enospc avoidance
where existing block groups get filled first, before new block groups
are created, and I wonder if that's what's going on here, but it's
speculation. What do you get for


btrfs insp dump-t -t 5 /dev/   ##device, not mountpoint, will work if
fs is mounted but ideally not in-use
btrfs insp dump-s -f /dev/  ##same

Also, no significant changes in raid56.c between 4.19.16 and 5.0.2.
But there have been some volume.c changes.
https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/diff/fs/bt=
rfs/volumes.c?id=3Dv5.0.2&id2=3Dv4.19.16

Anyway, I would stop making changes for now and make sure your backups
are up to date as a top priority. And then it's safer to poke this
with a stick and see what's going on and how to get it to cooperate.

--=20
Chris Murphy
