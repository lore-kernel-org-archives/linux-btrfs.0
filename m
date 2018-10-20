Return-Path: <SRS0=Qnmz=NA=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 82249C67863
	for <linux-btrfs@archiver.kernel.org>; Sat, 20 Oct 2018 20:39:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 33458215EC
	for <linux-btrfs@archiver.kernel.org>; Sat, 20 Oct 2018 20:39:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=ceremcem-net.20150623.gappssmtp.com header.i=@ceremcem-net.20150623.gappssmtp.com header.b="lWpd/4y8"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 33458215EC
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=ceremcem.net
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726618AbeJUEvR (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sun, 21 Oct 2018 00:51:17 -0400
Received: from mail-vk1-f181.google.com ([209.85.221.181]:39436 "EHLO
        mail-vk1-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726394AbeJUEvQ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 21 Oct 2018 00:51:16 -0400
Received: by mail-vk1-f181.google.com with SMTP id y69so4567830vkd.6
        for <linux-btrfs@vger.kernel.org>; Sat, 20 Oct 2018 13:39:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ceremcem-net.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=rL/E51pD3U6s6wCzRu6kG/ScJ1Vw7ij5Y1nBiO75gqA=;
        b=lWpd/4y8GD3nE2PEjrbSS8TcT7Gjiew3kcNhn1mbMJkqIiWiEBIkQgvrBO9z1SM21H
         vpk4ZyTqkpKzRMldceCx8LzzZ8RtPqvZUBpIfFykEuwjn0BDT8E6EmXx4QFGoixzAxQv
         9pdrFKgFGBg/b/Ab4gznMxq8OiANWAVSDvy3XE3rESqeHSiYnnF+sOtrsBIG/dx0d5WT
         27PcI6zGcz7TpKuIDIYOlQqfaD63tygnxFEUxKayR+/FwhnKoxD/RXulOpzWcgq9q+1C
         1tk2gFfIJA+8BD9/Dx4kDtzvrrtck9MrNb8xisBG3kJJcvbUlhl3nlfZzUI8BKUh90Di
         RbTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=rL/E51pD3U6s6wCzRu6kG/ScJ1Vw7ij5Y1nBiO75gqA=;
        b=FgPcd/CUJn9XW1SqtT2bXGSn3pDLhIQLNHZKwAEug2spvKKHkRYzHTen6MDNtnRzWV
         TwK7kKVpUTQApvl9Xj23H/i0vykvRALMvsYVDbBssz+PI2ZsiMdc3ksYFoG/Drbgli5q
         MDQa587hJpvXnGewYYV05GBZD+9Lbp1kgaPV4Ps58ULl1lBbjHl9u4Uzc11aAR9eXR2B
         78h5yOlSmgfi0AhamZv3L/LdGqaCEqwKj3labKoIg3YU8euSKbbktQ0uXGDtMSGJO8kz
         E25VNiz7xkYasczb/2KQHT2Ix6kJpP6MSwfOAwXa4Key/KsfsGF+fLCtzqsyjAI3Al1b
         xLxA==
X-Gm-Message-State: ABuFfohx1xTHJ7NJNzy04ByYV4I8CPUDSB92cZLgu1vrJHbMJHnhikzo
        7Syujzok0XJTZlmqQ9evurKya36KgartcScrZf2Tj3YqctQ=
X-Google-Smtp-Source: ACcGV63L7hguVu3OBHu7qF8G2U00ZHz25equM37RoUQyVojYKeO0yR61vboUp8L9RQU35jSwOrfFRgAuO/IViENHVvU=
X-Received: by 2002:a1f:2b05:: with SMTP id r5-v6mr16456351vkr.48.1540067975861;
 Sat, 20 Oct 2018 13:39:35 -0700 (PDT)
MIME-Version: 1.0
References: <pq90ft$hso$1@blaine.gmane.org> <CAPmG0jbaKvK-xvkQ+sBVsCGiVdxDJA-o_rFDCxH1CJN-dW6-iA@mail.gmail.com>
 <pqfts8$6a6$1@blaine.gmane.org>
In-Reply-To: <pqfts8$6a6$1@blaine.gmane.org>
From:   Cerem Cem ASLAN <ceremcem@ceremcem.net>
Date:   Sat, 20 Oct 2018 23:39:24 +0300
Message-ID: <CAN4oSBfHiez22uNVsST8Cnzyiiic8Q+9yxw=2LJs4wu_ADVxQw@mail.gmail.com>
Subject: Re: Untar on empty partition returns ENOSPACE
To:     jd.girard@sysnux.pf
Cc:     Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

You don't even need dd_rescue or something for RaspberryPi creation,
you may use https://github.com/aktos-io/dcs-tools#cloning-a-target-into-a-n=
ew-target
Jean-Denis Girard <jd.girard@sysnux.pf>, 20 Eki 2018 Cmt, 22:00
tarihinde =C5=9Funu yazd=C4=B1:
>
> Le 17/10/2018 =C3=A0 20:43, Henk Slager a =C3=A9crit :
> > On Thu, Oct 18, 2018 at 6:04 AM Jean-Denis Girard <jd.girard@sysnux.pf>=
 wrote:
> > This looks like to have a similar root cause as this:
> > https://www.mail-archive.com/linux-btrfs@vger.kernel.org/msg81536.html
>
> Yes, seems similar.
>
> > For 50 clones, you could prepare 1 master (sparse) image and change
> > the UUID with btrfstune for every SD-card you have after written the
> > image (optionally sparse write with e.g. dd_rescue).
>
> Thanks for suggestion, I may try this another time, but I can live with
> my workaround.
>
> > But it looks like some change is needed in the kernel code, although I
> > have no clue at the moment where exactly.
>
> Right, this is why I send this message, try to motivate a dev to look at
> this issue ;)
>
>
> Thanks,
> --
> Jean-Denis Girard
>
> SysNux                   Syst=C3=A8mes   Linux   en   Polyn=C3=A9sie  fra=
n=C3=A7aise
> https://www.sysnux.pf/   T=C3=A9l: +689 40.50.10.40 / GSM: +689 87.797.52=
7
>
>
