Return-Path: <SRS0=1LDH=ON=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 32329C04EB8
	for <linux-btrfs@archiver.kernel.org>; Tue,  4 Dec 2018 19:38:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E206D20834
	for <linux-btrfs@archiver.kernel.org>; Tue,  4 Dec 2018 19:38:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=colorremedies-com.20150623.gappssmtp.com header.i=@colorremedies-com.20150623.gappssmtp.com header.b="BrOcFcI3"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E206D20834
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=colorremedies.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726073AbeLDTin (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 4 Dec 2018 14:38:43 -0500
Received: from mail-lj1-f178.google.com ([209.85.208.178]:38290 "EHLO
        mail-lj1-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725855AbeLDTin (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 4 Dec 2018 14:38:43 -0500
Received: by mail-lj1-f178.google.com with SMTP id c19-v6so16053367lja.5
        for <linux-btrfs@vger.kernel.org>; Tue, 04 Dec 2018 11:38:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=colorremedies-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to;
        bh=2l1lDQzhsOTqjPOVEKZkaBzUgL/n9hFhl/3q+XYJNmI=;
        b=BrOcFcI3+FQBDQI4BlOgg4ls5DXsiIE18C+nM4vWLtE1+LnCcUNOJVQlFu7GSXH3qJ
         Y1brueFth1uLucEXBfGXCrrIYSx+7LeYIQUihjh1/0e3oaRL7+GCATrfdlVpv641qgPb
         qKUr3vhg2l/5K/+lcrthhaO36kv+6Pxr3ALZSAn5RgRvrStjjoPfoiQhC36ErQ4LjL6u
         cg96QeulgBH8BrUoa2ohYK6iYsnNVqqw8hmqQ4hlA16pJuY3Y0lrKj6AhyGIZo+1tiFT
         XVJJfRe2P1Sf9XHf+PIFB/MfN09oiN7ZUL7EhvtWNYcQiZAKyy9eBPYVV88YglMJSZME
         gndQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to;
        bh=2l1lDQzhsOTqjPOVEKZkaBzUgL/n9hFhl/3q+XYJNmI=;
        b=h7vbcPHtJYyEE6P8YPcde3/aF9asX8AXnlQ7mewiBQ4eqF7XxxBVWUvF5TVWFfXPHg
         UiUfyD6mONg+US3C1uli6yGWIUNxtODqk8dtBQylNW5pba6CYgtrJyEJ21t2h3BnqEXb
         meiJ6xR5jnaehU/V8f6vkRNo66uQ7Tssw5/ioAAJpbRgsobd28r0DQLEo6+vjeB1+lUy
         eeokI0lG0nIYChvHPpRaEJrFe1dZseJDd8QBScFHslFBUljs2ONVAHuApWeQ80l6qCRR
         7KoXnGFiqWdiAYurqbonJGW2Vs8Nt3ZL0XO74p76c55o4ApBYvPJija25OIczACM9FZ/
         lFvg==
X-Gm-Message-State: AA+aEWa0UDJbByvya0cA3usDQdhO5LBYKMCbUgocrMaLDYjJjoCuqa2M
        g9S6n9XXVrGyHy9tvWkm2zymPfrX/feGhLxUrceH1qcj
X-Google-Smtp-Source: AFSGD/V/DmHezhD14nSULlddGD8vnk0WAK582k+IaVWUWCfGDCFkxTOQANz8mH2DY75LpZW30c1dIi6u9x6JwpQ+gC0=
X-Received: by 2002:a2e:880a:: with SMTP id x10-v6mr14927385ljh.174.1543952321234;
 Tue, 04 Dec 2018 11:38:41 -0800 (PST)
MIME-Version: 1.0
References: <8bc37755da04dffae1a34cea2a06bcffdf2c75d7.camel@duckstad.net>
 <6ce9cd01-960f-af3d-0273-0b9abfa1d4f8@gmx.com> <c723ab8e8e99e54c6f93dc70f897725525f0db29.camel@duckstad.net>
 <c24627dec9738552e1635617aace7720f395ba39.camel@duckstad.net>
 <2b235519-5c8d-9e86-b4f3-28cd7f778c4f@gmail.com> <7dac5577-2231-dcba-39fd-c229e4ed5e02@gmx.com>
 <CAJCQCtRgzw=UPfHxeaiDzqKGzrbSKz-B3xfUpBjYM4GGe=W4YA@mail.gmail.com> <8e5729f3c15997a13bdce73800146e91222ed89c.camel@duckstad.net>
In-Reply-To: <8e5729f3c15997a13bdce73800146e91222ed89c.camel@duckstad.net>
From:   Chris Murphy <lists@colorremedies.com>
Date:   Tue, 4 Dec 2018 12:38:29 -0700
Message-ID: <CAJCQCtSnEhjLiSdfuDUK85fbOjYG2a2Dw+BS9PndMV9ZDL1Wmg@mail.gmail.com>
Subject: Re: Need help with potential ~45TB dataloss
To:     Patrick Dijkgraaf <bolderbast@duckstad.net>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Tue, Dec 4, 2018 at 3:09 AM Patrick Dijkgraaf
<bolderbast@duckstad.net> wrote:
>
> Hi Chris,
>
> See the output below. Any suggestions based on it?

If they're SATA drives, they may not support SCT ERC; and if they're
SAS, depending on what controller they're behind, smartctl might need
a hint to properly ask the drive for SCT ERC status. Simplest way to
know is do 'smartctl -x' on one drive, assuming they're all the same
basic make/model other than size.


-- 
Chris Murphy
