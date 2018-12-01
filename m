Return-Path: <SRS0=eQkg=OK=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DA085C04EB9
	for <linux-btrfs@archiver.kernel.org>; Sat,  1 Dec 2018 13:42:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9C79D20834
	for <linux-btrfs@archiver.kernel.org>; Sat,  1 Dec 2018 13:42:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="CejCek3F"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9C79D20834
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726815AbeLBAyb (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sat, 1 Dec 2018 19:54:31 -0500
Received: from mail-yb1-f172.google.com ([209.85.219.172]:35584 "EHLO
        mail-yb1-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726619AbeLBAyb (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Sat, 1 Dec 2018 19:54:31 -0500
Received: by mail-yb1-f172.google.com with SMTP id z2-v6so3480925ybj.2
        for <linux-btrfs@vger.kernel.org>; Sat, 01 Dec 2018 05:41:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=N+MaJiC6krqG6fLhf/EhmTZ5x1RvECweraeAfiBXUks=;
        b=CejCek3Fh5MnxPJxnKa59pvHx12KznRHyRcjSa6FyTh0IS02a0m6zp/1JgMb51b2R2
         tF9SYC4YpqtPGg8sPmEs2O5Hrf3Y3nf94272G5am2YHBiGtLhmHk7MS9eqLYl9OkJ5RY
         aCoTK8NnqwArFn2pYNJ9USsr9a7+0/4XvK+C5wP6xa0xtdvzYfHU0LsomY7VAFlaw2Au
         NwahiiH0bg6QLmXIKJ0UH6E5ep2CmwqHyR23GgQKuMo+0CMr15M+rsfFtlXwfC/tZf6k
         HKinH5m1EVC3iC3x4nnfXBZmSYLe4xMhtdAoGEkQoP7wXPzeVm+F9qMrBjGu19REUS3n
         bUWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=N+MaJiC6krqG6fLhf/EhmTZ5x1RvECweraeAfiBXUks=;
        b=k2JO1rWMlQ3uetmGIPrJqEs22Kj/GgDbk4D8v0SjhK4Yqu8KmyjC9UCAtOlfRV+uMV
         bfsnmM7oQ7WOI3XTYmAyrmWavOeP2JW9xk3KLe9Y4EIx5hI6gSmGjy11d5bKmYG5vBo1
         E2MfdoEpFP5pQ30Ll2PqpIiFJgRq/avocHDtv18FPep9ebXEH7K5iaxYW7118ZzGaVaq
         wkAK2m1JS0WalORmEvZ2daGU7e9ahZMVuu7qbwQYOuUmCnsmqSCdZosoYwjgEXg808yl
         WVY3yMmIfak2/lyweuipuW0HSAzVGRQR6poHw9d6SZ+ZFLIj/8w/4v9tmi6sHc1nic7l
         7C3A==
X-Gm-Message-State: AA+aEWaxp8DT3R0BwWJhgVpk6gjsazr4jtPqOOp0IZcHz+h5HczxuOyr
        HkhHXWTE3KJb5lpD/7EYCxsid/QwFwpXwqAEjDJS0koo
X-Google-Smtp-Source: AFSGD/XQWBGnHT3k8oHMqNJ94vKFDN3yDZes6KPdSUshf3w7gEGOlLGWF4Ph+IFPGDsKnWT72MhyM1kdQ8fQ2syQUSY=
X-Received: by 2002:a25:7742:: with SMTP id s63mr3028455ybc.254.1543671718027;
 Sat, 01 Dec 2018 05:41:58 -0800 (PST)
MIME-Version: 1.0
From:   Zhengping Zhou <johnzzpcrystal@gmail.com>
Date:   Sat, 1 Dec 2018 21:41:45 +0800
Message-ID: <CALXdtC42+J4GSPPt8cXjSHNw1fWDCBkdtRurhC0+UZm4P9sDbg@mail.gmail.com>
Subject: =?UTF-8?Q?Question_about_function_=E2=80=9Dend=5Fbio=5Fextent=5Freadpage?=
        =?UTF-8?Q?=E2=80=9D_in_btrfs?=
To:     linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

  Hi all:

      I'm wonding why we should recheck inode->i_size and
zero_user_segment the page's tail which crossed the EOF, I think it's
already zerofilled in function __do_readpage.
      function end_bio_extent_readpage:
2597 readpage_ok:
2598                 if (likely(uptodate)) {
2599                         loff_t i_size =3D i_size_read(inode);
2600                         pgoff_t end_index =3D i_size >> PAGE_SHIFT;
2601                         unsigned off;
2602
2603                         /* Zero out the end if this page
straddles i_size */
2604                         off =3D i_size & (PAGE_SIZE-1);
2605                         if (page->index =3D=3D end_index && off)
2606                                 zero_user_segment(page, off, PAGE_SIZE=
);
2607                         SetPageUptodate(page);
2608                 } else {
2609                         ClearPageUptodate(page);
2610                         SetPageError(page);
2611                 }
2612                 unlock_page(page);
2613                 offset +=3D len;
       There could be one situation that the file was truncated after
__do_readpage be called, but
I think the function =E2=80=9Dtruncate_setsize=E2=80=9D will zerofill the p=
age's tail
which crossed the EOF
        Could someone give me a hint=EF=BC=81

Thanks!
