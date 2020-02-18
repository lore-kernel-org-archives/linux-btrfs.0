Return-Path: <SRS0=4mvY=4G=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 16D33C34026
	for <linux-btrfs@archiver.kernel.org>; Tue, 18 Feb 2020 17:23:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D762A2464E
	for <linux-btrfs@archiver.kernel.org>; Tue, 18 Feb 2020 17:23:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ikH/5n0E"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726605AbgBRRXM (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 18 Feb 2020 12:23:12 -0500
Received: from mail-ot1-f48.google.com ([209.85.210.48]:40907 "EHLO
        mail-ot1-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726475AbgBRRXL (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 18 Feb 2020 12:23:11 -0500
Received: by mail-ot1-f48.google.com with SMTP id i6so20278543otr.7
        for <linux-btrfs@vger.kernel.org>; Tue, 18 Feb 2020 09:23:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=x04oj4e2PUFAiF7IxUL+dR2YQmXAGHEhUf95ZAelLFo=;
        b=ikH/5n0EdxqDNCssqzqqFTOi5moT81bjehZeKtuEFB1a+qxC1dmkZ/WyTOtN0+eaHA
         nfThEtboEfzZbYlnqrDOztckGEJHGXiqvTk3IbbAy2MlcwKG5t0xh7gGTdnoL9ySRHKj
         5MK6p+3RuiDCOEshhiRMtJHkTB+9wuBxMken9BC1tvIGF12KuVZGHnnhYaGvokcU/oKT
         U4CdruZZ6J4Wh5G/oIhNlOOm8mEIij8zGL4VAZFDeLx4Y1zyfI636sPKsnmn0ES6RikH
         TqU52fYMWMY8jRm8F5NPtW8j36VCelyUz/7B3YjUh4G1h+XLGTskr2rCAfnaF4hGrFxz
         1Edw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=x04oj4e2PUFAiF7IxUL+dR2YQmXAGHEhUf95ZAelLFo=;
        b=sX3boQtxSnXC2Gok/OUBYa5lCj/AWD6GsvbXPMg+gSAhgIftM61JbrRRO7cOrV+fZS
         YG2T0J8BynUGxo1Tm1WvSl0lTXdNkYnXGnahjwmQpcBFp3Oahorn5S9BuVHCM3yS6ED4
         H3t4UfBq957mz28MVBDw+YnPWdUyYl/gYNWu+d7RXqoVm++v6hL9JHyhrsWD3GadxkLI
         2PbY4xwO5SBL9aK4LK9N0+5fKXgrco09BrFQ9V659VCrYYGpaNJUWoJEpLTHiyzSWJ7y
         Ky6IC2oMJMsn9xANeBnB6Sk8YETmFlnqklW/7Rr/UfdgFFDCm5YuD9I2+pruMyd3xJRV
         Yr5g==
X-Gm-Message-State: APjAAAUCguskZJjAbQHDYcvAyJjYEpZHLsq/iW5Tj44QECjkrDzgDfhU
        227t6bg2SJiNT5iR07P7ylgFFkIB+901GpwhX+c=
X-Google-Smtp-Source: APXvYqxRDZEHqGoQEnFLy1aoXZj/6dehGF4nbGy9jbLr7suAsk1VQMhGgp1JVsOwyQyxDl0h+W/lEpSoHsdJ1gV0/wY=
X-Received: by 2002:a9d:aea:: with SMTP id 97mr16379957otq.51.1582046589484;
 Tue, 18 Feb 2020 09:23:09 -0800 (PST)
MIME-Version: 1.0
References: <8fb8442b-dbf9-4d4b-42bb-ce460048f891@sfelis.de>
 <CAPmG0ja40xPPcXxM+uv_v339v+8Jc5TLP_kONbkw1vWHFUer-Q@mail.gmail.com>
 <CAJCQCtQjRMctPYtPM-v2=ZGBMJ5T88eyVcvdgR9SfpTVWBgSOQ@mail.gmail.com> <CAPmG0jYW+OFUSzYiRAQDLD_GsnBYpriABA7cT6U-=O96N15=_w@mail.gmail.com>
In-Reply-To: <CAPmG0jYW+OFUSzYiRAQDLD_GsnBYpriABA7cT6U-=O96N15=_w@mail.gmail.com>
From:   Henk Slager <eye1tm@gmail.com>
Date:   Tue, 18 Feb 2020 18:22:58 +0100
Message-ID: <CAPmG0jY6hGUSTbeRvxwna86CNwH637KCswPM=ikWzSpnK9mdBw@mail.gmail.com>
Subject: Re: kernel incompatibility?
To:     Chris Murphy <lists@colorremedies.com>
Cc:     Simeon Felis <simeon_btrfs@sfelis.de>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Tue, Feb 18, 2020 at 6:20 PM Henk Slager <eye1tm@gmail.com> wrote:
> problems in raspbian kernel7 4.17.97 on a RPi3B+
typos: 4.19.97 on a RPi3B
