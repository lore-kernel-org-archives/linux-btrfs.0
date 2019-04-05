Return-Path: <SRS0=fkam=SH=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 57391C10F0F
	for <linux-btrfs@archiver.kernel.org>; Fri,  5 Apr 2019 03:04:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1AA4D217D9
	for <linux-btrfs@archiver.kernel.org>; Fri,  5 Apr 2019 03:04:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=colorremedies-com.20150623.gappssmtp.com header.i=@colorremedies-com.20150623.gappssmtp.com header.b="vtCkJI8q"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729635AbfDEDEg (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 4 Apr 2019 23:04:36 -0400
Received: from mail-lj1-f174.google.com ([209.85.208.174]:35466 "EHLO
        mail-lj1-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727051AbfDEDEf (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 4 Apr 2019 23:04:35 -0400
Received: by mail-lj1-f174.google.com with SMTP id t4so3925368ljc.2
        for <linux-btrfs@vger.kernel.org>; Thu, 04 Apr 2019 20:04:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=colorremedies-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=q+K+ErqzaOqAygquobVGRWCFwDA1lh0NafFnZZuJDMY=;
        b=vtCkJI8qCjI1PjLyz2frKY+FisXdsjPduqYgl7IE7o5OGX9XrL2wh13tHKTGnzvFTR
         FjJxcmsh+ErjOs6W+QvFext5T85KUZl5pSvzPDU+Dh2Zz+LGMrmeRIFc6lPQ3CmlbkKe
         RZt1ecPC4Ss86ZJYF5nnoHBiZweDxFxrWeixf+oY3cgIulWkN2h6hsHl2VRLWJHvL02K
         d3HJI6dTw6FpeUQS+BR8E2jdbscFBkC7fMBelSfJ0k/WkGMw4kWjgjXNE+bDRUfy/x72
         Fg0ja01kRw7FGAHhm6SmfLGrgUkpSujPvGywCssuT+PKqiMGn/dwSArLwQMGDxwyeAfo
         7/mw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=q+K+ErqzaOqAygquobVGRWCFwDA1lh0NafFnZZuJDMY=;
        b=bfO79Kq/SpDlVjyBdaSSOEVJCaW48k810scGB9kj/MPhH2AfTu5xNV8ERkmBZ5sCmF
         C2mofT4hk7BtInHTOj836MwrcYcjFFgeJ2WnmZevCeURSgbzDZegkQHUgM44mDak5eAV
         Bow1nlf2sto1f89m8gOwcfxhW6NJJ+gtBWq6KbMKXH1SJpr/XfFbu9eL2j6g3/fcSBeM
         y7uoUWSOX95C5EaoG51/8Fy5XbyEyJtx/v0XwUDbvFSoCn+hXutyc0GHvqXfYUVbSSWE
         nycsvtCGIMbckvqz45FwVHXxFCMUdURu5wSBmVpBDJVY/IYBLz+ZoGrI13ue+yp5Sxto
         RaTg==
X-Gm-Message-State: APjAAAWLrEWR5+4/NGZPokPne7I73h4c0X/hqoEOTYHL8B7pHf94EPOu
        AuDmcitNecnUsFPivi9xn2OSMn3dOmp5hiOJOJ3HWSs1e2A=
X-Google-Smtp-Source: APXvYqz1orqU/mIVtaOE15Aon7WBqaFA69jiLgDVQUl0ikORFI2BAf0KG9MgAkSbnQgMzWbkRIeBvYRacm9hR65n46Y=
X-Received: by 2002:a2e:7e0f:: with SMTP id z15mr5476250ljc.122.1554433473292;
 Thu, 04 Apr 2019 20:04:33 -0700 (PDT)
MIME-Version: 1.0
References: <CALsQ4_zf0GC31eqgSLXnmxbvB-J9WnqfT0Qdd3+8q5HKS3EFJg@mail.gmail.com>
 <CAJCQCtRbRc-KDwrprBY1O3gczydCBujd9qsM5b4+5zTLmnr82A@mail.gmail.com> <CALsQ4_x-VViOA5Cu4vJTqmx3xSospmiEdsEcDDBcj=uvZUmrVQ@mail.gmail.com>
In-Reply-To: <CALsQ4_x-VViOA5Cu4vJTqmx3xSospmiEdsEcDDBcj=uvZUmrVQ@mail.gmail.com>
From:   Chris Murphy <lists@colorremedies.com>
Date:   Thu, 4 Apr 2019 21:04:21 -0600
Message-ID: <CAJCQCtSA=f+XWy8KzpzGdpjyaBsDOT5G+aC5FU9G2Fyi-sMvrQ@mail.gmail.com>
Subject: Re: btrfs balance hangs
To:     Zirconium Hacker <jared.e.vb@gmail.com>
Cc:     Btrfs BTRFS <linux-btrfs@vger.kernel.org>,
        Qu Wenruo <quwenruo.btrfs@gmx.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Thu, Apr 4, 2019 at 12:18 PM Zirconium Hacker <jared.e.vb@gmail.com> wrote:
>
> Yes, I have qgroups enabled on that filesystem.  I'll disable qgroups
> the next chance I get, they aren't worth the trouble.
>
> After rebooting, BTRFS finished the balance.  I then foolishly started
> a selective metadata balance, which never got past the first block
> group; it just thrashed the disk for several hours.
> It could not be canceled, so I rebooted.
>
> Then I mounted the filesystem with skip_balance and clear_cache.
> The mount failed.  The relevant part of dmesg is attached.

I can't parse that, maybe Qu has an idea. In the meantime I suggest
btrfs-progs 4.20.2 and running:

# btrfs check --readonly /dev/

Attach that output.

Balance is supposed to be COW. And skip_balance and clear_cache are
supposed to be safe. So I'd say you've found a bug but I don't know
what it is or how to work around it.

-- 
Chris Murphy
