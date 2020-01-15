Return-Path: <SRS0=+Z9o=3E=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1469AC32771
	for <linux-btrfs@archiver.kernel.org>; Wed, 15 Jan 2020 21:02:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D20FA207FF
	for <linux-btrfs@archiver.kernel.org>; Wed, 15 Jan 2020 21:02:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="onqCU4sn"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729793AbgAOVCl (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 15 Jan 2020 16:02:41 -0500
Received: from mail-il1-f170.google.com ([209.85.166.170]:35842 "EHLO
        mail-il1-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729203AbgAOVCk (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 15 Jan 2020 16:02:40 -0500
Received: by mail-il1-f170.google.com with SMTP id b15so16145129iln.3
        for <linux-btrfs@vger.kernel.org>; Wed, 15 Jan 2020 13:02:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to;
        bh=DAu46XZwgnxiGxosZYOfvyWpnOTOv58zQSx8pJd7hgI=;
        b=onqCU4snFZJtQ8RNVuUXFtW6FDZTDqPRS+8EkLy2Sk0fLd6F7QI3TB0tryIPJkAGQ/
         cEOMsAigDU21noG+5XSc146BCQEUkPSvIESyQhRrQbEV7dzfACYrNkrDGklfzJ2eSKA8
         comBca8zGfnDGgakIUge2U8YtdOIHqCKkqXh/OkTb40SvQV5Q/aXNA1cgZD8ztYLScI/
         XgSl/vkehig00y8j1LVtkuDFyaSig621/JzohfzD5NJ/iOac89+sVq47/TUPARp6NZeC
         hG3nBJYpjUBdA2OwxT/Fok/fOhA+kO/LHC1wD6HodEluRzqaTsw8QAplIDWsfbpzYWNz
         +LLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to;
        bh=DAu46XZwgnxiGxosZYOfvyWpnOTOv58zQSx8pJd7hgI=;
        b=sIh3uy7VROedl8/S+UVDhhNTmd16a8LsJX0o3DqbWUVMPWyGe08zf697hDV/YO5Ow/
         fDeOzcFbC92RccZE2omseFW+ZbPpuTlRbHmWoEH7wGw8O3bILbAwZVXhBEqlc3hcsbMS
         lFNiCo3H0heBxe3ZTESI0tlJblI0E2z1qOUM0+Ce5tb0ZS3PV7EOnQomDoWmH1meFdql
         s76kz8SyO6fU28HDOCqwl1v8zdTEL1Y6D6BMCkJ9ra1ZpaqUjWyR9qhJcFwd7D5gCEhl
         v99GLtRNRtLIBfbfFABg+7dyx0Aiu88OcaApnpq3Wy/11mW0HIi2qSme8C8S/WzHIuB/
         zG6Q==
X-Gm-Message-State: APjAAAWTK6PiVwc4/0ESSmB6z0lxUQnDK1d3j38CAghQQUZssN53bGLI
        0sXr+xBj8HFcL5IxQqtKmumzuF5ENgeJQQvUCUovBw==
X-Google-Smtp-Source: APXvYqylm06yZsi55hx4paJfuEVM3lZPBGexeFXS0XLG4x9W62XTcVrFStNSs1kFxj3aLXr0QRPLbKAp4NA/skz+vAA=
X-Received: by 2002:a92:350d:: with SMTP id c13mr432987ila.205.1579122159703;
 Wed, 15 Jan 2020 13:02:39 -0800 (PST)
MIME-Version: 1.0
References: <d0a97688-78be-08de-ca7d-bcb4c7fb397e@cobb.uk.net>
 <20200115125134.GN3929@twin.jikos.cz> <5aa23833-d1e2-fe6f-7c6e-f366d3eccbe3@applied-asynchrony.com>
In-Reply-To: <5aa23833-d1e2-fe6f-7c6e-f366d3eccbe3@applied-asynchrony.com>
From:   =?UTF-8?Q?Sebastian_D=C3=B6ring?= <moralapostel@gmail.com>
Date:   Wed, 15 Jan 2020 22:02:26 +0100
Message-ID: <CADkZQa=aZdaJRQ6=OQwtSkHk7fWEh+WOvN4LRiFD11GAQ0pZMA@mail.gmail.com>
Subject: Re: Scrub resume regression
To:     linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

> Isn't the real problem that cancel does not actually mean cancel,
> but rather also implies "..and maybe continue"? IMHO cancel should cancel
> (and say how much work was performed), while the intention to resume should
> be called e.g. "pause". This makes the behaviour clear and prevents
> accidental semantic overlap.
>

IMHO a better choice of wording might also be "interrupt" and "abort",
but maybe that's just being pedantic (cancel could then stay in place
for backwards compatibility). In any case the current man page for
btrfs-progs makes it somewhat clear what's supposed to happen and my
confusion was mostly caused by the bug.

BTW: Thanks to everyone who helped tracking down the cause of this
bug. Haven't had a chance to test the proposed patch yet, but am
looking forward to schedule large scrubs across multiple nights.
