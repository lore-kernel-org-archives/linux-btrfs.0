Return-Path: <SRS0=6ZPf=QL=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 371C1C282C4
	for <linux-btrfs@archiver.kernel.org>; Mon,  4 Feb 2019 22:19:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EB7F62082E
	for <linux-btrfs@archiver.kernel.org>; Mon,  4 Feb 2019 22:19:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="l4GF7tsF"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727248AbfBDWT0 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 4 Feb 2019 17:19:26 -0500
Received: from mail-qt1-f195.google.com ([209.85.160.195]:38889 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727119AbfBDWT0 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 4 Feb 2019 17:19:26 -0500
Received: by mail-qt1-f195.google.com with SMTP id 2so1810166qtb.5
        for <linux-btrfs@vger.kernel.org>; Mon, 04 Feb 2019 14:19:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=A/tUMaoW+F4RscmwKOekZgFE16j8DDGOfAw5dtSrR60=;
        b=l4GF7tsF/URX7tASYpbIGIeSks9LFB7GsUZQCY7jJr+8LosuXX0jZf5OV/MSvngIvz
         0mfTd6vocqew9rafXCJmB5K5+oJNI3oiJ+DQtrZpGPOBtMtTbCoXaN/R9dZlksXwwVI+
         bu5jVZOn99F7sUVTtTNs2E20zKG4umWvYTKBh44VEoKa85wHGA0RlB0sKEgUwnBXrR7O
         o2Vlx5v1RXYP+y6pmfMWppn9yaHcTT5ab6xNL2lHFQTCuSMNAqltSzOkOraN+w5+1at2
         kDrvYQC1PSqCv43alzkMrvX5DVtFjzlw+4/DFUE5ToijFkaE90oGQZXFd4nYXq7t+tHp
         ec0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=A/tUMaoW+F4RscmwKOekZgFE16j8DDGOfAw5dtSrR60=;
        b=e49d6kv3XrtRs2R/0V7Hd350MjIglgn+8be9Pa+1zpq88ZD4XCasxVA+4FqSAxmdSr
         Y6zUtnEA1GZmizLkX7YvQ3+GqSfLLdt0h4RGT2PLQzRGPJtZyFD5dfEjcU3UaMnRyJky
         AK8C0DhmyonHYANrOzE43nTVeBE9UFhNFl0jeA56P9EZ+/HS0Dlu9C8MvJIWdPh5pLLc
         E5l5xMCCDpeyva3bIakfUwXpkh/XDuw8RsgY5gRjT5kgKrvbOtJOj+VBhIrBPkgLIZq2
         oiOZ4TDSW2KzuwItZcTgpGNYvfaiCcT8+6f/3Va2sUs8Aqj19ZDI5QnV3XY7H/GoZGXK
         fpMg==
X-Gm-Message-State: AHQUAuYIA8DaRhgnDcTKUgAdnJBg+rGojto/wETJ6guUKMj1EMdGxuip
        Ywj7S/u2xhfWKg5uLy2Wf3smr0guJ5XaGmmWKrY=
X-Google-Smtp-Source: AHgI3IYoqydPZONlUAOE//ccxJLhffbPgT4vPEV6FORhD8SJk26HdhY1ndEqywPjpYwYI1JI8ZibkQH9fM3d3lLO8MA=
X-Received: by 2002:ac8:1490:: with SMTP id l16mr1292432qtj.222.1549318765214;
 Mon, 04 Feb 2019 14:19:25 -0800 (PST)
MIME-Version: 1.0
References: <33679024.u47WPbL97D@t460-skr> <CAJCQCtR=WZGk4eaG63_-uqb0wzGVDDrS1SsxhzxT7k3qbWVtCg@mail.gmail.com>
 <CAA7pwKN9B7LZEo7Op0PndTnU6jo3JdtLi0vdphXZakgbKBB-9w@mail.gmail.com> <b879a985-c991-b4b3-590e-d2aa1a5fa5c5@gmail.com>
In-Reply-To: <b879a985-c991-b4b3-590e-d2aa1a5fa5c5@gmail.com>
From:   Patrik Lundquist <patrik.lundquist@gmail.com>
Date:   Mon, 4 Feb 2019 23:19:13 +0100
Message-ID: <CAA7pwKOXcsh__Cw0WBLW8g1LA239kmcyWcDmz6ksZ+Tbu1NK-Q@mail.gmail.com>
Subject: Re: btrfs as / filesystem in RAID1
To:     "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Cc:     Chris Murphy <lists@colorremedies.com>,
        Stefan K <shadow_7@gmx.net>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Mon, 4 Feb 2019 at 18:55, Austin S. Hemmelgarn <ahferroin7@gmail.com> wrote:
>
> On 2019-02-04 12:47, Patrik Lundquist wrote:
> > On Sun, 3 Feb 2019 at 01:24, Chris Murphy <lists@colorremedies.com> wrote:
> >>
> >> 1. At least with raid1/10, a particular device can only be mounted
> >> rw,degraded one time and from then on it fails, and can only be ro
> >> mounted. There are patches for this but I don't think they've been
> >> merged still.
> >
> > That should be fixed since Linux 4.14.
> >
>
> Did the patches that fixed chunk generation land too?  Last I knew, 4.14
> had the patch that fixed mounting volumes that had this particular
> issue, but not the patches that prevented a writable degraded mount from
> producing the issue on-disk in the first place.

A very good question and at least 4.19.12 creates single chunks
instead of raid1 chunks if I rip out one disk of two in a raid1 setup
and mount it degraded. So a balance from single chunks to raid1 chunks
is still needed after the failed device has been replaced.
