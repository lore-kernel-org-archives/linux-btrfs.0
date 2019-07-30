Return-Path: <SRS0=c8Io=V3=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B7978C433FF
	for <linux-btrfs@archiver.kernel.org>; Tue, 30 Jul 2019 08:03:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8BC7320882
	for <linux-btrfs@archiver.kernel.org>; Tue, 30 Jul 2019 08:03:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Sk2ByhHb"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730780AbfG3IDO (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 30 Jul 2019 04:03:14 -0400
Received: from mail-oi1-f194.google.com ([209.85.167.194]:36522 "EHLO
        mail-oi1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729810AbfG3IDO (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 30 Jul 2019 04:03:14 -0400
Received: by mail-oi1-f194.google.com with SMTP id q4so18095275oij.3
        for <linux-btrfs@vger.kernel.org>; Tue, 30 Jul 2019 01:03:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=imSedO+dXsuu9Wc44hnYPbpIoMr3qD2NYxlc7VESMmI=;
        b=Sk2ByhHb1cOHldpuuLzH0gTcEz1phpZzO6Ae3nYCJXFRPDoL036K8htlUemQuMpu0S
         KMWD8iM/88cBdyJLBoSoXlfeMi3I9XTGMSOK9ORntlreT0sg8/WRNCmV7pUNHBSY2mHj
         jOjXlWUOVfWM0bZPO0eznbWzZsc+ucx3tdlPybbvjUlzaqYj2WwsxD6awGQ49niVeEvs
         fVNTsrQp6cGvKuxYBntkU7/yoDxhUzRAkzV+G3S2JWbTCagLi4tAep6CIhdzx4CWVJ78
         7CREcbkEiC+6YC7vzpvrTApiuGPr1cWLkbIv+alLer2489rwl/VGdIEf4cP3tuj5qs/x
         Mibw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=imSedO+dXsuu9Wc44hnYPbpIoMr3qD2NYxlc7VESMmI=;
        b=RMBeN9Bu/kXCKgBTUvfYIuiq6t+LOnfx46VFS/j1lW5+XwAcqrFQbZxX58tAhONmeM
         6ZvQjPuQbnVGZD+rYNVju1X2xlnIBwCY026Zp4mqbfndCPcCvmWAPgVeW88wHz8RoqhW
         bJ7jOcF/J1uhiJxnZgJNP4moKew1scR4JS1q/UEDG0f3mLP4NzYgV6Arl/shayYeVxUK
         yQTaH+WxlcOJzfmbwM1+91rfRpoE8ps4JEQfZ2ocq/XsSNl1bnaI0/4LQDUjewFYAfBw
         U85h7qFyg4ybVz/IzoSUUkBJlGVvs0CET25Rb/QqcacNyd/Op/HhFifdeVFG1x2Dbg12
         SPLA==
X-Gm-Message-State: APjAAAV6Cj1q1al0hn71II3oBrxx9yE82e0dHLyreZ/TvTetYplI69QS
        7UOly67Y30pFBugI+Rdd7fZ7y3fcruxaYEVweIi9ODnV
X-Google-Smtp-Source: APXvYqx36NAIjWzp9k0GCvh1SpykvSpjCoNyJR/4Z4HXndwjL7XwCv4EveUeYAnoKOeM9jeU3SCoyHuuzrAcm0xFFBU=
X-Received: by 2002:a05:6808:3d5:: with SMTP id o21mr42741792oie.108.1564473793404;
 Tue, 30 Jul 2019 01:03:13 -0700 (PDT)
MIME-Version: 1.0
References: <bcb1a04b-f0b0-7699-92af-501e774de41a@petaramesh.org>
 <f8b08aec-2c43-9545-906e-7e41953d9ed4@bouton.name> <09817d56-e037-8403-fb3b-9f3121bc8cdb@petaramesh.org>
In-Reply-To: <09817d56-e037-8403-fb3b-9f3121bc8cdb@petaramesh.org>
From:   Henk Slager <eye1tm@gmail.com>
Date:   Tue, 30 Jul 2019 10:04:02 +0200
Message-ID: <CAPmG0jYew8zBEYW=HWRrEQGZfsox4gq9ATt4iYHcn4voGwfEdQ@mail.gmail.com>
Subject: Re: Massive filesystem corruption since kernel 5.2 (ARCH)
To:     =?UTF-8?Q?Sw=C3=A2mi_Petaramesh?= <swami@petaramesh.org>
Cc:     linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Mon, Jul 29, 2019 at 4:17 PM Sw=C3=A2mi Petaramesh <swami@petaramesh.org=
> wrote:
>
> On 7/29/19 3:29 PM, Lionel Bouton wrote:
> > For another reference point, my personal laptop reports 17 days of
> > uptime on 5.2.0-arch2-1-ARCH.
> > I use BTRFS both over LUKS over LVM and directly over LVM. The system
> > is suspended during the night and running otherwise (probably more
> > than 16 hours a day).
> >
> > I don't have any problem so far. I'll reboot right away and reply to
> > this message (if you see it and not a reply shortly after, there might
> > be a bug affecting me too).
> >
> Well I had upgraded 3 machines to 5.2 (One Arch and 2 Manjaros).
>
> The Arch broke 2 BTRFS filesystems residing on 2 different disks that
> had been perfectly reliable ever before.
>
> The 2 Manjaros did not exhibit trouble so far but I use these 2 very
> little and I preferred to revert back to 5.1 in a hurry before I break
> my backup machines as badly as my main machine :-/
>
> My Arch first broke its BTRFS main FS and I told myself it was years
> old, so maybe some old corruption undetected by scrub so far...
Maybe you could zoom-in a bit more on the kernel (and btrfs-progs) binary.
Does Arch do any changes to the kernel.org version 5.2.0 ?
And what configuration is used?
Or did you create/compile things by yourself?
What compiler version is used?
