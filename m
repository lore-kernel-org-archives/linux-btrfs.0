Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DC9ADC4320A
	for <linux-btrfs@archiver.kernel.org>; Tue, 24 Aug 2021 16:51:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BD907610D0
	for <linux-btrfs@archiver.kernel.org>; Tue, 24 Aug 2021 16:51:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232867AbhHXQvw (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 24 Aug 2021 12:51:52 -0400
Received: from smtp-out2.suse.de ([195.135.220.29]:50430 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232964AbhHXQvt (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 24 Aug 2021 12:51:49 -0400
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id B97F31FDB4;
        Tue, 24 Aug 2021 16:51:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1629823864;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=lrD8/TfgZZ2rbEOKvBikcKXZ9pbN0ssVlyGspMilCo8=;
        b=o6uPc0vldfqNzDvyQuOJ5yYBgglYMNMH5Q88O9wn3UD5+YDyDPftB8/Wy+IrUWI/VvYPY8
        Ni+qyAe9nYm4f5IK4VKi1AJM9mzmWBha9U/TT17fBmpYAuanySGuCTGugoSTTRgzMjE6yu
        avfCxtKrchvIJwQmURs+8xQHeZfncbU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1629823864;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=lrD8/TfgZZ2rbEOKvBikcKXZ9pbN0ssVlyGspMilCo8=;
        b=mxzSUgu94cevvfmN+t5McAliBYkWquBe8ixr+w2JWLSlUVCDrmZ96u0m7kUWnsriBJhlJv
        NkGjnLiwWMRbz8DA==
Received: from ds.suse.cz (ds.suse.cz [10.100.12.205])
        by relay2.suse.de (Postfix) with ESMTP id B19BCA3BBA;
        Tue, 24 Aug 2021 16:51:04 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id B2056DA85B; Tue, 24 Aug 2021 18:48:17 +0200 (CEST)
Date:   Tue, 24 Aug 2021 18:48:17 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Josef Bacik <josef@toxicpanda.com>
Cc:     linux-btrfs@vger.kernel.org, kernel-team@fb.com
Subject: Re: [PATCH v3 2/9] btrfs-progs: check blocks in
 btrfs_next_sibling_block
Message-ID: <20210824164817.GE3379@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Josef Bacik <josef@toxicpanda.com>,
        linux-btrfs@vger.kernel.org, kernel-team@fb.com
References: <cover.1629746415.git.josef@toxicpanda.com>
 <0bd15dc74561eba6fd6dc095848e3ba28539d6d3.1629746415.git.josef@toxicpanda.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0bd15dc74561eba6fd6dc095848e3ba28539d6d3.1629746415.git.josef@toxicpanda.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Mon, Aug 23, 2021 at 03:23:06PM -0400, Josef Bacik wrote:
> By enabling the lowmem checks properly I uncovered the case where test
> 007 will infinite loop at the detection stage.  This is because when

BTW, short test references should be eg. fsck/007, here' it's clear from
the context that it's for check/fsck.
