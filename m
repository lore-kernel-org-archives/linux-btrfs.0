Return-Path: <SRS0=X8W1=NL=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_NEOMUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E32A2ECDE44
	for <linux-btrfs@archiver.kernel.org>; Wed, 31 Oct 2018 16:05:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A9F6120821
	for <linux-btrfs@archiver.kernel.org>; Wed, 31 Oct 2018 16:05:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20150623.gappssmtp.com header.i=@toxicpanda-com.20150623.gappssmtp.com header.b="iNmPPpul"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A9F6120821
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729811AbeKABDq (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 31 Oct 2018 21:03:46 -0400
Received: from mail-yb1-f195.google.com ([209.85.219.195]:43583 "EHLO
        mail-yb1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729440AbeKABDq (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 31 Oct 2018 21:03:46 -0400
Received: by mail-yb1-f195.google.com with SMTP id g75-v6so6832026yba.10
        for <linux-btrfs@vger.kernel.org>; Wed, 31 Oct 2018 09:05:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=O6ppIeXP8PXklAjTN7ST7Su7rSRfN17KsW36Mlm+oVk=;
        b=iNmPPpulW+lmOT9YODi23smJJkhfpjEekSglK64pKduTuMSFCa19vEcnflLtQiCguO
         RRMAHoT2E8KIxBCcTBp8Ym4uPPawmShHZo9D/jTN8oP+tlYyZacP/JEsJNXZ93s+UK25
         3BwCHotcPOVC6rO0K+aeBeWVWHOj3/NrP7mtBEjos9Ozfb6Yz/c0llZQqejoDeh3EWNz
         HM7v2PRPSbvB2SN/1s8t0YuwYCnQnpSj6hPx4kO7fG4BIdQI4sy4RcJUjFq9svOfmO+g
         ivqZQgFLFd+Jz+TqSNu1Pni3kKiyyRsnxQhSwtF+rbZaDa5NOlOFi8QfIqLVKIv2ukjG
         IHBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=O6ppIeXP8PXklAjTN7ST7Su7rSRfN17KsW36Mlm+oVk=;
        b=TgXOPWxwM2GdP3bdISkeudtKSROkcZdc74VZSdEQAKTA1L+hJiTC0/mMfGpMTlB8y+
         Q+LpmBCmL59IZ0PCKXhgjqzqnRtsw16x4bM4ijA3fffV65dWec24C+K1Yj+vodjZkFYv
         Gj/oPaxuaQI+HfRMgoA86zBpUziABhLThjE0+1n7+mlLtuMOC+4Nz8FWw6tia8XAcVon
         /eoWlj313atJgFFJbZCYAS1Th8vEwyok/99m1NXz4GhP6GtWX1yID2m6GcKbrVLbQo5y
         lq/0l+b5dCPL5Dos39q/0lJe2L9Dgs+xrRhpNbQU+31ToZhojpXiOtnX2+2rb7uAWmvp
         QAIw==
X-Gm-Message-State: AGRZ1gIL4XS1tEm50wSXjY7O3i/7l4VrGzwyg1AiErkOA58+XBCdXAfT
        QIRLXd916nkbT7JQ60cSdouVjg==
X-Google-Smtp-Source: AJdET5fOobbGGNOn/YUeyAYoy2VKOgzZ6ITasLYXcSa/UJhDNLxYEPYmzORSa1lVMNu12/xuFu1ioQ==
X-Received: by 2002:a25:cc4:: with SMTP id 187-v6mr3637462ybm.296.1541001908509;
        Wed, 31 Oct 2018 09:05:08 -0700 (PDT)
Received: from localhost ([2620:10d:c091:180::1:56b9])
        by smtp.gmail.com with ESMTPSA id h6-v6sm6103751ywm.89.2018.10.31.09.05.07
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 31 Oct 2018 09:05:07 -0700 (PDT)
Date:   Wed, 31 Oct 2018 12:05:05 -0400
From:   Josef Bacik <josef@toxicpanda.com>
To:     fdmanana@kernel.org
Cc:     fstests@vger.kernel.org, linux-btrfs@vger.kernel.org,
        Filipe Manana <fdmanana@suse.com>
Subject: Re: [PATCH] fstests: fix fssum to actually ignore file holes when
 supposed to
Message-ID: <20181031160504.hldii2zywr2n7sp6@macbook-pro-91.dhcp.thefacebook.com>
References: <20181029094340.18154-1-fdmanana@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181029094340.18154-1-fdmanana@kernel.org>
User-Agent: NeoMutt/20180716
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Mon, Oct 29, 2018 at 09:43:40AM +0000, fdmanana@kernel.org wrote:
> From: Filipe Manana <fdmanana@suse.com>
> 
> Unless the '-s' option is passed to fssum, it should not detect file holes
> and have their existence influence the computed checksum for a file. This
> tool was added to test btrfs' send/receive feature, so that it checks for
> any metadata and data differences between the original filesystem and the
> filesystem that receives send streams.
> 
> For a long time the test btrfs/007, which tests btrfs' send/receive with
> fsstress, fails sporadically reporting data differences between files.
> However the md5sum/sha1sum from the reported files in the original and
> new filesystems are the same. The reason why fssum fails is because even
> in normal mode it still accounts for number of holes that exist in the
> file and their respective lengths. This is done using the SEEK_DATA mode
> of lseek. The btrfs send feature does not preserve holes nor prealloc
> extents (not supported by the current protocol), so whenever a hole or
> prealloc (unwritten) extent is detected in the source filesystem, it
> issues a write command full of zeroes, which will translate to a regular
> (written) extent in the destination filesystem. This is why fssum reports
> a different checksum. A prealloc extent also counts as hole when using
> lseek.
> 
> For example when passing a seed of 1540592967 to fsstress in btrfs/007,
> the test fails, as file p0/d0/f7 has a prealloc extent in the original
> filesystem (in the incr snapshot).
> 
> Fix this by making fssum just read the hole file and feed its data to the
> digest calculation function when option '-s' is not given. If we ever get
> btrfs' send/receive to support holes and fallocate, we can just change
> the test and pass the '-s' option to all fssum calls.
> 
> Signed-off-by: Filipe Manana <fdmanana@suse.com>

Reviewed-by: Josef Bacik <josef@toxicpanda.com>

Thanks,

Josef
