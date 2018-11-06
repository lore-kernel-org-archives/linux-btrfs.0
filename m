Return-Path: <SRS0=BJi/=NR=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 963A3C32789
	for <linux-btrfs@archiver.kernel.org>; Tue,  6 Nov 2018 11:17:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5887320862
	for <linux-btrfs@archiver.kernel.org>; Tue,  6 Nov 2018 11:17:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hyejgGK+"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5887320862
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730349AbeKFUmI (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 6 Nov 2018 15:42:08 -0500
Received: from mail-lj1-f173.google.com ([209.85.208.173]:43904 "EHLO
        mail-lj1-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726976AbeKFUmH (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 6 Nov 2018 15:42:07 -0500
Received: by mail-lj1-f173.google.com with SMTP id g26-v6so11035132lja.10
        for <linux-btrfs@vger.kernel.org>; Tue, 06 Nov 2018 03:17:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=sewfAVa/8DORrpFL4IbagLOYN1Nm6hX1ctgoTQTY2SE=;
        b=hyejgGK+7MuT5eVKk+tXmn1knWflWNie+R7o6lgAGxuhEFB9+yJcEGDeWT7Avqdebl
         W1PcpI2tRHedI9EjHZ4jIDLMjxw0f/IveHofPEjKIKUGDEbs0zDqZX3XydPHTIoaOIT5
         nJ9XSY25R2/OxPnqQh6A1eqIR5CljCsRAe9xAKKekXejG+rFYXVKWXLoL+ugfcmsTakf
         NSJkJll6s7Q7mcAn7BB48IC5Dx+FspU+d9u+8ZN/nlhUfP8R8l/bYuXxPm7hU0ajaxV2
         It3h/cu7by31RrWhEhhR1So7pGHNOFwixstYsgD2AIyU89zGTRzr3uOTcoXd1JbSFK54
         +58A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=sewfAVa/8DORrpFL4IbagLOYN1Nm6hX1ctgoTQTY2SE=;
        b=IUwp7wVlNKEU023twVK+YVcC8+itUWY1Vr2BUkCOWo+/gUgyjFS3LUEaSqpzDCxBqu
         LxKh7yKqW32Og1+6hGnL/cguEhMTLxQfudTf0DKAYXXRFSJKYn+CR3QQZeaEsenLsmba
         KEqK9aozJghODiBQaeYla2Piaqu3FehbNILXIB3FHiFiHgx/0EThIP1g5u45lXAHLwyS
         TUZw/vvD4Q5OZa8uuHa0O08sTluHxP96V45qj1pvQMyBS5ch07B3S/Smq78YmvWpmkYv
         N92yjDvPzQq+8kfs5OLg/W5C/uNq+zjSWukXrJj4oTqEdVpVO6BDtc/qODGnoawDGPb+
         K5aA==
X-Gm-Message-State: AGRZ1gLovWtixpyK53FiEqVndc0JF/vKAsRoE+5tk3iK6mY+TV8xS5A/
        d+R3DzF2Ukju9PID+qwE8Qd1tmBEPZLhWrNa4aQ=
X-Google-Smtp-Source: AJdET5dxgeIZKqmRn+QY3zNGY2/dUAE88teX08Sg7kKeYnfFHvt03uRGANd0M6D2f1hIZkuaqUvhnk0tSpg/Uvjq3ks=
X-Received: by 2002:a2e:710a:: with SMTP id m10-v6mr13058505ljc.66.1541503043170;
 Tue, 06 Nov 2018 03:17:23 -0800 (PST)
MIME-Version: 1.0
References: <CAGSQd28H5RsVe-uzZRu2BYu9-nX+18n3JE=rQMhqM1H8krVMEA@mail.gmail.com>
 <CAGSQd2_va==dDduBg7iaTyo=oeH7a5jFTM+c1sZkipNZEeaWxA@mail.gmail.com>
 <1a569e29-d9f1-e86f-15cf-5a8b5e205103@gmx.com> <CAGSQd2-fUDpbBqN-0dAtLg=LBh7mDhHmxg59LGE6tXsRZJ-HAw@mail.gmail.com>
 <3740e1fd-9078-0655-3fdf-32d8faeafb12@gmx.com>
In-Reply-To: <3740e1fd-9078-0655-3fdf-32d8faeafb12@gmx.com>
From:   Attila Vangel <vangel.attila@gmail.com>
Date:   Tue, 6 Nov 2018 12:17:10 +0100
Message-ID: <CAGSQd29+36595zW85YHVn20cNcMi8X098q2PKO1f6DsWmwDv0Q@mail.gmail.com>
Subject: Re: btrfs partition is broken, cannot restore anything
To:     quwenruo.btrfs@gmx.com
Cc:     linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Hi Qu,

I created an issue for this feature request, so that it is not lost:
https://github.com/kdave/btrfs-progs/issues/153

Thanks for the help again! Now unsubscribing from this list.

Regards,
Attila

On Tue, Nov 6, 2018 at 9:23 AM Qu Wenruo <quwenruo.btrfs@gmx.com> wrote:
> On 2018/11/6 =E4=B8=8B=E5=8D=884:17, Attila Vangel wrote:
[snip]
> > So I propose that "btrs restore" should always print a summary line at
> > the end to make it more user friendly (e.g. for the first time users).
> > Something like this:
> >
> > x files restored in y directories[, total size of files is z <human
> > readable unit e.g. GB>]. Use -v command line option for more
> > information.
> >
> > The part in square bracket is optional / nice to have, might be useful
> > e.g. to estimate the required free space in the target filesystem.
>
> Nice idea. Maybe we could enhance btrfs-restore to that direction.
>
> Thanks,
> Qu
[snip]
