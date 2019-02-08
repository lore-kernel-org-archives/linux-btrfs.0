Return-Path: <SRS0=hLti=QP=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7BF97C169C4
	for <linux-btrfs@archiver.kernel.org>; Fri,  8 Feb 2019 20:17:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4A3D72177B
	for <linux-btrfs@archiver.kernel.org>; Fri,  8 Feb 2019 20:17:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=colorremedies-com.20150623.gappssmtp.com header.i=@colorremedies-com.20150623.gappssmtp.com header.b="E4A5T4fw"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727318AbfBHURj (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 8 Feb 2019 15:17:39 -0500
Received: from mail-lj1-f180.google.com ([209.85.208.180]:38769 "EHLO
        mail-lj1-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727116AbfBHURj (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 8 Feb 2019 15:17:39 -0500
Received: by mail-lj1-f180.google.com with SMTP id c19-v6so4066726lja.5
        for <linux-btrfs@vger.kernel.org>; Fri, 08 Feb 2019 12:17:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=colorremedies-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=XqIVEN8e5AExCTBfpPXp7UPGbiKxm6oALQpwInS9NJQ=;
        b=E4A5T4fwDqMIQg6zMWPAH0YOoysJG7cB6+uENCPuNySRNhEFWrNAeHsu7CvuS6IDHD
         18am2hvXbYVt2XruRSvMf3g3CCMCh6RRG/PU0/Jp1dkyNrktHbCF3EG3uEnXObilc7ZI
         okskkbLscYfHExHTRcyRw0gZwExJrn0/33I4pIs5h/EeRH/kNFFWda2noba62NR9glu/
         QaUug/qxYgCO+a+QgzVkhHmLkQchI0wtEzk9g07w+wLau9QaE7JcKUbpgKiNnW/ESF+h
         dnRsMjutRZklNVkW+9j0msC73dwVvYq8Vxlz1bF6yiSIPjETHOr3UaTaNNMJcXrf91SJ
         UcUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=XqIVEN8e5AExCTBfpPXp7UPGbiKxm6oALQpwInS9NJQ=;
        b=rUZlQmyfeZqcA2ViB9zT0D0OuE+Tid5K0O0Ao5V1ypTikE0qBygWPXBPazUIxja0Kq
         AI4KCyYLPCnf3vsM4aDsLJkwPc2erF/mn8T7xy6bUtia2C80/oQht01TtH3W+Z7wDkHX
         QrMwxcUHL5gMosoxoJPX8KGmfrc9bXkQ+/EWBiyYBmIrEt0uuj9oCtlt80PoD6zUb6rQ
         VSr6n0lLANCuEA6UK+CxWIk9RhqMVHWhglvBJ/AWbgZU22C0CJh2vn4sR4UA5Iu39dWt
         tK1kwyMSS0Ty0KtlspZW11JPAJAdCWyd6ig1CYB2hgxgPr7quLZBJF94hjFEiQdg2rPk
         iEOA==
X-Gm-Message-State: AHQUAuZQPKwf+EnYD2Lih/CzLvEIIcfzngc7hPCKOJlBvCpSHJ24yLau
        5udjbYoEwC4xfPYqZF66giPcSXI3kyPPS1fYdcVgaQ==
X-Google-Smtp-Source: AHgI3IbQ3BNBeVIPU/zpF1w/ws7G4B8sxV8WTlp0nHiqrEVPbGYEHQ/mMpOOeFyt73v6VCtPVV2P97SOIiy1wig5bvI=
X-Received: by 2002:a2e:4dc:: with SMTP id a89-v6mr12027813ljf.71.1549657056520;
 Fri, 08 Feb 2019 12:17:36 -0800 (PST)
MIME-Version: 1.0
References: <33679024.u47WPbL97D@t460-skr> <92ae78af-1e43-319d-29ce-f8a04a08f7c5@mendix.com>
 <2159107.RxXdQBBoNF@t460-skr> <b08e9876-3493-1a14-5152-e2fa0a2c24a3@gmail.com>
 <f4f899e3-0d1b-2f82-54cd-3552e186db6a@dirtcellar.net> <c8708ebd-c6c2-6916-6da2-5b415c0585e4@gmail.com>
 <c7ef67c6-a38b-a632-fc5d-b839940c2877@dirtcellar.net>
In-Reply-To: <c7ef67c6-a38b-a632-fc5d-b839940c2877@dirtcellar.net>
From:   Chris Murphy <lists@colorremedies.com>
Date:   Fri, 8 Feb 2019 13:17:24 -0700
Message-ID: <CAJCQCtR+jS2iuKpjDbJYPAcFWYCfaYGzgewWqwR=q742aKf56A@mail.gmail.com>
Subject: Re: btrfs as / filesystem in RAID1
To:     waxhead <waxhead@dirtcellar.net>
Cc:     "Austin S. Hemmelgarn" <ahferroin7@gmail.com>,
        Stefan K <shadow_7@gmx.net>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Fri, Feb 8, 2019 at 11:10 AM waxhead <waxhead@dirtcellar.net> wrote:

> So what you are saying here is that distro's that use btrfs by default
> should be responsible enough to make some monitoring solution if they
> allow non-technical users to create a "raid"1 like btrfs filesystem in
> the first place.

None do this by default. I'm only aware of one that makes it possible
in custom partitioning which is widely regarded as "you're on your
own" land.

I am of the opinion that GUI installers have a high burden to protect
users from themselves but it's just an opinion; I see plenty of fail
danger GUI software.


> So why do BTRFS hurry to mount itself even if devices are missing?

It isn't and it doesn't. You have to specify 'degraded' mount option,
which is not the default, which right now with the present design
means you intend for an immediate successful mount if there's a
missing device and it's still possible to mount anyway.

>and
> if BTRFS still can mount , why whould it blindly accept a non-existing
> disk to take part of the pool?!

I can't parse this question. I think the answer is, it doesn't do that.


> > Realistically, we can only safely recover from divergence correctly if
> > we can prove that all devices are true prior states of the current
> > highest generation, which is not currently possible to do reliably
> > because of how BTRFS operates.
> >
> So what you are saying is that the generation number does not represent
> a true frozen state of the filesystem at that point?

You have a two device raid1, and their generation is 100. You mount
one device by itself with degraded mount option. And you start adding
and deleting files, no snapshots, and those changes are all under
generation 101. You now unmount it, and you degraded mount the other
device, and you add and delete some different files, and those changes
are all under generation 101 too.

How do you merge them? I personally think that scarnio is user
sabotage and they're just screwed. Start over. They had to
intentionally, manually, mount those two drives *separately* with a
non-default 'degraded' flag. It's crazy to expect Btrfs to sort this
out - but it's entirely reasonable for it to faceplant read only the
instant it becomes confused; and reasonable to expect and design it to
quickly become confused in such a case, to keep damage from making
both separated mirrors so corrupted they can't be mounted even read
only.


> Why does systemd concern itself about what devices btrfs consist of.
> Please educate me, I am curious.

I'm not sure of the history of:
/usr/lib/udev/rules.d/64-btrfs-dm.rules
/usr/lib/udev/rules.d/64-btrfs.rules

But I think they were submitted to udev by Btrfs developers long ago,
which was then later subsumed into systemd. It would be ideal if this
rule had time sort of timeout, I think instead it will indefinitely
wait for all devices to appear. Anyway, without that rule, if a device
is merely delayed, and systemd tries to mount, mount immediately fails
and thus boot fails. There is no such thing in systemd as reattempting
to mount after a mount failure, and if sysroot fails to mount, it's a
fatal startup error.

> I would also like for BTRFS to be over-aggressively safe, but I also
> want it to be over-aggressively always running or even limping if that
> is what it needs to do.

While I understand that's a metaphor, someone limping along is not a
stable situation. They are more likely to trip and fall.


-- 
Chris Murphy
