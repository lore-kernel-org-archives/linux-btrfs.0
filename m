Return-Path: <SRS0=wNEY=M6=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 61437ECDE43
	for <linux-btrfs@archiver.kernel.org>; Thu, 18 Oct 2018 06:43:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1DC852098A
	for <linux-btrfs@archiver.kernel.org>; Thu, 18 Oct 2018 06:43:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bIpZq5i6"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1DC852098A
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727488AbeJROmp (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 18 Oct 2018 10:42:45 -0400
Received: from mail-oi1-f169.google.com ([209.85.167.169]:40807 "EHLO
        mail-oi1-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727357AbeJROmp (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 18 Oct 2018 10:42:45 -0400
Received: by mail-oi1-f169.google.com with SMTP id j68-v6so23146468oib.7
        for <linux-btrfs@vger.kernel.org>; Wed, 17 Oct 2018 23:43:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=BmCuPKbSVhYSwyubcZgvrxhF7/JSTpm+WX6pdFtu/l0=;
        b=bIpZq5i6qN8Imum8Jw8m2pTQERTlfvbYhRAbthKTIOd3XkhKnz2+tEHhHKZQ11zWHH
         n3f9w38uf+VjsOyelBPpJ56ZMZv0NzD5h7y3+tNCObLVf49xhPQrNuF4qBtg4nAB6xUf
         Q0LEjEDvfa8TjxVA1iC0TMR2ZGd1jXGgiazZn2iWAwL4NePaYzVZSO23O++Wpe0ZbANe
         qxr/oZHZBMJMOlppN4Z4VhNFZku2wwSxBbInN/VNww96BkPIfjSSdUlQ1sYAFNGhgkw+
         6xB9ncqkHjC3dub/OJeo6oQPUHqaRItm9pnm7UcL+FB5i7ZC9XURHQYlJL+iHeh0+Jop
         aSXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=BmCuPKbSVhYSwyubcZgvrxhF7/JSTpm+WX6pdFtu/l0=;
        b=QwbCm9qy5toMTstI+BGt8NpRAQaFD1XlIJu86GWN4LjmUSZrUoI9QHlJrr4I6NDKt7
         EyifXIyXet9sJqAyDFslXuX1gr2mbMO155MDL1FnoauP6ZMorGcqzeU4yr4UDPwpdW7O
         YtRqF61XNAEzri2zrIqEhPKNKm03AQGWjvM/nQnqQmr6Qgf+jeOlmBjGSxzls95SMeIu
         R17c5UeQYt8qcPgctyIoNYVaCyXXVXdpldnm7l47RrQHUUDdS+gncMvgNNwCflO6o2N3
         UPn/gkgYBhJ0JwsJRtPOKlKPCAfJm6mFrp2jZhRrZsoNGi4OcYfs2uT7Vb7kcxVj/BeR
         v5pA==
X-Gm-Message-State: ABuFfogQmKro4wfZA8ypGHoZ1aCfiF42qOL07j1b5B5Sy9JBAXsoZ99V
        IHFRirmLJ4HjrmxC1DIu9LwVgBpB95bW8VC+8nVQy0av2Pw=
X-Google-Smtp-Source: ACcGV632I8TVWeqJsSHhph7ELs9JlEACj6HKiLENVgBqggaLQmwjtaw4i9JuOHj9/CRSeZBgRxLym/Dw9igicWmLZtY=
X-Received: by 2002:aca:f5d3:: with SMTP id t202-v6mr16015893oih.29.1539844994902;
 Wed, 17 Oct 2018 23:43:14 -0700 (PDT)
MIME-Version: 1.0
References: <pq90ft$hso$1@blaine.gmane.org>
In-Reply-To: <pq90ft$hso$1@blaine.gmane.org>
From:   Henk Slager <eye1tm@gmail.com>
Date:   Thu, 18 Oct 2018 08:43:03 +0200
Message-ID: <CAPmG0jbaKvK-xvkQ+sBVsCGiVdxDJA-o_rFDCxH1CJN-dW6-iA@mail.gmail.com>
Subject: Re: Untar on empty partition returns ENOSPACE
To:     jd.girard@sysnux.pf
Cc:     linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Thu, Oct 18, 2018 at 6:04 AM Jean-Denis Girard <jd.girard@sysnux.pf> wrote:
>
> Hi list,
>
> My goal is to duplicate some SD cards, to prepare 50 similar Raspberry Pi.
>
> First, I made a tar of my master SD card (unmounted). Then I made a
> script, which creates 2 partitions (50 MB for boot, 14 GB for /),
> creates the file-systems (vfat and btrfs, default options), mounts the
> two partitions:
>
> mount $part2 $mnt
> -ocompress=zstd,space_cache=v2,autodefrag,noatime,nodiratime
> mkdir $mnt/boot
> mount $part1 $mnt/boot
>
> When untarring, I get many errors, like:
> tar:
> ./usr/lib/libreoffice/share/gallery/arrows/A45-TrendArrow-Red-GoUp.png :
> open impossible: No space left on device
> tar:
> ./usr/lib/libreoffice/share/gallery/arrows/A53-TrendArrow-LightBlue-TwoDirections.svg
> : open impossible: No space left on device
> tar:
> ./usr/lib/libreoffice/share/gallery/arrows/A27-CurvedArrow-DarkRed.png :
> open impossible: No space left on device
> tar:
> ./usr/lib/libreoffice/share/gallery/arrows/A41-CurvedArrow-Gray-Left.svg
> : open impossible: No space left on device
>
> Which usually results in unusable SD card.
>
> When the first errors occur, less than 1 GB has been written. I tried to
> change mount options, especially commit interval, but still got ENOSPACE.
>
> What I ended up doing is limiting write speed with:
> xzcat $archive | pv -L 4M | tar x
> (with -L 5M I start to get a couple of errors)
>
> Is there a better work around? Or a patch to test that could help?
>
> The machine that runs the script has:
> [jdg@tiare tar-install]$ uname -r
> 4.19.0-rc7-snx
> [jdg@tiare tar-install]$ btrfs version
> btrfs-progs v4.17.1
This looks like to have a similar root cause as this:
https://www.mail-archive.com/linux-btrfs@vger.kernel.org/msg81536.html

For 50 clones, you could prepare 1 master (sparse) image and change
the UUID with btrfstune for every SD-card you have after written the
image (optionally sparse write with e.g. dd_rescue).

But it looks like some change is needed in the kernel code, although I
have no clue at the moment where exactly.
