Return-Path: <SRS0=RlhI=RB=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_NEOMUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AD248C43381
	for <linux-btrfs@archiver.kernel.org>; Tue, 26 Feb 2019 13:35:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6D6172173C
	for <linux-btrfs@archiver.kernel.org>; Tue, 26 Feb 2019 13:35:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20150623.gappssmtp.com header.i=@toxicpanda-com.20150623.gappssmtp.com header.b="OJdac/Kl"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726992AbfBZNfU (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 26 Feb 2019 08:35:20 -0500
Received: from mail-qk1-f194.google.com ([209.85.222.194]:45870 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725977AbfBZNfU (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 26 Feb 2019 08:35:20 -0500
Received: by mail-qk1-f194.google.com with SMTP id v139so7507603qkb.12
        for <linux-btrfs@vger.kernel.org>; Tue, 26 Feb 2019 05:35:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to
         :user-agent;
        bh=slsq4a/RA411R6hJxgqs9qXOMZGssIwU9FyXP6K+peI=;
        b=OJdac/KlIbvJ6eLZdtYecPPazN25Vi0nmY9GslO0ZPjgkuu0yOUkdciArvgv2MKG1O
         DL95J4r8OOkSAmBod3cX6pma4iMnQAnso8QvkD10QXyartct39mvK8pmtspoCWinj80g
         q6ePGqth3VucjjrVtzNuvvaJY2X4x/Qq4jDDgQ7F85olXyRtvf/hnIMRbFJ5lKeP2Vz3
         JAfzQNrIH7ZbJc4N3SYLqZa7UY1wKEWwdVyNuneD/sJTgvh/ek7AJy7cRWGA2RwVYiul
         ZQYHRFuWu3NE6U80E7Az/d7CibricnIcH5msIX0IJusxU6yHr07uxgq0U7arKwbsl+ef
         Q/Rg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=slsq4a/RA411R6hJxgqs9qXOMZGssIwU9FyXP6K+peI=;
        b=cbWp0r31Nw2sRt4JKqlTvg1aErC+msAP/bqj0EI7BGsMgBTBfN/Sk1oZH3v3jUIYlG
         0NiOFz7lED4jJ+qE9Okgp2MDegc65Bm+WvMH2DQbTI9B1TjOZtDT3JkIYvueFu5QWB6z
         nUGCVb/+PqIRAftMtuvhAiNicYpDdcj0gAEqkOehwSEx/NJILVR8A2tQPM8OjdKeugAE
         RQ2yJ6wTj4r0Zadk129XjahkeBeI+yTz0tYhPXw1OUIPwQBrShUsssfoC7Zw9OxV3OK6
         u5uZgrW6nEkxWbn1LTB3wjIW0GKje/zsO78gYddxquqfbA8hBjm5oApKPGDJujHYi1Mh
         /dNw==
X-Gm-Message-State: AHQUAuZybIALOybqeCnW8/3PvnghJNE34Xu0U+Pj74M5gY0qZCV5+bgP
        ZJHqK6nCSoK0woH/rlgFUfMp1w==
X-Google-Smtp-Source: AHgI3IaNBT3EkW9eSX/5NCYeVpxj2BQqNuXDMY1DlmGO3+/F7cdLMvzbZu7qOZ1hSGu4Kg3hP+gEDQ==
X-Received: by 2002:a37:a316:: with SMTP id m22mr16483140qke.194.1551188119220;
        Tue, 26 Feb 2019 05:35:19 -0800 (PST)
Received: from localhost ([63.138.96.6])
        by smtp.gmail.com with ESMTPSA id c9sm8793314qkj.61.2019.02.26.05.35.18
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 26 Feb 2019 05:35:18 -0800 (PST)
Date:   Tue, 26 Feb 2019 08:35:09 -0500
From:   Josef Bacik <josef@toxicpanda.com>
To:     Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc:     Josef Bacik <josef@toxicpanda.com>, David Sterba <dsterba@suse.cz>,
        Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: Use struct inode* to replace
 extent_io_tree::private_data
Message-ID: <20190226133507.botpzpuihc7phkzp@MacBook-Pro-91.local>
References: <20190225055043.1621-1-wqu@suse.com>
 <20190225121540.GN9874@twin.jikos.cz>
 <7a8afd82-7acf-e2cc-deff-38ccf702ef2d@gmx.com>
 <20190225122657.GP9874@twin.jikos.cz>
 <20190225154602.gsrmmp465l7rnkm3@macbook-pro-91.dhcp.thefacebook.com>
 <ed6b4151-7c8d-5132-13d2-4f00ecabd2da@gmx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ed6b4151-7c8d-5132-13d2-4f00ecabd2da@gmx.com>
User-Agent: NeoMutt/20180716
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Tue, Feb 26, 2019 at 12:07:37PM +0800, Qu Wenruo wrote:
> 
> 
> On 2019/2/25 下午11:46, Josef Bacik wrote:
> > On Mon, Feb 25, 2019 at 01:26:57PM +0100, David Sterba wrote:
> >> On Mon, Feb 25, 2019 at 08:17:52PM +0800, Qu Wenruo wrote:
> >>>
> >>>
> >>> On 2019/2/25 下午8:15, David Sterba wrote:
> >>>> On Mon, Feb 25, 2019 at 01:50:43PM +0800, Qu Wenruo wrote:
> >>>>> All users of extent_io_tree::private_data are expecting struct inode*.
> >>>>> So just use struct inode* to replace extent_io_tree::private_data, and
> >>>>> this should provide better type check.
> >>>>>
> >>>>> Signed-off-by: Qu Wenruo <wqu@suse.com>
> >>>>>  struct extent_io_tree {
> >>>>>  	struct rb_root state;
> >>>>> -	void *private_data;
> >>>>> +	struct inode *inode;
> >>>>>  	u64 dirty_bytes;
> >>>>>  	int track_uptodate;
> >>>>>  	spinlock_t lock;
> >>>>
> >>>> So this is effectively reverting c6100a4b4e3d1650deafd ("Btrfs: replace
> >>>> tree->mapping with tree->private_data"),
> >>>
> >>> That commit message doesn't explain why this is needed for btree_inode
> >>> removal.
> >>>
> >>> Any idea what the extra type would be used in that case?
> >>
> >> I don't know, Josef in CC to answer that.
> > 
> > Yeah there's a mapping tree thing I make to keep track of the metadata, it holds
> > the radix tree for the eb's and a bunch of other stuff.  This needs to stay a
> > void *.  Thanks,
> 
> Then what about an union here?
> 
> BTW, for no btree_inode case, how do we distinguish regular inode
> pointer with yours? An extra member?
>

We don't have to, the only place the inode is used is when doing the callbacks.
The callbacks are implementation specific, so the btree extent_io callbacks know
that the void *private_data is their struct btrfs_eb_info, and the inode ones
know it's their struct inode *.  Thanks,

Josef 
