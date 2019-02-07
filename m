Return-Path: <SRS0=taZz=QO=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4257EC282C2
	for <linux-btrfs@archiver.kernel.org>; Thu,  7 Feb 2019 22:19:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F3B292070B
	for <linux-btrfs@archiver.kernel.org>; Thu,  7 Feb 2019 22:19:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=colorremedies-com.20150623.gappssmtp.com header.i=@colorremedies-com.20150623.gappssmtp.com header.b="M8b39609"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726728AbfBGWTQ (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 7 Feb 2019 17:19:16 -0500
Received: from mail-lj1-f181.google.com ([209.85.208.181]:34852 "EHLO
        mail-lj1-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726642AbfBGWTP (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 7 Feb 2019 17:19:15 -0500
Received: by mail-lj1-f181.google.com with SMTP id j13-v6so1317142ljc.2
        for <linux-btrfs@vger.kernel.org>; Thu, 07 Feb 2019 14:19:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=colorremedies-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=B22F05B7lnNsxf5SBxEtCCkjWNRg449qLmvx+Px/EAQ=;
        b=M8b39609Ezbvdouzgog0WesJMmhYXrdj23e+3ZybFo4wtTOJY0vVhBtA+BLwt9GA7S
         YwPg51+/DaNTfr70LJkuPP1A7HbZ1ekLh4sjUBA8WGpWOR8yl8zDNjj97ZpcTme9md85
         b4zr9uuNmgdUGRJdcDryFJrEzHxRuW9fXb/iDIk+u38wY/dRlppcXraEm4EG25QAhguG
         MGoFKXg+JIVeRcUEaKKy2FfqEObvzW5RUS1eLszw5YE7JRUeRIzdeuM7vkdjq0xcyeQH
         /j3M759DrBtkHv6xEpraDXlAJV4G/VdGXHbCzXrR9q7j+nKDy1iUV1ftxWO1K6dOmpZh
         yLig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=B22F05B7lnNsxf5SBxEtCCkjWNRg449qLmvx+Px/EAQ=;
        b=Bz7dtUbO19w+VE24c1lnlkClU+89LYqPCvlVt1dWjWboAY26Q4ibyk13mt1cEp5VUz
         nFD+1X3EzTRjlCHVrdt9aIddaTgTboouX+gapAcrrwlp9OLXYzYT6iUYyCfdSwcE40BR
         FyXpG3IYlRyBRYBZbYIiyROKkKPEgeJ8c//PlWjRZrCi1emWq7IjkcubLMbR4no6299k
         9fRdQPWODRREoupepbvbPRvYFhTBWqJnmY+JLqvD2cGCaiU7YRF6Ki35HE+ajAD/0B/t
         ycmDqflGG5gyFx4MH5KmacYoC/eh0p6Y7poHA+pvO7IwQr+H1QDDPh17kf71xwKqE3K9
         MCHw==
X-Gm-Message-State: AHQUAuYBeKtSJGCwYCoRidNK+c+XeqeytZ6nY2oSGz5lGJfwGvVNQVe9
        5B0H14f6bJ4UPSG07rUG4g93tedGMKYsUhLQZi4ASA==
X-Google-Smtp-Source: AHgI3IZwl6zhpBXeb3gB+QeNNSZkBZWS1Lu/4O5a63K46LhxlC9hopvI2avxAcBSU4kZZIl7S5oe2rI4OfLtEjHL8XU=
X-Received: by 2002:a2e:7d04:: with SMTP id y4-v6mr6890593ljc.127.1549577953351;
 Thu, 07 Feb 2019 14:19:13 -0800 (PST)
MIME-Version: 1.0
References: <33679024.u47WPbL97D@t460-skr> <2159107.RxXdQBBoNF@t460-skr>
 <CAJCQCtRuUBfhXQGr29hmOU1mW1wU2jSvr+dun72NAw3O28=cyA@mail.gmail.com> <2840929.O1qc6pvfHa@merkaba>
In-Reply-To: <2840929.O1qc6pvfHa@merkaba>
From:   Chris Murphy <lists@colorremedies.com>
Date:   Thu, 7 Feb 2019 15:19:01 -0700
Message-ID: <CAJCQCtR0RzjMPnTLP8V1mmKWGv2A+uYhe+FE4vmUB2odZki+OA@mail.gmail.com>
Subject: Re: btrfs as / filesystem in RAID1
To:     Martin Steigerwald <martin@lichtvoll.de>
Cc:     Chris Murphy <lists@colorremedies.com>,
        Stefan K <shadow_7@gmx.net>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Thu, Feb 7, 2019 at 10:37 AM Martin Steigerwald <martin@lichtvoll.de> wr=
ote:
>
> Chris Murphy - 07.02.19, 18:15:
> > > So please change the normal behavior
> >
> > In the case of no device loss, but device delay, with 'degraded' set
> > in fstab you risk a non-deterministic degraded mount. And there is no
> > automatic balance (sync) after recovering from a degraded mount. And
> > as far as I know there's no automatic transition from degraded to
> > normal operation upon later discovery of a previously missing device.
> > It's just begging for data loss. That's why it's not the default.
> > That's why it's not recommended.
>
> Still the current behavior is not really user-friendly. And does not
> meet expectations that users usually have about how RAID 1 works. I know
> BTRFS RAID 1 is no RAID 1, although it is called like this.

I mentioned the user experience is not good, in both my Feb 2 and Feb
5 responses, compared to mdadm and lvm raid1 in the same situation.

However the raid1 term only describes replication. It doesn't describe
any policy. And whether to fail to mount or mount degraded by default,
is a policy. Whether and how to transition from degraded to normal
operation when a formerly missing device reappears, is a policy. And
whether, and how, and when to rebuild data after resuming normal
operation is a policy. A big part of why these policies are MIA is
because they require features that just don't exist yet. And perhaps
don't even belong in btrfs kernel code or user space tools; but rather
a system service or daemon that manages such policies. However, none
of that means Btrfs raid1 is not raid1. There's a wrong assumption
being made about policies and features in mdadm and LVM, that they are
somehow attached to the definition of raid1, but they aren't.


> I also somewhat get that with the current state of BTRFS the current
> behavior of not allowing a degraded mount may be better=E2=80=A6 however=
=E2=80=A6 I see
> clearly room for improvement here. And there very likely will be
> discussions like this on this list=E2=80=A6 until BTRFS acts in a more us=
er
> friendly way here.

And it's completely appropriate if someone wants to  update the Btrfs
status page to make more clear what features/behaviors/policies apply
to Btrfs raid of all types, or to have a page that summarizes their
differences among mdadm and/or LVM raid levels, so users can better
assess their risk taking, and choose the best Linux storage technology
for their use case.

But at least developers know this is the case.

And actually, you could mitigate some decent amount of Btrfs missing
features with server monitoring tools; including parsing kernel
messages. Because right now you aren't even informed of read or write
errors, device or csums mismatches or fixups, unless you're checking
kernel messages. Where mdadm has the option for emailing notifications
to an admin for such things, and lvm has a monitor that I guess does
something I haven't used it. Literally Btrfs will only complain about
failed writes that would cause immediate ejection of the device by md.



--=20
Chris Murphy
