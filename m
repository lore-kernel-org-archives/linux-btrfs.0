Return-Path: <SRS0=C6pa=QJ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D88BDC282D7
	for <linux-btrfs@archiver.kernel.org>; Sat,  2 Feb 2019 23:53:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8B30B2073D
	for <linux-btrfs@archiver.kernel.org>; Sat,  2 Feb 2019 23:53:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=colorremedies-com.20150623.gappssmtp.com header.i=@colorremedies-com.20150623.gappssmtp.com header.b="RWWkFRnl"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726945AbfBBXfQ (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sat, 2 Feb 2019 18:35:16 -0500
Received: from mail-lj1-f176.google.com ([209.85.208.176]:45658 "EHLO
        mail-lj1-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726825AbfBBXfQ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Sat, 2 Feb 2019 18:35:16 -0500
Received: by mail-lj1-f176.google.com with SMTP id s5-v6so8745177ljd.12
        for <linux-btrfs@vger.kernel.org>; Sat, 02 Feb 2019 15:35:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=colorremedies-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=w2zbStUlX2+gX3kzfyqxIED4obaDm16d1x1FE20ls7Q=;
        b=RWWkFRnlozEY8PjwjNzsr/KjjheRG8j84sQ88RazyoQPlbpSO1yUsW57M6cMnH9vpj
         HNXgps+Tk5fq7KNoigNOaU9SxOzS08DiuPGBaE6OB7XzANUQNXUttjxmBX9IA20syzs4
         sHCN5pM6syDW+q1cDd5ih7hZyG9I61zlfVzpa/fhW6ModnSzBx2haQrLHA0McK51p6zG
         3XYdtzRSnqC0Gu5yyCUGIPiyrizL9kJAWghwAn1e1nCOy78o95OqByMpq136oZsyVfTF
         NCBXL/WQ99xPuy8sE/1SJqdDLVq/NvBTmPQzYwkpiA7IDMsQI4BwZAFf4J6TaoLPO6k3
         p3Hw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=w2zbStUlX2+gX3kzfyqxIED4obaDm16d1x1FE20ls7Q=;
        b=m9ZXVOhSjr0l+wDetK29KoVwi+2vxu3udVrNHN+/tj7hWyermEPQluWhcjr7Qcgzsz
         jIorNqwTCwxykYH6Qj/7wZd+Z+jc+cjzImX4I4/6ZV8afUwchX21ocJzG/JxgtY2j7+U
         Gq999zEvmcaIrZvrcSVPjacMvPLA3qYjlXDtS+wIt0VGynMuzlbOx7CezoqiMqVUEmNl
         LGeO8rLKgxRCQR8D3N/38XJZutNlxXb4R9S45TcKaL00ExJ4lY0m/7j1mCHLJW3iuDzG
         EoYcHILo8vzkaHQV7fhUEcEssCXBeLe/7HujYGJo73UgvcYS2c2/BNqcMrGbQTtKc/4r
         ZIBA==
X-Gm-Message-State: AHQUAuYNFe5UJvgWhlqlLr/0TnJUdDcU5Wuz/Nkzf4419/1tkGE0UBTx
        zBgKGzxlnPod2nhSDoZdY5+rWxkP0Nt0leyhxql32A==
X-Google-Smtp-Source: AHgI3IZ3hT+V7ceXdYNO78Af0Z6NP6SqGHnK6/ZJL2NdMUJxsImYiPaiXdAKRNMP2n3YPmf68aJNgn6+0UA3ORriMyU=
X-Received: by 2002:a2e:a289:: with SMTP id k9-v6mr10484012lja.24.1549150514513;
 Sat, 02 Feb 2019 15:35:14 -0800 (PST)
MIME-Version: 1.0
References: <33679024.u47WPbL97D@t460-skr>
In-Reply-To: <33679024.u47WPbL97D@t460-skr>
From:   Chris Murphy <lists@colorremedies.com>
Date:   Sat, 2 Feb 2019 16:35:01 -0700
Message-ID: <CAJCQCtR=WZGk4eaG63_-uqb0wzGVDDrS1SsxhzxT7k3qbWVtCg@mail.gmail.com>
Subject: Re: btrfs as / filesystem in RAID1
To:     Stefan K <shadow_7@gmx.net>
Cc:     Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Fri, Feb 1, 2019 at 3:28 AM Stefan K <shadow_7@gmx.net> wrote:
>
> Hello,
>
> I've installed my Debian Stretch to have / on btrfs with raid1 on 2 SSDs.=
 Today I want test if it works, it works fine until the server is running a=
nd the SSD get broken and I can change this, but it looks like that it does=
 not work if the SSD fails until restart. I got the error, that one of the =
Disks can't be read and I got a initramfs prompt, I expected that it still =
runs like mdraid and said something is missing.
>
> My question is, is it possible to configure btrfs/fstab/grub that it stil=
l boot? (that is what I expected from a RAID1)

It's not reliable for unattended use. There are two issues:
1. /usr/lib/udev/rules.d/64-btrfs.rules means mount won't even be
attempted if all Btrfs devices are not found.
2. Degraded mounts don't happen automatically or by default; instead
mount fails.

It might seem like you can have a grub boot param 'rootflags=3Ddegraded'
set all the time. While it's ignored if all devices are found at mount
time, the problem is if one device is just delayed, you get an
undesirable degraded mount. Three additional problems come from
degraded mounts:

1. At least with raid1/10, a particular device can only be mounted
rw,degraded one time and from then on it fails, and can only be ro
mounted. There are patches for this but I don't think they've been
merged still.
2. There is no automatic "catch up" repair once the old device
returns. md and lvm raid will do a partial sync based on the
write-intent bitmap, so it doesn't have to do a full sync. Btrfs
should have all available information to see how far behind a mirror
device (more correctly it's a stripe of a mirror chunk) and to do a
catch up so the mirrors are all the same again; however there's no
mechanism do do a partial scrub, nor to do a scrub of any kind
automatically. It takes manual intervention to make them the same
again. This affects raid 1/10/5/6.
3. At least raid1/10, if more than one device of a mirrored volume is
mounted rw degraded - it's hosed. If you have a two device raid1, with
device A and B; if A is mounted rw degraded and then later B is
(separately) mounted rw degraded, they each have different states than
the other, and those states are equally valid, and there's no way to
merge them. Further, I'm pretty sure Btrfs still has no check for
this, and will corrupt itself if you mount the volume rw (with all
devices present, i.e. not degraded). I think there are patches for
this (?) but in any case I don't think they've been merged either.

So the bottom line is that the sysadmin has to handhold a Btrfs raid1.
It really can't be used for unattended access.


--=20
Chris Murphy
