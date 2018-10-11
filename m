Return-Path: <SRS0=9zVn=MX=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 23F07C46463
	for <linux-btrfs@archiver.kernel.org>; Thu, 11 Oct 2018 11:51:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D9535205C9
	for <linux-btrfs@archiver.kernel.org>; Thu, 11 Oct 2018 11:51:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D9535205C9
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727260AbeJKTSg (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 11 Oct 2018 15:18:36 -0400
Received: from mx2.suse.de ([195.135.220.15]:42496 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726788AbeJKTSg (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 11 Oct 2018 15:18:36 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id D88DBACAD;
        Thu, 11 Oct 2018 11:51:41 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id C4C9EDA737; Thu, 11 Oct 2018 13:51:37 +0200 (CEST)
Date:   Thu, 11 Oct 2018 13:51:37 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Lu Fengqi <lufq.fnst@cn.fujitsu.com>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 0/6] Some trivail cleanup about dealyed-refs
Message-ID: <20181011115137.GN29418@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Lu Fengqi <lufq.fnst@cn.fujitsu.com>,
        linux-btrfs@vger.kernel.org
References: <20181011054038.5428-1-lufq.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181011054038.5428-1-lufq.fnst@cn.fujitsu.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Thu, Oct 11, 2018 at 01:40:32PM +0800, Lu Fengqi wrote:
> There is no functional change. Just improve readablity.
> 
> PATCH 1-4 parameter cleanup patches
> PATCH 5 cleanup about btrfs_select_ref_head
> PATCH 6 switch int to bool; add some comment
> 
> Lu Fengqi (6):
>   btrfs: delayed-ref: pass delayed_refs directly to
>     btrfs_select_ref_head()
>   btrfs: delayed-ref: pass delayed_refs directly to
>     btrfs_delayed_ref_lock()
>   btrfs: remove fs_info from btrfs_check_space_for_delayed_refs
>   btrfs: remove fs_info from btrfs_should_throttle_delayed_refs
>   btrfs: simplify btrfs_select_ref_head and cleanup some local variables
>   btrfs: switch return_bigger to bool in find_ref_head

1-4 and 6 added to misc-next, thanks.
