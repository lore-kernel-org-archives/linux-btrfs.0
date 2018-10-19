Return-Path: <SRS0=U11f=M7=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A7A7DECDE3D
	for <linux-btrfs@archiver.kernel.org>; Fri, 19 Oct 2018 13:12:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 777632145D
	for <linux-btrfs@archiver.kernel.org>; Fri, 19 Oct 2018 13:12:46 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 777632145D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727315AbeJSVSt (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 19 Oct 2018 17:18:49 -0400
Received: from mx2.suse.de ([195.135.220.15]:53498 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727014AbeJSVSs (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 19 Oct 2018 17:18:48 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id EBC15AC90
        for <linux-btrfs@vger.kernel.org>; Fri, 19 Oct 2018 13:12:42 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 7C4A7DA6F5; Fri, 19 Oct 2018 15:12:36 +0200 (CEST)
Date:   Fri, 19 Oct 2018 15:12:34 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Qu Wenruo <wqu@suse.com>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 5/6] btrfs: qgroup: Use delayed subtree rescan for balance
Message-ID: <20181019131234.GF16290@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org
References: <20181018111729.11128-1-wqu@suse.com>
 <20181018111729.11128-6-wqu@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181018111729.11128-6-wqu@suse.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Thu, Oct 18, 2018 at 07:17:28PM +0800, Qu Wenruo wrote:
> +free_out:
> +	kfree(block);
> +	free_extent_buffer(reloc_eb);
> +out:
> +	if (ret < 0) {
> +		btrfs_err_rl(fs_info,
> +			     "failed to account subtree at bytenr %llu: %d",
> +			     file_eb->start, ret); 

There's a trailing space at the end of the line and git-am does not let
me apply the patch without manual intervetion. Please clean the patch
before sending next time, thanks.

> +		fs_info->qgroup_flags |= BTRFS_QGROUP_STATUS_FLAG_INCONSISTENT;
> +	}
> +	return ret;
> +}
