Return-Path: <SRS0=25Zt=3X=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4F302C35247
	for <linux-btrfs@archiver.kernel.org>; Mon,  3 Feb 2020 16:17:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1867F20838
	for <linux-btrfs@archiver.kernel.org>; Mon,  3 Feb 2020 16:17:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=colorremedies-com.20150623.gappssmtp.com header.i=@colorremedies-com.20150623.gappssmtp.com header.b="nOuXK9wt"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728346AbgBCQRj (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 3 Feb 2020 11:17:39 -0500
Received: from mail-wm1-f44.google.com ([209.85.128.44]:51664 "EHLO
        mail-wm1-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727253AbgBCQRj (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 3 Feb 2020 11:17:39 -0500
Received: by mail-wm1-f44.google.com with SMTP id t23so16629872wmi.1
        for <linux-btrfs@vger.kernel.org>; Mon, 03 Feb 2020 08:17:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=colorremedies-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=fKbMynqGivH/YXcTx2g7DtAtAzPDh20S9hiMJBwKvCM=;
        b=nOuXK9wtMDDg01VWPgFcMscE4cZKMHhutdeTns383nEoFG6vQPK9aKpOkeWgPZmehn
         xkssGg4YHXdq+/S5tqP90qg8AXpRefyaG3HZr5yBWVUUtY+FRAG9kn+2jiMpT0pIv+jm
         z1O/+RsPzpgn8H1DwZBybR9KqLJD2vV4HmCxCrWFT1hI0pB/NTGc7VifQuDQTqyclIcC
         Nfx8jq1zGwJSE+zcWancZ/LhxtpaMjP380QKCYMJmrXiwrMPDkTv6o+EPnUkMgHpniY4
         OTWdwxC8FVZmkRI5FgGZCDoL5LlULkZVqWOyeohcAkKB5iaZq7fnwO4K82DyTh2n78xj
         LFcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=fKbMynqGivH/YXcTx2g7DtAtAzPDh20S9hiMJBwKvCM=;
        b=AHskmIpWlHirHCTy1EE3eaabVAD61N4JeCvHCpvfNGcSYCaB2Y7gWkoRz7BoOmWnll
         rsfbtsK7e0t6Ozx8vqBh9/wk+oCji8ornc6GtsVl60IOQnPXq6j1YQejwUj1KExEpHqF
         AWc+ak3+VHZgVujdSOCdP/0d/JC5qdtSPofNhqudjCO5jKoDCKif5FeadsW4bxAFZyRG
         0IgIpT4SUF1RKWzhMFwadDUyKQvy7/CsFQR3V93m70pUyEEryX6CdKoJnHToZnz/gK6V
         LIEMtOPFuVmeYElwTkWap0dO754y5cBq3Kyq7C2taU0MfKxpc4tFecD3nBewqMX2vvKX
         qzqg==
X-Gm-Message-State: APjAAAVmg8GlJgyHKDAWouFunU3tWhszPMv9tgbt+l8zFfZX39M2ygak
        pZeP+KjmWtAfd3ab6PinbaklRqraKhKeMAG12Wgj6Q==
X-Google-Smtp-Source: APXvYqwsmFE9ROiL1mG4XWV0oyPK53zPjO/097t5ayLV7P6S+ghjZyfr96Q2nsxIRe+uWILC+IwklNlOiZuztBSlsFg=
X-Received: by 2002:a05:600c:217:: with SMTP id 23mr29643771wmi.124.1580746657135;
 Mon, 03 Feb 2020 08:17:37 -0800 (PST)
MIME-Version: 1.0
References: <CACN+yT_AYiLc29M41U+WrQHtk4t==D-4AkH+wRROKJY=WstGAA@mail.gmail.com>
 <CAJCQCtR0hzV+9S7cggGUUTtp4R1WdnSwzsOp=9fTnxvzn3Stmw@mail.gmail.com> <CACN+yT-FrVi71HKANj7NRinyPoDG5Aowma9NT=UB2WGvqoLSVA@mail.gmail.com>
In-Reply-To: <CACN+yT-FrVi71HKANj7NRinyPoDG5Aowma9NT=UB2WGvqoLSVA@mail.gmail.com>
From:   Chris Murphy <lists@colorremedies.com>
Date:   Mon, 3 Feb 2020 09:17:20 -0700
Message-ID: <CAJCQCtRf8ZBmU=X-wRnbA=sdZ0-ynNUOAFHABCeN1WDVgPCw9Q@mail.gmail.com>
Subject: Re: My first attempt to use btrfs failed miserably
To:     Skibbi <skibbi@gmail.com>
Cc:     Chris Murphy <lists@colorremedies.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Sun, Feb 2, 2020 at 11:39 PM Skibbi <skibbi@gmail.com> wrote:
>
> I removed luks encryption and had the same btrfs errors after several
> GB of writes. Then I reformatted drive to ext4 and was able to save
> 60GB without hiccups. Of course, you may be right that ext4 silently
> damages my data, but at least I was able to see it on the drive after
> remount/reboot.

It could be days or months later that it shows up as a problem, if
there's no checksumming. What version of e2fsprogs? metadata_csum
became default in e2fsprogs 1.44.0.


-- 
Chris Murphy
