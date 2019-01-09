Return-Path: <SRS0=3FID=PR=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1D6CDC43387
	for <linux-btrfs@archiver.kernel.org>; Wed,  9 Jan 2019 13:33:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DCC0A206BB
	for <linux-btrfs@archiver.kernel.org>; Wed,  9 Jan 2019 13:33:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="TrZxOYiP"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730656AbfAINd2 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 9 Jan 2019 08:33:28 -0500
Received: from mail-yw1-f67.google.com ([209.85.161.67]:43638 "EHLO
        mail-yw1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727627AbfAINd2 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 9 Jan 2019 08:33:28 -0500
Received: by mail-yw1-f67.google.com with SMTP id n21so2932404ywd.10
        for <linux-btrfs@vger.kernel.org>; Wed, 09 Jan 2019 05:33:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=a7CMIVyldYhueGCHaKTTrEwcWW9ZlZTUeqZ5alTyTNg=;
        b=TrZxOYiP56cfYyHEGEAzF+Kg2GTqdnDYzecPkNMhVZO9CJmv5kSx0QShjtAxneuVGC
         +r/K0yaFkTZz4bVHF2fmIEQ15LZrmWb09igP9LVqr9dcOo7InV05FG/bRzQW1YWDaGoV
         ezYPw6rizYicLfRNwjDaVcyH//rZZ8MfX6XXfoinK+zA1d/57laJoCzkJrkiZgDAFstX
         xAWlF0QaChNDl49J1PTyX2kacCtOhLlfEwlOMYMv5wvIqlS354CMYx7pU4IuSKQejbZy
         f85CUeTN5yd9X4mhsSFb3OXNmBbABCIDZ1wW6wss27ury5FO2fBQ21OletU1WtVqL/Zi
         IKBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=a7CMIVyldYhueGCHaKTTrEwcWW9ZlZTUeqZ5alTyTNg=;
        b=jFgR2+lyjtQhd6x0nQ+qdjKItecuCozfH+rPgauZ8iU1EFYD+3blcMtnvN5ILYg30f
         x1y7+uKu6mUucNE2ObQIY+YF+fksSi8oN+sJuzqWz1Xfh0fsJtPnp8xoJuB5xa0GnL49
         m/7kw7e2ai/37U4N4X7b/Xu4uSUiBIa7j3d3EICK+y1S96pz8RHRbiuIZu81leRcFrc8
         WRoKnnpCnNJUmbqzrpoa5fG2s69OnJo3FJ2NiIteAlYNuwwyZgkTcQcuaAfafcx7+4i7
         bmKvodEIpPjPW1vPNXYAsZM8YXqpQsjtN+XFXCbMRz+GNL1FhsymWrJWO85dd/hpWur/
         BDbQ==
X-Gm-Message-State: AJcUukcqfpYvWNUeR7v6aKyAQmAYlj80DgZbG2K07Awy57Om9qyBfjyS
        4eVvMA+ii21LPm9VN8SmuxdSUcDDdUkAvG69Qt8=
X-Google-Smtp-Source: ALg8bN7lTOiD54sM/pL8g8UWfu9VWVUoN6lRbLayR42Khns5uosT7IxHWO5fVMQrK62dxvgQgmAkipJt2DM/4Y3IAJI=
X-Received: by 2002:a81:27d6:: with SMTP id n205mr5717537ywn.305.1547040807559;
 Wed, 09 Jan 2019 05:33:27 -0800 (PST)
MIME-Version: 1.0
References: <fcdfebdcb0e8d5fd291d08f844274212@virtall.com> <SYCPR01MB5086891E71B5CDBDED74CBD19E8B0@SYCPR01MB5086.ausprd01.prod.outlook.com>
In-Reply-To: <SYCPR01MB5086891E71B5CDBDED74CBD19E8B0@SYCPR01MB5086.ausprd01.prod.outlook.com>
From:   Eli V <eliventer@gmail.com>
Date:   Wed, 9 Jan 2019 08:33:16 -0500
Message-ID: <CAJtFHUQacQZCeiFvsDQu5BG+NVZWkqLXzDPkpNjAUk0XG1ix3A@mail.gmail.com>
Subject: Re: dedicated metadata drives?
To:     Paul Jones <paul@pauljones.id.au>
Cc:     Tomasz Chmielewski <tch@virtall.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Tue, Jan 8, 2019 at 9:43 PM Paul Jones <paul@pauljones.id.au> wrote:
>
> > -----Original Message-----
> > From: linux-btrfs-owner@vger.kernel.org <linux-btrfs-
> > owner@vger.kernel.org> On Behalf Of Tomasz Chmielewski
> > Sent: Saturday, 5 January 2019 12:25 AM
> > To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
> > Subject: dedicated metadata drives?
> >
> > According to btrfs wiki, some patches have been submitted to support
> > metadata on different devices than data (i.e. metadata on SSD, data on
> > HDD):
> >
> >
> > https://btrfs.wiki.kernel.org/index.php/Project_ideas#Dedicated_metadat=
a
> > _drives
> >
> >     Dedicated metadata drives
> >
> >     Not claimed =E2=80=94 submitted =E2=80=94 Not in kernel yet
> >
> >     We're able to split data and metadata IO very easily. Metadata tend=
s to be
> > dominated by seeks and for many applications it makes sense to put the
> > metadata onto faster SSDs.
> >
> >
> >
> >
> > This article (almost 2.5 years old) claims one company is already using=
 either
> > these patches or something similar:
> >
> > https://lwn.net/Articles/698090/
> >
> >     August 24, 2016
> >
> >     To combat that, he has a set of patches to automatically put the Bt=
rfs
> > metadata on SSDs. The block layer provides information on whether the
> > storage is rotational; for now, his patch assumes that if
> >     it is not rotational then it is fast. The patch has made a huge dif=
ference in
> > the latencies and requires less flash storage (e.g. 450GB for 40TB file=
system)
> > for Facebook's file workload that
> >     consists of a wide variety of file sizes.
> >
> >
> >
> > Do these patches exist anywhere? I couldn't find them in the list archi=
ve.
>
> I managed to find this suggestion about how it could be done:
> https://patchwork.kernel.org/patch/9556973/
>
> I would love to use this feature as well. My current setup uses btrfs on =
lvm with caching enabled, but I would prefer a simpler setup.
>
> Paul.

Another out of tree option are the patches from Timofey Titovets
"Btrfs: enhance raid1/10 balance heuristic"

https://lore.kernel.org/linux-btrfs/20180925183841.26936-1-nefelim4ag@gmail=
.com/

Then you'd put all your data drives in a single LVM volume, could be
MD raid or what not, and then your SSDs in another lvol. Make your
data single, and your metadata RAID1 and then the SSDs should be
preferentially used for metadata access. I haven't actually tried the
patches yet myself, but have a test system with the proper hardware
setup now running normal btrfs 4.9. Just not enough time in a day to
test everything. The SSD's do make a huge difference for metadata
heavy things like running compsize on an fs.
