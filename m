Return-Path: <SRS0=X8W1=NL=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6DEFBC0044C
	for <linux-btrfs@archiver.kernel.org>; Wed, 31 Oct 2018 16:37:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3507920664
	for <linux-btrfs@archiver.kernel.org>; Wed, 31 Oct 2018 16:37:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=osandov-com.20150623.gappssmtp.com header.i=@osandov-com.20150623.gappssmtp.com header.b="YdFcHjhG"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3507920664
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=osandov.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729846AbeKABgX (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 31 Oct 2018 21:36:23 -0400
Received: from mail-pl1-f195.google.com ([209.85.214.195]:34894 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729341AbeKABgX (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 31 Oct 2018 21:36:23 -0400
Received: by mail-pl1-f195.google.com with SMTP id n4-v6so6975058plp.2
        for <linux-btrfs@vger.kernel.org>; Wed, 31 Oct 2018 09:37:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=osandov-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=Nb7I4Eu3aEcmn5lJ4g97xeo5eMiagCxSJ5+jfxPO2I4=;
        b=YdFcHjhGjNmZ6CJ6jNXyaoEkBC/fPYlSVuPukkYcXpeOVu5A803/eN3+Bpf7GWJDVL
         cOFz+5M9PRdf+rGTkaAlcoD6RCk6luAGjERgA9q8TsOY8UPnFMTROXZpJ+cyabb4jjVH
         URSKLv7ofbHedrcMTABOlEis6dZ6PE+LMlcMYE/IRLaB2WmIgTOXpVMjGqAGIMp/ap3h
         tQ6RTvZO6o1ognLkUJVK2uLmjM5cZeDp02+denc1ELNggcbRiS9lD2VpKRgkZz2x1LXa
         g8R4lExC+mf+IEETurQflp6bIp0XJrjV3ydxVhBbNEJOfv+sFpTzHATZTYqbRGDrMFc1
         rkCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=Nb7I4Eu3aEcmn5lJ4g97xeo5eMiagCxSJ5+jfxPO2I4=;
        b=m+OnER25wHL3aSeIk3jvJCsh8K/4bDB5NjCQINU+/26/uiFYz5ODL6MND5K9k+a4fx
         QEfyeR1uvl8YSb63goB3ybRoufhw0CkrSYEwpahP+HWVyDuvBGngKhg8hn78ys9/Icsu
         sDFE07Yxax696KK9ccrJZtTqGkgIfazG8R6asH+ALU7vSoy1KY4QNjLblwkWZy4Btu6u
         beenEU6odM2M8S9yY1fZIb4Bpsmngy1wc4aYDwzH+yh1uBi/hk+V7njxIO4GwYIdHOYE
         I6EuBpsfa3nRE65CsnBPQ+0eavhF8qTOX6V+i2u8b/MTAkB54afQJqqPG9buI297/0JL
         5Jbw==
X-Gm-Message-State: AGRZ1gIEHo2TCUVdkzhvWTzLPHjcR3Dif1SoQhHUnL7tKaC5xS/wSSgc
        IrGxDhCNRvx6ofMMLwcHxO/5iS6nNmE=
X-Google-Smtp-Source: AJdET5fPiiRHECEyWsoNnXXUxU6LenWXp5/u6+TCfDHomadWeKCnNjMx3mKDG0Z2pNvcevPwf+DLDQ==
X-Received: by 2002:a17:902:aa8d:: with SMTP id d13-v6mr4221411plr.74.1541003857677;
        Wed, 31 Oct 2018 09:37:37 -0700 (PDT)
Received: from vader ([2620:10d:c090:180::1:deee])
        by smtp.gmail.com with ESMTPSA id 27-v6sm36248376pfm.36.2018.10.31.09.37.36
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 31 Oct 2018 09:37:37 -0700 (PDT)
Date:   Wed, 31 Oct 2018 09:37:35 -0700
From:   Omar Sandoval <osandov@osandov.com>
To:     Lu Fengqi <lufq.fnst@cn.fujitsu.com>
Cc:     linux-btrfs@vger.kernel.org, kernel-team@fb.com
Subject: Re: [PATCH] Btrfs: fix missing delayed iputs on unmount
Message-ID: <20181031163735.GB8563@vader>
References: <9b8c7d1ce662d216cf29ffcb756d177b0bf60b64.1540944854.git.osandov@fb.com>
 <20181031074147.GB2656@fnst.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181031074147.GB2656@fnst.localdomain>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Wed, Oct 31, 2018 at 03:41:47PM +0800, Lu Fengqi wrote:
> On Tue, Oct 30, 2018 at 05:14:42PM -0700, Omar Sandoval wrote:
> >From: Omar Sandoval <osandov@fb.com>
> >
> >There's a race between close_ctree() and cleaner_kthread().
> >close_ctree() sets btrfs_fs_closing(), and the cleaner stops when it
> >sees it set, but this is racy; the cleaner might have already checked
> >the bit and could be cleaning stuff. In particular, if it deletes unused
> >block groups, it will create delayed iputs for the free space cache
> >inodes. As of "btrfs: don't run delayed_iputs in commit", we're no
> >longer running delayed iputs after a commit. Therefore, if the cleaner
> >creates more delayed iputs after delayed iputs are run in
> >btrfs_commit_super(), we will leak inodes on unmount and get a busy
> 
> Since the assert added via commit e187831e1875 ("btrfs: assert on non-empty
> delayed iputs") wasn't triggered, it doesn't seem to be the cause of inode
> leak.

This was in our production build without CONFIG_BTRFS_ASSERT.
