Return-Path: <SRS0=I+S+=SR=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CF3F3C10F12
	for <linux-btrfs@archiver.kernel.org>; Mon, 15 Apr 2019 13:15:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9FD5F20693
	for <linux-btrfs@archiver.kernel.org>; Mon, 15 Apr 2019 13:15:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="T2QHs5ln"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727186AbfDONPM (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 15 Apr 2019 09:15:12 -0400
Received: from mail-qt1-f182.google.com ([209.85.160.182]:41739 "EHLO
        mail-qt1-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726785AbfDONPM (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 15 Apr 2019 09:15:12 -0400
Received: by mail-qt1-f182.google.com with SMTP id w30so18949662qta.8
        for <linux-btrfs@vger.kernel.org>; Mon, 15 Apr 2019 06:15:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=cdCH5plb6jMQ4jQSWkNPPzZm5TMnuO3vQUi2spsdCrI=;
        b=T2QHs5ln7jo6TVnAkd3TaSqUmphUdpgl7O8aWPf/3bUmU5Sb6X0cH5QGh/pJrxQXil
         VgVbiAXPULa5t5uCsQOqG25NLyucUz4v2aXgVJrAv7or13Gbel+iZ8MKLbV9GnJGmNTh
         IBu8gs7RNg8XpUZ+tjICkhml/Zm1APJsh9bJO37g1IXiqZXvaZbkENGJbJ8HVkubQu2s
         yni5LX0OsQ+KbqtOhspFog6pOT5Pbiz3K/MeEyaLGK29mYsM5OS+k14tps9JzVdxeZfF
         Rd6INOpX9+Ua4CWge7Pirj08w+J62II2FuMESuVmUfOqK7ZEicuboQB0h0z6gOODgP6L
         g3Mw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=cdCH5plb6jMQ4jQSWkNPPzZm5TMnuO3vQUi2spsdCrI=;
        b=M1/3NAv2r/UJYZ605wA0kSqpJMtonJ9JIE3Y7Wu4LwdEmZ/cZ4nPk0ePVrqqGIsAk6
         NyVRG/2Pu1aXir8I1Wlu5QFDU8x7dyKJRzaHpdB1afZnOidoXtgStJxarznHd6cjgKXo
         xQROvaQiaSuKEyfvP/7D/4naJW5pnaKUR0mNeci/EfIFUFRe6JHlg5UfnLQeSWdDUiH1
         abapFWunKOxqtNs6Pzjsz5AVmn1sdgx4OONVyMlTL/w+NGHq12swGMs9UGsGGQq9GFEa
         LZKaFfjSf+eNQdi95NCEFKPITMfa0pmYNwoKkYqtSQRfv0qCwSd6KzUmdFjqphCfZEay
         87rg==
X-Gm-Message-State: APjAAAVyK+H2FU2HsUn6Vz92/JQHz3H4s9W5MjCDnVIv2qLktM+pr4Dp
        ALQCwX2TaCl7rzIPytW3xF+eXPQHKum1HeVE0OM=
X-Google-Smtp-Source: APXvYqz9nA7mWI5hvoE8nddv9RLowUkDT7fn4Mlrm4nCQc/zi8Y4C37YNpNPugji9pG2+ka0XlxriXvWFKA4dqdzn2Q=
X-Received: by 2002:a0c:ac83:: with SMTP id m3mr60531995qvc.85.1555334111095;
 Mon, 15 Apr 2019 06:15:11 -0700 (PDT)
MIME-Version: 1.0
References: <23723.27955.359573.44839@techsquare.com>
In-Reply-To: <23723.27955.359573.44839@techsquare.com>
From:   Patrik Lundquist <patrik.lundquist@gmail.com>
Date:   Mon, 15 Apr 2019 15:14:58 +0200
Message-ID: <CAA7pwKM74XGGVR6h+OjgPpLx__QmFzgMKvy-CQjbNOEzP6fD=Q@mail.gmail.com>
Subject: Re: checksum error...
To:     "Scott E. Blomquist" <sb@techsquare.com>
Cc:     "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Mon, 8 Apr 2019 at 18:27, Scott E. Blomquist <sb@techsquare.com> wrote:
>
>     root@cbmm-fsb:~# btrfs fi df /home/cbcl
>     Data, single: total=79.80TiB, used=79.80TiB
>     System, RAID1: total=32.00MiB, used=9.09MiB
>     Metadata, RAID1: total=757.00GiB, used=281.34GiB
>     Metadata, DUP: total=22.50GiB, used=19.27GiB
>     GlobalReserve, single: total=512.00MiB, used=0.00B
>
> sda and sdb are megaraid raid6 with BBU and both are optimal.

You should convert the remaining "Metadata, DUP" to RAID1.

btrfs balance start -v -mconvert=raid1,soft /home/cbcl
