Return-Path: <SRS0=9zVn=MX=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29CABC32788
	for <linux-btrfs@archiver.kernel.org>; Thu, 11 Oct 2018 12:45:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DE1472064A
	for <linux-btrfs@archiver.kernel.org>; Thu, 11 Oct 2018 12:45:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org DE1472064A
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726955AbeJKUMM (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 11 Oct 2018 16:12:12 -0400
Received: from mx2.suse.de ([195.135.220.15]:52048 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726126AbeJKUML (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 11 Oct 2018 16:12:11 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id BAFF6ADE6;
        Thu, 11 Oct 2018 12:45:07 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 946EADA737; Thu, 11 Oct 2018 14:45:04 +0200 (CEST)
Date:   Thu, 11 Oct 2018 14:45:04 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Nikolay Borisov <nborisov@suse.com>
Cc:     Lu Fengqi <lufq.fnst@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 5/6] btrfs: simplify btrfs_select_ref_head and cleanup
 some local variables
Message-ID: <20181011124504.GQ29418@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Nikolay Borisov <nborisov@suse.com>,
        Lu Fengqi <lufq.fnst@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
References: <20181011054038.5428-1-lufq.fnst@cn.fujitsu.com>
 <20181011054038.5428-6-lufq.fnst@cn.fujitsu.com>
 <e5bb27d0-fea5-30c6-afd4-aea2eae1871e@suse.com>
 <20181011121558.GF5899@fnst.localdomain>
 <0b78a3dc-bf22-fb99-afce-96b74d936173@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0b78a3dc-bf22-fb99-afce-96b74d936173@suse.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Thu, Oct 11, 2018 at 03:28:15PM +0300, Nikolay Borisov wrote:
> > I noticed that there is a macro called SCRAMBLE_DELAYED_REFS in the
> > extent-tree.c. I am a bit curious whether it has been forgotten by
> > everyone, I have not found any test results about its performance impact.
> 
> I guess it was used during testing but nothing currently sets it. I.e it
> might make sense to enable it if BTRFS_DEBUG is set.

Agreed, the way the scrambling is supposed to be used does not align
very well with the typical testing workflow so adding to ti the
BTRFS_DEBUG set is ok, unless there are severe performance problems.

The part in btrfs_run_delayed_refs would be better hidden in a function
similar to btrfs_debug_check_extent_io_range or btrfs_leak_debug_check.
