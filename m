Return-Path: <SRS0=I+S+=SR=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4B97EC10F0E
	for <linux-btrfs@archiver.kernel.org>; Mon, 15 Apr 2019 16:49:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1A87E2077C
	for <linux-btrfs@archiver.kernel.org>; Mon, 15 Apr 2019 16:49:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727800AbfDOQtq (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 15 Apr 2019 12:49:46 -0400
Received: from mx2.suse.de ([195.135.220.15]:53206 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727531AbfDOQtp (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 15 Apr 2019 12:49:45 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 61C45ADD7
        for <linux-btrfs@vger.kernel.org>; Mon, 15 Apr 2019 16:49:44 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id AFD4CDA9C7; Mon, 15 Apr 2019 18:50:49 +0200 (CEST)
Date:   Mon, 15 Apr 2019 18:50:48 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Qu Wenruo <wqu@suse.de>
Cc:     dsterba@suse.cz, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v3.1 1/9] btrfs: delayed-ref: Introduce better documented
 delayed ref structures
Message-ID: <20190415165048.GC22216@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Qu Wenruo <wqu@suse.de>,
        Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
References: <20190404064537.4031-1-wqu@suse.com>
 <20190404064537.4031-2-wqu@suse.com>
 <20190412154653.GG3476@twin.jikos.cz>
 <259b0c00-cee0-32ae-aa27-4b981d64b8cb@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <259b0c00-cee0-32ae-aa27-4b981d64b8cb@suse.de>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Sat, Apr 13, 2019 at 07:48:51AM +0800, Qu Wenruo wrote:
> 
> 
> On 2019/4/12 下午11:46, David Sterba wrote:
> > On Thu, Apr 04, 2019 at 02:45:29PM +0800, Qu Wenruo wrote:
> >> +struct btrfs_ref {
> >> +	enum btrfs_ref_type type;
> >> +	int action;
> >> +
> >> +	/*
> >> +	 * Only use parent pointers as backref (SHARED_BLOCK_REF or
> >> +	 * SHARED_DATA_REF) for this extent and its children.
> >> +	 * Set for reloc trees.
> >> +	 */
> >> +	bool only_backreferences:1;
> > 
> > I renamed this to only_backrefs and was surprised that there were no
> > compilation errors, ie. this member is not used at all ...
> 
> Yep, for callers who really uses this member, they just set @parent, and
> that's all.

So there's nothing in the old and new code that uses it, then why do you
add it? If this is for some existing patchset then ok, keep it there but
otherwise remove it.
