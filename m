Return-Path: <SRS0=2j5R=MU=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_NEOMUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 72FC5C65C20
	for <linux-btrfs@archiver.kernel.org>; Mon,  8 Oct 2018 14:45:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 38466204EC
	for <linux-btrfs@archiver.kernel.org>; Mon,  8 Oct 2018 14:45:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 38466204EC
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.de
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726391AbeJHV5H (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 8 Oct 2018 17:57:07 -0400
Received: from mx2.suse.de ([195.135.220.15]:60522 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726159AbeJHV5H (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 8 Oct 2018 17:57:07 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 36DDCAD6D;
        Mon,  8 Oct 2018 14:45:02 +0000 (UTC)
Date:   Mon, 8 Oct 2018 09:44:59 -0500
From:   Goldwyn Rodrigues <rgoldwyn@suse.de>
To:     dsterba@suse.cz, linux-btrfs@vger.kernel.org
Cc:     misono.tomohiro@jp.fujitsu.com
Subject: Re: [PATCH] btrfs: Remove unused variable mode in btrfs_mount
Message-ID: <20181008144459.xa6iekp45te2xq2s@merlin>
References: <20181005122615.da52bp6a6ie4jzzw@merlin>
 <20181008130339.GE29418@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181008130339.GE29418@twin.jikos.cz>
User-Agent: NeoMutt/20180323
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On 15:03 08/10, David Sterba wrote:
> On Fri, Oct 05, 2018 at 07:26:15AM -0500, Goldwyn Rodrigues wrote:
> > Code cleanup.
> 
> Have you check when and why the variable become unused? Thanks.

No, I did not check it earlier. git blame points to
312c89fbca06 ("btrfs: cleanup btrfs_mount() using btrfs_mount_root()")
Author cc'd.

-- 
Goldwyn
