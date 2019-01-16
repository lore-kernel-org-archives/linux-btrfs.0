Return-Path: <SRS0=HC3m=PY=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_PASS,USER_AGENT_NEOMUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 212BFC43387
	for <linux-btrfs@archiver.kernel.org>; Wed, 16 Jan 2019 01:16:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D8E9120657
	for <linux-btrfs@archiver.kernel.org>; Wed, 16 Jan 2019 01:16:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20150623.gappssmtp.com header.i=@toxicpanda-com.20150623.gappssmtp.com header.b="dRno8YIW"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727194AbfAPBQB (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 15 Jan 2019 20:16:01 -0500
Received: from mail-yb1-f196.google.com ([209.85.219.196]:43652 "EHLO
        mail-yb1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727190AbfAPBQB (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 15 Jan 2019 20:16:01 -0500
Received: by mail-yb1-f196.google.com with SMTP id t16so1848979ybk.10
        for <linux-btrfs@vger.kernel.org>; Tue, 15 Jan 2019 17:16:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to
         :user-agent;
        bh=BE36yF8+YvaIjI8Plx6A11VXYNXZy9AAacHz5ZAcxok=;
        b=dRno8YIWZz5yi/5VpTp2S0PaBG9DGd1iT4v4SnOCn48EE9LXCwGOjXNiLuvtWVOOAG
         Cpu8FwxyjkYDnV0Ltco0nyD0KEuYpYmbfUAwCFbAdnauGX/s/cPU4FqvfoCoQuuNmOVS
         tNsubPKtgE/i37TVcEV/eseMICFSrKfDUWAYMCddXNla6vUdQFbDO9E18HXtLsjkpWVp
         iex5jYKR0//m5WHdx9MnxdCg04+CD97kmzdUTEmDKyHV780r11CT9UmN3fXtIcVjv2yv
         RHQAFq1XkIb+ShgU0tvbaznX51oXU7M0qEYPW5aF4wAusVKdR0V2KTQcEvwlULNHCo1z
         bpBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=BE36yF8+YvaIjI8Plx6A11VXYNXZy9AAacHz5ZAcxok=;
        b=skUvmHbUvY+l3No4iwCtHaIvfniDRn1Hirj2fmWsVVpDbt8jPgGfE6d1zi68EHTnOi
         FXD/Ez8JAXozqI2N/C1rdOsYeApjva8YA6DdEoHlIkurArGzLErHV6AAd5KEcdwt/mAr
         Ap4Kd8N182F2fkj6lFGYVrQLd/G0LzN5xPZQS3IkOPwQGiiOh/xpxN5YUMm0dDCmdSWo
         YxdZJGk4dahsy2XjnQ2o8gu4ESvfXmMRk/TyVHnS60uzxbhrCVNVhqB0LM4QDx21r7nv
         RqnUBtbLz30/eQpShdQWsAtNwFyGq2RNhetVGemRjyHYyCqupXKVa2HcR0ZLpD7w1UM8
         APQw==
X-Gm-Message-State: AJcUukdGJGC1WWrBYb1qsmucjlds4roURfARPvZRkt+LPraeVJcuYdQ/
        bTP5XaBo16Uezy2NwMZTOIIfDw==
X-Google-Smtp-Source: ALg8bN4nWC19prjsLpYfkSK3E6UxFoFHzByBuYkhioJfniXj5p0WwVJRIdEyD5AoiZDWo2LcfOoE3w==
X-Received: by 2002:a25:d4d5:: with SMTP id m204mr5425894ybf.364.1547601359993;
        Tue, 15 Jan 2019 17:15:59 -0800 (PST)
Received: from localhost ([2620:10d:c091:180::1:e59b])
        by smtp.gmail.com with ESMTPSA id w2sm3327841ywl.10.2019.01.15.17.15.58
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 15 Jan 2019 17:15:59 -0800 (PST)
Date:   Tue, 15 Jan 2019 20:15:58 -0500
From:   Josef Bacik <josef@toxicpanda.com>
To:     Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc:     Qu Wenruo <wqu@suse.de>, Josef Bacik <josef@toxicpanda.com>,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v4 0/7] btrfs: qgroup: Delay subtree scan to reduce
 overhead
Message-ID: <20190116011556.5qzmvu5m7ub6fm7m@macbook-pro-91.dhcp.thefacebook.com>
References: <20190115081604.785-1-wqu@suse.com>
 <20190115172625.pgblt26vzmdnsv5w@macbook-pro-91.dhcp.thefacebook.com>
 <40fa6d23-00e0-666e-60f5-1505e157aacc@suse.de>
 <adf8aa97-2638-26f7-1cb2-813ef5a342c9@gmx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <adf8aa97-2638-26f7-1cb2-813ef5a342c9@gmx.com>
User-Agent: NeoMutt/20180716
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Wed, Jan 16, 2019 at 09:07:26AM +0800, Qu Wenruo wrote:
> 
> 
> On 2019/1/16 上午8:31, Qu Wenruo wrote:
> > 
> > 
> > On 2019/1/16 上午1:26, Josef Bacik wrote:
> >> On Tue, Jan 15, 2019 at 04:15:57PM +0800, Qu Wenruo wrote:
> >>> This patchset can be fetched from github:
> >>> https://github.com/adam900710/linux/tree/qgroup_delayed_subtree
> >>>
> >>> Which is based on v5.0-rc1.
> >>>
> >>
> >> I've been testing these patches hoping to get rid of the qgroup deadlock that
> >> these patches are supposed to fix, but instead they make the box completely
> >> unusable with 100% cpu usage for minutes at a time at every transaction commit.
> > 
> > I'm afraid it's related to the v5.0-rc1 base, not the patchset itself.
> > 
> > Just try to balance metadata with 16 snapshots, you'll see btrfs bumping
> > its generation like crazy, no matter if quota is enabled or not.
> > 
> > And since btrfs is committing transaction like crazy, no wonder it will
> > do tons of qgroup accounting.
> > 
> > My bisect leads to commit 64403612b73a94bc7b02cf8ca126e3b8ced6e921
> > btrfs: rework btrfs_check_space_for_delayed_refs.
> 
> Furthermore, you could try this RFC test case to see the problem.
> https://patchwork.kernel.org/patch/10761715/
> 
> It would only take around 100s for v4.20 but over 500 for v5.0-rc1 with
> tons of unnecessary transaction committed for nothing, no quota enabled.
> 
> So I'm afraid that commit is blocking my qgroup patchset.
> 

I've fixed the balance problem, it took 2 seconds to figure out, I'm just
waiting on xfstests to finish running.

And your patch making things worse has nothing to do with that problem.  Our
test doesn't run balance, so the issue you reported has nothing to do with the
fact that your patch makes our boxes unusable with qgroups on.

The problem is with your deadlock avoidence patch we're now making a lot more
dirty extents to run in the critical section of the transaction commit.  Also
because we're no longer pre-fetching the old roots, we're doing the old roots
and new roots lookup inside the critical section, so now each dirty extent takes
2x as long.  With my basic test it was taking 5 minutes to do the qgroup
accounting, which keeps the box from booting essentially.

Without your patch it's still awful because btrfs-cleaner just sits there at
100% while deleting snapshots, but at least it's not making the whole system
stop running while it does all that work in the transaction commit.

And if you had done the proper root cause analysis you would have noticed that
we're taking tree locks in the find_parent_nodes() case when we're searching the
commit root, something we shouldn't be doing.  So all that really needs to be
done is to check if (!path->skip_locking) btrfs_tree_read_lock(eb); in those
cases and the deadlock goes away.  Because no matter what we shouldn't be taking
locks when we're not given a trans in the backref lookup code.  So the fact that
we were doing just that and thus deadlocking should have been a red flag.

I will be sending these patches in the morning, once all of the various testing
that should take place on patches is complete.  The balance patches you have for
qgroups don't appear to be a problem, but that deadlock one is bogus and needs
to be dropped.  Thanks,

Josef
