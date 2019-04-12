Return-Path: <SRS0=+qyB=SO=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 04B22C10F0E
	for <linux-btrfs@archiver.kernel.org>; Fri, 12 Apr 2019 15:45:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D2D122082E
	for <linux-btrfs@archiver.kernel.org>; Fri, 12 Apr 2019 15:45:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726829AbfDLPpp (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 12 Apr 2019 11:45:45 -0400
Received: from mx2.suse.de ([195.135.220.15]:42638 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726780AbfDLPpp (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 12 Apr 2019 11:45:45 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 47687AE14
        for <linux-btrfs@vger.kernel.org>; Fri, 12 Apr 2019 15:45:44 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id C3118DA8D6; Fri, 12 Apr 2019 17:46:53 +0200 (CEST)
Date:   Fri, 12 Apr 2019 17:46:53 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Qu Wenruo <wqu@suse.com>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v3.1 1/9] btrfs: delayed-ref: Introduce better documented
 delayed ref structures
Message-ID: <20190412154653.GG3476@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org
References: <20190404064537.4031-1-wqu@suse.com>
 <20190404064537.4031-2-wqu@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190404064537.4031-2-wqu@suse.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Thu, Apr 04, 2019 at 02:45:29PM +0800, Qu Wenruo wrote:
> +struct btrfs_ref {
> +	enum btrfs_ref_type type;
> +	int action;
> +
> +	/*
> +	 * Only use parent pointers as backref (SHARED_BLOCK_REF or
> +	 * SHARED_DATA_REF) for this extent and its children.
> +	 * Set for reloc trees.
> +	 */
> +	bool only_backreferences:1;

I renamed this to only_backrefs and was surprised that there were no
compilation errors, ie. this member is not used at all ...
