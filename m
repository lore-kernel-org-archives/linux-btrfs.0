Return-Path: <SRS0=9zVn=MX=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0AB80C32788
	for <linux-btrfs@archiver.kernel.org>; Thu, 11 Oct 2018 12:31:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CD2742077C
	for <linux-btrfs@archiver.kernel.org>; Thu, 11 Oct 2018 12:31:57 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org CD2742077C
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728141AbeJKT64 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 11 Oct 2018 15:58:56 -0400
Received: from mx2.suse.de ([195.135.220.15]:49582 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726537AbeJKT64 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 11 Oct 2018 15:58:56 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id CFC19AE02
        for <linux-btrfs@vger.kernel.org>; Thu, 11 Oct 2018 12:31:54 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 7F90EDA737; Thu, 11 Oct 2018 14:31:51 +0200 (CEST)
Date:   Thu, 11 Oct 2018 14:31:51 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Qu Wenruo <wqu@suse.com>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 1/2] btrfs: Populate btrfs_super_block::log_root_transid
Message-ID: <20181011123151.GP29418@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org
References: <20181004054950.11651-1-wqu@suse.com>
 <20181004054950.11651-2-wqu@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181004054950.11651-2-wqu@suse.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Thu, Oct 04, 2018 at 01:49:49PM +0800, Qu Wenruo wrote:
> We have btrfs_super_block::log_root_transid to record the transid of log
> tree root.
> 
> However it's never populated and it's always 0, just as the following
> dump-super:
>  log_root                30572544
>  log_root_transid        0
>  log_root_level          0
> 
> This patch will populate it with log tree root correctly, so the result
> will be:
>  log_root                30572544
>  log_root_transid        6
>  log_root_level          0
> 
> This won't affect current kernel behavior or btrfs check result as we
> already expect log tree root generation always to be super block
> genration + 1.
> 
> But it could be later used to detect log tree corruption early.

The backward compatibility seems to be ok in general, I found one
scenario where the check will fail:

* mount with unpatched kernel, log_root_transid = 0
* mount with patched kernel, log_root_transid 100, generation 101
* mount with unpatched kernel, log_root_transid 100 (unchanged), generation 201
* mount with patched kernel -> check fails

So the problem is when log_root_transid is not 0 and changes out of sync
with the generation. The above sequence of kernels can simply happen
when switching between old stable and current releases.
