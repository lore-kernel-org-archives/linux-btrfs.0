Return-Path: <SRS0=fkam=SH=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 57C97C4360F
	for <linux-btrfs@archiver.kernel.org>; Fri,  5 Apr 2019 06:39:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 12AA6217D4
	for <linux-btrfs@archiver.kernel.org>; Fri,  5 Apr 2019 06:39:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=colorremedies-com.20150623.gappssmtp.com header.i=@colorremedies-com.20150623.gappssmtp.com header.b="yd3G1QCM"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726629AbfDEGjX (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 5 Apr 2019 02:39:23 -0400
Received: from mail-lf1-f49.google.com ([209.85.167.49]:44891 "EHLO
        mail-lf1-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725955AbfDEGjW (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 5 Apr 2019 02:39:22 -0400
Received: by mail-lf1-f49.google.com with SMTP id v71so3526534lfa.11
        for <linux-btrfs@vger.kernel.org>; Thu, 04 Apr 2019 23:39:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=colorremedies-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=uQTyLNdt+jFUdpiFmpTFImSRhKWsxMZ69R8qixBUx6E=;
        b=yd3G1QCMwBg3uIO3BtTUVmga6Vabo+nNTK0jCLFFOUHouNv68E793+VctXxprORJt1
         LmqMiTVSHVj0lK9nGQ9N7voCYcLB1BZZ3FjpRqnZl3TUCPQ/aLlurBgA3j0NfGsDV0P2
         wnWcM7djKejyGoOB4gJUz4wTusjjgpjnoUFHzcZyPXkwYbx0QKK1/JuedU7RTyBFsmhT
         3bcAIFeSHKVwz27x+R19H4aC3o6w3zGkCvOliX3+kTH/B7Rjh2EozQPCSsSVGNqsVdcJ
         nrhb7XhQjOGi3fbWNG2WQ5yT8yl4b1sbmI4Xv2wseSne0N4iztp1e4wIl5r4sKmstkWM
         NZDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=uQTyLNdt+jFUdpiFmpTFImSRhKWsxMZ69R8qixBUx6E=;
        b=UnOFTekC8YjpUiq/lJc8CaeCxJVqvR2krpzweuWFVmunhz+mcIq09p792UTJoG2nE6
         Nf5mplzqCbRSYNQyzRAVhlsWrv9ybgQHABGNdgm+oYFkU50EW1cMV5zQyE6rhA3PyRAh
         GW8n1TKyAhv8TvTCFaVkyXzBLjJ2GXfwSAAZUhzfCKZooDjMtsAGtU3ti211WuTlzMLK
         hLNcjZCyqglLAHtdFDPxyWzBZ21O/qxXKXit7pL5a4x2nXOhtxnxEj85XCp/RKV/xb8p
         64vWDQIAEswDluApov8mv9RiHcnK9CJxtAG5tDKtBHguLeHixItzoa3Ty5eL5CzXomN1
         isgA==
X-Gm-Message-State: APjAAAW3M5w6/86L9zt3ncnq2pOEp+fNtO14TO8BEoUe8vyO2PMEVK9I
        YPOjDe7Fm7ompeOZt36zNzYV2xVX6UVbMrqhR7Toaa35GQI=
X-Google-Smtp-Source: APXvYqyJMf4fjAFSMIR+pEL9AWEXue7f36hBEHQ4Z80l5i3MyghOP160KMwZg0CjlRFUsNrLrcTaXpbNQpv2Oradlt8=
X-Received: by 2002:a19:7007:: with SMTP id h7mr5832206lfc.23.1554446360657;
 Thu, 04 Apr 2019 23:39:20 -0700 (PDT)
MIME-Version: 1.0
References: <CALsQ4_zf0GC31eqgSLXnmxbvB-J9WnqfT0Qdd3+8q5HKS3EFJg@mail.gmail.com>
 <CAJCQCtRbRc-KDwrprBY1O3gczydCBujd9qsM5b4+5zTLmnr82A@mail.gmail.com>
 <CALsQ4_x-VViOA5Cu4vJTqmx3xSospmiEdsEcDDBcj=uvZUmrVQ@mail.gmail.com>
 <CAJCQCtSA=f+XWy8KzpzGdpjyaBsDOT5G+aC5FU9G2Fyi-sMvrQ@mail.gmail.com> <CALsQ4_zTUdFCTunnu5NVpAu1-kP0y319szRHdqbnKG8--2-xEQ@mail.gmail.com>
In-Reply-To: <CALsQ4_zTUdFCTunnu5NVpAu1-kP0y319szRHdqbnKG8--2-xEQ@mail.gmail.com>
From:   Chris Murphy <lists@colorremedies.com>
Date:   Fri, 5 Apr 2019 00:39:09 -0600
Message-ID: <CAJCQCtRv2gnTtAm02jsbeiKpX-s8W8BO9SdA5topJ92op_C_hw@mail.gmail.com>
Subject: Re: btrfs balance hangs
To:     Zirconium Hacker <jared.e.vb@gmail.com>
Cc:     Btrfs BTRFS <linux-btrfs@vger.kernel.org>,
        Qu Wenruo <quwenruo.btrfs@gmx.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Thu, Apr 4, 2019 at 11:24 PM Zirconium Hacker <jared.e.vb@gmail.com> wrote:
>
> I've actually had a check running for the past 10 hours or so.
> It got far enough, so I stopped it.  The output is attached.

What do you get for:

# btrfs insp dump-s -f /dev/
# btrfs insp dump-t -b 2629033574400 /dev/

The csum test doesn't complain so that suggests any corruption happens
before csum is calculated and written. It could be a bug, however we
also have a wanted transid that is lower than what's found (finds a
transid in the future). That's a bug no matter what, either the drive
firmware has some bug or Btrfs, and I would expect the firmware can't
be responsible for such a huge transid difference. But yeah maybe Qu
has an idea, also he knows about qgroups, I don't know anything about
them other than it can make things very slow. There are some fixes on
the way soon but it doesn't really help today.


-- 
Chris Murphy
