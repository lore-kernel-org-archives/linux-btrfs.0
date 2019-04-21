Return-Path: <SRS0=+2iJ=SX=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 55611C10F14
	for <linux-btrfs@archiver.kernel.org>; Sun, 21 Apr 2019 15:37:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 219AF20833
	for <linux-btrfs@archiver.kernel.org>; Sun, 21 Apr 2019 15:37:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="t6n63GTp"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727358AbfDUPhT (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sun, 21 Apr 2019 11:37:19 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:39152 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726786AbfDUPhT (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 21 Apr 2019 11:37:19 -0400
Received: by mail-pl1-f194.google.com with SMTP id e92so2896174plb.6;
        Sun, 21 Apr 2019 08:37:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=mlI8QJFcPhfv83Oya81t/S4/tjMubcQdCYmXmoSeWOU=;
        b=t6n63GTpGDtDk9MgNHOnsZ99FMP4dz9mcoJW57VlhcELbRXEhsIdHzA3dQZpgtfYCI
         pAj+ZOtvz/gqPsNfVQDDbEHlVccDWDcITyJx8++042vEiOZHMcUXCmd/1pW/bSc01VTn
         lCsMw1ObIAumFer+ewa+0M6Rmx9kfoHW5kG64gqwA3ouWTmYwNZ3u9FC4NoeNiB7tixa
         AsEvEBVTuNQ41N2v630qZehPSHTYDtV2cNgIJsJUbC4gHMEBxIWdHuCC/Hvr8xyV0ZRF
         JiMEeRPQT/9xky3UhALdaB9FX2p9U+s2ia+gILP4FpiW+mWCsJik/+qX7lFU3pwvehvt
         T+CA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=mlI8QJFcPhfv83Oya81t/S4/tjMubcQdCYmXmoSeWOU=;
        b=F6+T5wrWceWODQ7q9T6PwGydgGurfyE3fCbjOrbwNW5UErnVqzbKipQom63DsM64MI
         cHIkoEQG+nUJ3xcqQM0n15McN9PUrrKA3uaQ4EJpC0iKhQtQZFS/welxpXZLZy7TjE4S
         5rF2y62Q2j/Xpl5tsawL8E3s6xD0xia2ihnd4y7hsj3/l+Urb5Pu5HXt9TTi7k9vy1C2
         4RKq8AQRsHy7LmNRgtzAQSgHEaTPYGyFWmm0nJrA07SZoXrmQNWk1hr1FOcvjAYvvO6L
         YdX3mhusH4nUsT0tEeE7hbOJck7u3w1wzYYsqeyijv87BLJbuQSfM0ujEbsT8PMydsyC
         Dolg==
X-Gm-Message-State: APjAAAXzDq/PZMnoRUmCfhLCejX10Ts0lLE4CSCtFwyT3BlNIng90eXB
        6+xy6TXuHOe/RKA4oP5hqMc=
X-Google-Smtp-Source: APXvYqwjHt1UpkalwgpbPxmQSMDGTmeDA2zQpqvk7F41YjkmMuAo05Q6xo6T0JCGn1KUuFls+KnH7w==
X-Received: by 2002:a17:902:2927:: with SMTP id g36mr14700970plb.6.1555861038341;
        Sun, 21 Apr 2019 08:37:18 -0700 (PDT)
Received: from localhost ([128.199.137.77])
        by smtp.gmail.com with ESMTPSA id p3sm13618808pfn.167.2019.04.21.08.37.16
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Sun, 21 Apr 2019 08:37:17 -0700 (PDT)
Date:   Sun, 21 Apr 2019 23:37:05 +0800
From:   Eryu Guan <guaneryu@gmail.com>
To:     Filipe Manana <fdmanana@kernel.org>
Cc:     fstests <fstests@vger.kernel.org>,
        linux-btrfs <linux-btrfs@vger.kernel.org>,
        Filipe Manana <fdmanana@suse.com>
Subject: Re: [PATCH] btrfs: test send with deduplication running concurrently
Message-ID: <20190421153705.GD22372@desktop>
References: <20190415083121.2338-1-fdmanana@kernel.org>
 <CAL3q7H6j_TM+J9o9hc=oxDO+pFzQmur5ignSA3xgiUN4LoZx8Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAL3q7H6j_TM+J9o9hc=oxDO+pFzQmur5ignSA3xgiUN4LoZx8Q@mail.gmail.com>
User-Agent: Mutt/1.11.3 (2019-02-01)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Sat, Apr 20, 2019 at 02:14:25PM +0000, Filipe Manana wrote:
> On Mon, Apr 15, 2019 at 9:32 AM <fdmanana@kernel.org> wrote:
> >
> > From: Filipe Manana <fdmanana@suse.com>
> >
> > Stress send running in parallel with deduplication against files that
> > belong to the snapshots used by send. The goal is to hit assertion failures
> > and BUG_ONs when send is running, or send finding an inconsistent snapshot
> > that leads to a failure (reported in dmesg/syslog) and results in an EIO
> > error returned to user space. The test needs big trees (snapshots) with
> > large differences between the parent and send snapshots in order to hit
> > such issues with a good probability.
> >
> > This currently fails in btrfs, and there is a patch for the linux kernel
> > that fixes it and is titled:
> >
> >   "Btrfs: fix race between send and deduplication that lead to failures
> >    and crashes"
> >
> > Signed-off-by: Filipe Manana <fdmanana@suse.com>
> 
> Eryu, can you please skip this patch for now? I want to do a v2,
> likely next week, which tests a few more things.
> Thanks.

Sure, thanks for the heads-up!

Eryu
