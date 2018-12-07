Return-Path: <SRS0=lg0L=OQ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.5 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_PASS,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1C438C04EB8
	for <linux-btrfs@archiver.kernel.org>; Fri,  7 Dec 2018 01:02:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CB011208E7
	for <linux-btrfs@archiver.kernel.org>; Fri,  7 Dec 2018 01:02:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=osandov-com.20150623.gappssmtp.com header.i=@osandov-com.20150623.gappssmtp.com header.b="QVfrVqS6"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org CB011208E7
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=osandov.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725950AbeLGBCU (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 6 Dec 2018 20:02:20 -0500
Received: from mail-it1-f193.google.com ([209.85.166.193]:53371 "EHLO
        mail-it1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725939AbeLGBCU (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 6 Dec 2018 20:02:20 -0500
Received: by mail-it1-f193.google.com with SMTP id g85so4514399ita.3
        for <linux-btrfs@vger.kernel.org>; Thu, 06 Dec 2018 17:02:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=osandov-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=i3804pnNzGJFLtiFQyvkhWehxN9FVvh0rd1R8GVsMgo=;
        b=QVfrVqS6JC0lon+L830kPPyi3pHalx3mQIVEgNjS/xO7RZrqHnCJEta3un48lEPKWp
         0F6OZw9rYSQ3AozJ0uBY5a9C336Ohmkc6z1ZZsemNVJSTUfTjWOJd0ei/vOd8sApyosy
         2TUb4RS7UYDTkIH1cbB/iBS6Q2SKXREObB3Qz6d+4eZsWppGJ9cAbE2O/yYwvaAyzB/b
         yJ1bRiTb34XZAYRjh2Lhwfy0+Ysf+E8MdJpCFbMHOUBT3Zpeb88a9Xpt5mKen4HfRBer
         VqVs/LvO13MEgvhNMOVAIPlVjbIAhZfNo5rAngYiZmGnEnDrcRVcCZENeJ/+DIvnl3R6
         f5gQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=i3804pnNzGJFLtiFQyvkhWehxN9FVvh0rd1R8GVsMgo=;
        b=oO2dnUe2mU54wZDZTGQ4uc6ASj2XLw0xiQfHKhZBpl/FnBDV1z6b0u+Jqx31UdYvTU
         QufjIlFwZY+SHpjaKWpHYq32+p1W5IW9WprKK8G+FCVZrsV2nH12Cf/lTXyBSLdWmPp8
         er6bp4szyqQvBHls2gwCMXh0f343wM2S2aDbH3hYWRMyMFO86JOhhOluOnopCobH+YLy
         FpesVGA9pZK4u7C4CHD4VDnVoo0dZiNhJdq+EL6datHItC63piJgXtlu6ANw6daoH/ht
         mMsJRfmavAV574GdeEzaARKodtDT62B+CPkPX4gFgwmXZAupxD76FoLjEtADTFp6BvYn
         FVlw==
X-Gm-Message-State: AA+aEWa5m5Ba5OJKzPui/qbOQFsHpDEYI7vacoTUxP942LHeqV55WIif
        +YfjlqWbY4Ssjri47A/ACMku4OAYhd8=
X-Google-Smtp-Source: AFSGD/WUWjvqvfsh+Tc2ry1YPUR1U7pn0gk8TewN3GLVE2u8+cie2v3XGdZkZ1Xv2a7zmb+C51KazA==
X-Received: by 2002:a05:660c:81a:: with SMTP id j26mr563970itk.70.1544144538426;
        Thu, 06 Dec 2018 17:02:18 -0800 (PST)
Received: from vader ([2620:10d:c090:200::5:7ead])
        by smtp.gmail.com with ESMTPSA id w12sm917627ior.34.2018.12.06.17.02.17
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 06 Dec 2018 17:02:17 -0800 (PST)
Date:   Thu, 6 Dec 2018 17:02:16 -0800
From:   Omar Sandoval <osandov@osandov.com>
To:     Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH RESEND 0/8] btrfs-progs: sub: Relax the privileges of
 "subvolume list/show"
Message-ID: <20181207010216.GH11220@vader>
References: <cover.1543294426.git.misono.tomohiro@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1543294426.git.misono.tomohiro@jp.fujitsu.com>
User-Agent: Mutt/1.11.0 (2018-11-25)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Tue, Nov 27, 2018 at 02:24:41PM +0900, Misono Tomohiro wrote:
> Hello,
> 
> This is basically the resend of 
>   "[PATCH v2 00/20] btrfs-progs: Rework of "subvolume list/show" and relax the
> 	root privileges of them" [1]
> which I submitted in June. The aim of this series is to allow non-privileged user
> to use basic subvolume functionality (create/list/snapshot/delete; this allows "list")
> 
> They were once in devel branch with some whitespace/comment modification by david.
> I rebased them to current devel branch.
> 
> github: https://github.com/t-msn/btrfs-progs/tree/rework-sub-list
> 
> Basic logic/code is the same as before. Some differences are:
>  - Use latest libbtrfsutil from Omar [2] (thus drop first part of patches).
>    As a result, "sub list" cannot accept an ordinary directry to be
>    specified (which is allowed in previous version)
>  - Drop patches which add new options to "sub list"
>  - Use 'nobody' as non-privileged test user just like libbtrfsutil test
>  - Update comments
> 
> Importantly, in order to make output consistent for both root and non-privileged
> user, this changes the behavior of "subvolume list": 
>  - (default) Only list in subvolume under the specified path.
>    Path needs to be a subvolume.
>  - (-a) filter is dropped. i.e. its output is the same as the
>         default behavior of "sub list" in progs <= 4.19
> 
> Therefore, existent scripts may need to update to add -a option
> (I believe nobody uses current -a option).
> If anyone thinks this is not good, please let me know.

I think there are a few options in the case that the path isn't a
subvolume:

1. List all subvolumes in the filesystem with randomly mangled paths,
   which is what we currently do.
2. Error out, which is what this version of the series does.
3. List all subvolumes under the containing subvolume, which is what the
   previous version does.
4. List all subvolumes under the containing subvolume that are
   underneath the given path.

Option 1 won't work well for unprivileged users. Option 2 (this series)
is definitely going to break people's workflows/scripts. Option 3 is
unintuitive. In my opinion, option 4 is the nicest, but it may also
break scripts that expect all subvolumes to be printed.

There's also an option 5, which is to keep the behavior the same for
root (like what my previous patch [1] did) and implement option 4 for
unprivileged users.

I think 4 and 5 are the two main choices: do we want to preserve
backwards compatibility as carefully as possible (at the cost of
consistency), or do we want to risk it and improve the interface?

1: https://github.com/osandov/btrfs-progs/commit/fb61c21aeb998b12c1d02532639083d7f40c41e0
