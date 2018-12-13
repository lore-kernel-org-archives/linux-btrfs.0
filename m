Return-Path: <SRS0=1olR=OW=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.9 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_PASS,USER_AGENT_NEOMUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1714CC65BAE
	for <linux-btrfs@archiver.kernel.org>; Thu, 13 Dec 2018 14:46:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BC0DB20849
	for <linux-btrfs@archiver.kernel.org>; Thu, 13 Dec 2018 14:45:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20150623.gappssmtp.com header.i=@toxicpanda-com.20150623.gappssmtp.com header.b="J6ieIHFA"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org BC0DB20849
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728612AbeLMOp6 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 13 Dec 2018 09:45:58 -0500
Received: from mail-yw1-f67.google.com ([209.85.161.67]:41483 "EHLO
        mail-yw1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728078AbeLMOp6 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 13 Dec 2018 09:45:58 -0500
Received: by mail-yw1-f67.google.com with SMTP id f65so890022ywc.8
        for <linux-btrfs@vger.kernel.org>; Thu, 13 Dec 2018 06:45:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=Tl2kytyWsfvBkhZiwaX1qDMvSn/7eqPR/dK+z4aYBn8=;
        b=J6ieIHFAmX98Hq5Z9AXBS2L9C90K+E6yzCgOR5eiQcaRL4QvcIOADO5ND/aX6BI80D
         zIgeWzCOIBxg5/ITKwBMK+t9JVg9wD3kktOhNgtnT8g6hRfAJkr1Pe1nbwlOVyaO+KJU
         MleTrnjba+rcZf33h9wccFsujThFnGw/VHOIICmTJMufxKDY79VMONjW4XDSZ8zo/Nev
         wswK0D20/7ZmGulNV4mV+V2TEHRlghc3StD2hPVqevQazreM4VAQjg0Y8KR3Tch6kiAi
         t8Zs46RrqayzThpYA4kUcFo2uiH7kv39tYi3XGHugGuIDQE8lxu/6CVTdpUr3POa70ve
         JR/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=Tl2kytyWsfvBkhZiwaX1qDMvSn/7eqPR/dK+z4aYBn8=;
        b=YFZFiitNH9+v1tJngkfpaq865nAkHsodHEf6wC2KyShLrFyN6V98WE46jIlfl1ikwA
         QnV8GxOagXZ7HFVkBwudKVsvcRKG6oiNRpWEUtFBUM0BPn2jH61NBuQcBKgo0dfdjXNL
         paNBD1O4CrkRaRzTOG+05YzxHoBQaC8o7I5LrGEmkcBzynkRn5lgbhAstFvV5uYutVRz
         KLU862stlGusNv08ZdQ7qXIIUErk0j2YcJ6WR0Nb/1XuhAAvb0kMjMZylS0u51Onz0Kz
         IID+b2UQV/UpEDDi+ORw5esEYsCY+4h7QykNlgkG6/Gin/Hn7d85EjWZSaoattUTQzu4
         HULg==
X-Gm-Message-State: AA+aEWYVAT4RlEdDcMm9qkXFVofNtEKVkbPmS98GSDOngkJVNXKh04KR
        7OvkNQCdOYL29HnDr70BLsPi/A==
X-Google-Smtp-Source: AFSGD/VxXPtm+bCx2Qz1PKaGy+3xOiZK3RCCQHpFmFWVbyWEKbINEs4OoMW79jWAhwDEtJ5NmBBhFA==
X-Received: by 2002:a81:9858:: with SMTP id p85mr24688426ywg.202.1544712357106;
        Thu, 13 Dec 2018 06:45:57 -0800 (PST)
Received: from localhost ([2620:10d:c091:180::1:6b54])
        by smtp.gmail.com with ESMTPSA id w63sm665701ywc.46.2018.12.13.06.45.56
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 13 Dec 2018 06:45:56 -0800 (PST)
Date:   Thu, 13 Dec 2018 09:45:55 -0500
From:   Josef Bacik <josef@toxicpanda.com>
To:     David Sterba <dsterba@suse.cz>
Cc:     Josef Bacik <josef@toxicpanda.com>, linux-btrfs@vger.kernel.org,
        kernel-team@fb.com
Subject: Re: [PATCH 0/8][V2] Enospc cleanups and fixeS
Message-ID: <20181213144554.pec3brfojs53smiv@macbook-pro-91.dhcp.thefacebook.com>
References: <20181203152459.21630-1-josef@toxicpanda.com>
 <20181213141111.GC23615@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181213141111.GC23615@twin.jikos.cz>
User-Agent: NeoMutt/20180716
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Thu, Dec 13, 2018 at 03:11:11PM +0100, David Sterba wrote:
> On Mon, Dec 03, 2018 at 10:24:51AM -0500, Josef Bacik wrote:
> > v1->v2:
> > - addressed comments from reviewers.
> > - fixed a bug in patch 6 that was introduced because of changes to upstream.
> > 
> > -- Original message --
> > 
> > The delayed refs rsv patches exposed a bunch of issues in our enospc
> > infrastructure that needed to be addressed.  These aren't really one coherent
> > group, but they are all around flushing and reservations.
> > may_commit_transaction() needed to be updated a little bit, and we needed to add
> > a new state to force chunk allocation if things got dicey.  Also because we can
> > end up needed to reserve a whole bunch of extra space for outstanding delayed
> > refs we needed to add the ability to only ENOSPC tickets that were too big to
> > satisfy, instead of failing all of the tickets.  There's also a fix in here for
> > one of the corner cases where we didn't quite have enough space reserved for the
> > delayed refs we were generating during evict().  Thanks,
> 
> One testbox reports an assertion failure on current for-next,
> generic/224. I'm reporting it under this patchset as it's my best guess.
> Same host running misc-next (with the delayed rsv patchset) was fine and
> the run with for-next (including this patchset) fails. The assertion is
> 
>  5225 static int __reserve_metadata_bytes(struct btrfs_fs_info *fs_info,
>  5226                                     struct btrfs_space_info *space_info,
>  5227                                     u64 orig_bytes,
>  5228                                     enum btrfs_reserve_flush_enum flush,
>  5229                                     bool system_chunk)
>  5230 {
>  5231         struct reserve_ticket ticket;
>  5232         u64 used;
>  5233         u64 reclaim_bytes = 0;
>  5234         int ret = 0;
>  5235
>  5236         ASSERT(orig_bytes);
>  ^^^^
> 

Looking at your for-next branch on your github (I assume this is what you are
testing)

https://github.com/kdave/btrfs-devel/blob/for-next-20181212/fs/btrfs/extent-tree.c

at line 5860 there's supposed to be a 

if (num_bytes == 0)
	return 0

that's what I changed in v2 of this patchset, as I hit this bug as well.  It
looks like you still have v1 of this patchset applied.  Thanks,

Josef
