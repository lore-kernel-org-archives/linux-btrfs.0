Return-Path: <SRS0=f83N=ZT=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2359BC432C0
	for <linux-btrfs@archiver.kernel.org>; Wed, 27 Nov 2019 01:36:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E78C4207DD
	for <linux-btrfs@archiver.kernel.org>; Wed, 27 Nov 2019 01:35:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=colorremedies-com.20150623.gappssmtp.com header.i=@colorremedies-com.20150623.gappssmtp.com header.b="I3wtPlem"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726346AbfK0Bf6 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 26 Nov 2019 20:35:58 -0500
Received: from mail-wr1-f43.google.com ([209.85.221.43]:40288 "EHLO
        mail-wr1-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726099AbfK0Bf6 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 26 Nov 2019 20:35:58 -0500
Received: by mail-wr1-f43.google.com with SMTP id c14so119857wrn.7
        for <linux-btrfs@vger.kernel.org>; Tue, 26 Nov 2019 17:35:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=colorremedies-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=sCYT1ai2ryYHQRl/1kGyGKuBWMNLzuYoEYaqvWFEaGI=;
        b=I3wtPlemSUppmFR96/OWwJTP/r2Ja0hxZNGLO0YdK/6bQAz/lwKscbwu6wzW+Wa7Hk
         95SLU3KzWbDABpSLeXV0YXZScLZD3tT3wrcGvBZRazOifDZfwXcG5D0shzwZVWnrCLOl
         lMjxj4hk8dwufTzagVwe+aIzE7LN0WaAkWyK+BJLVpoBn5kvgriFXgpAPJ09seDgxuqg
         c+/z4ct+0pP6uLF3mquWpTu2bM7B86cWQuD2uEXCRusuvm34oCaF8hFBiVaQiF/C0OPq
         M7rqzi7xtPLGbFL9tqAei9HycxcesNhLO199xE+iJkHVlIvprxiWWuWyHAiycz1onSBF
         hxfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=sCYT1ai2ryYHQRl/1kGyGKuBWMNLzuYoEYaqvWFEaGI=;
        b=feTeMp0/bzHzPhy5pkX0EpwX02wwQGS+q4VuQJ2LnuGwEBDnfbS5J9EmPb2tW5YW8E
         hTMD6M+u63wXCmvqw0iCtCCoUnb83Apn5hrcPMR3zjOOqW4ZpQLd/+PAlaOOTN78d1LS
         RVnUqyWFXNuZgaEMrVD3wIoduI9/uZlhYrD5RDrmi3H21KogRr8uY07lJhQRUo3ezdg7
         POM+AzTJVpsVMYNth1hnD7nszffZoPpN38ve3nhAkk0A0Ve1vETmNFsedHdfQIafh9Wb
         RP3KPrNfHRp9zEAKR8VIoViuazRFDhBO1DWhcaE/0LN5RARUO29JUIjCnUc8B1+5pcMj
         M7dw==
X-Gm-Message-State: APjAAAXvaSUP0miVO9Yp6vaFatIu14xvYQknnKSyKEpIXtmLJabn10Zf
        nRAJJZF8LftW1ZeiCovPT41S5sb+HCSUOExeCwjt9w==
X-Google-Smtp-Source: APXvYqwI+tMg/RGfdDULxnwxr8rpuusXYzX7545pJWdn5s+pnLL5bnlX3wSj6Smfu7ffMuodFvwFojBPXCzEVTKckAU=
X-Received: by 2002:adf:f108:: with SMTP id r8mr9100804wro.390.1574818556349;
 Tue, 26 Nov 2019 17:35:56 -0800 (PST)
MIME-Version: 1.0
References: <CAJCQCtSeZu8fRzjABXh3wxvBDEajGutAU4LWu0RcJv-6pd+RGQ@mail.gmail.com>
 <a48a6c50-3a03-0420-ad8c-f589fafe6035@libero.it> <CAJCQCtR6zMNKnhL7OZ8ZGCDwPfjC9a1cBOg+wt2VqoJTA_NbCQ@mail.gmail.com>
In-Reply-To: <CAJCQCtR6zMNKnhL7OZ8ZGCDwPfjC9a1cBOg+wt2VqoJTA_NbCQ@mail.gmail.com>
From:   Chris Murphy <lists@colorremedies.com>
Date:   Tue, 26 Nov 2019 18:35:40 -0700
Message-ID: <CAJCQCtS2CP75JTT4a6y=rzqVtkMTqTRoCvJK9z3mMwLRfKo9Xw@mail.gmail.com>
Subject: Re: GRUB bug with Btrfs multiple devices
To:     Goffredo Baroncelli <kreijack@inwind.it>
Cc:     Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Tue, Nov 26, 2019 at 4:53 PM Chris Murphy <lists@colorremedies.com> wrote:
>
> On Tue, Nov 26, 2019 at 2:11 PM Goffredo Baroncelli <kreijack@libero.it> wrote:
> >
> > I think that the errors is due to the "rescan" logic (see grub commit [1]). Could you try a more recent grub (2.04 instead of 2.02) ?
>
> Yes Fedora Rawhide has 2.04 in it, so I'll give that a shot next time
> I rebuild this particular laptop, which should be relatively soon; or
> even maybe I can reproduce this problem in a VM with two virtio
> devices.

I was able to just update to the Fedora 2.04-4.fc32 packages. It's not
upstream's but it's a quick and dirty way to give it a shot. Turns
out, the same errors happen, although the line number for efidisk.c
has changed:
https://photos.app.goo.gl/aKWRYhJkkJRDtC1W7

For grins, I dropped to a grub prompt, and issued ls and get a different result:
https://photos.app.goo.gl/MvL9QZa6zGsiktAf9

Also for what it's worth, the Btrfs in question is on hd5,gpt4 and
hd5gpt5 - same physical device, different partitions.


-- 
Chris Murphy
