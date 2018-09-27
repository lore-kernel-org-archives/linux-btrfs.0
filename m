Return-Path: <SRS0=Zypw=MJ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4E220C43382
	for <linux-btrfs@archiver.kernel.org>; Thu, 27 Sep 2018 12:40:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 04F6B2168B
	for <linux-btrfs@archiver.kernel.org>; Thu, 27 Sep 2018 12:40:11 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 04F6B2168B
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727512AbeI0S6P (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 27 Sep 2018 14:58:15 -0400
Received: from mx2.suse.de ([195.135.220.15]:49246 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727108AbeI0S6O (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 27 Sep 2018 14:58:14 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id D2B4EAD68
        for <linux-btrfs@vger.kernel.org>; Thu, 27 Sep 2018 12:40:07 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 5B403DAE2F; Thu, 27 Sep 2018 14:40:07 +0200 (CEST)
Date:   Thu, 27 Sep 2018 14:40:07 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Nikolay Borisov <nborisov@suse.com>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 0/7] eb reference count cleanups
Message-ID: <20180927124007.GQ3255@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Nikolay Borisov <nborisov@suse.com>,
        linux-btrfs@vger.kernel.org
References: <1534346817-9108-1-git-send-email-nborisov@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1534346817-9108-1-git-send-email-nborisov@suse.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Wed, Aug 15, 2018 at 06:26:50PM +0300, Nikolay Borisov wrote:
> Here is a series which simplifies the way eb are used in EXTENT_BUFFER_UNMAPPED
> context. The end goal was to remove the special "if we have ref count of 2 and 
> EXTENT_BUFFER_UNMAPPED flag then act as if this is the last ref and free the 
> buffer" case. To enable this the first 6 patches modify call sites which 
> needlessly bump the reference count.
> 
> Patch 1 & 2 remove some btree locking when we are operating on unmapped extent
> buffers. Each patch's changelog explains why this is safe to do . 
> 
> Patch 3,4,5 and 6 remove redundant calls to extent_buffer_get since they don't 
> really add any value. In all 3 cases having a reference count of 1 is sufficient 
> for the eb to be freed via btrfs_release_path.
> 
> Patch 7 removes the special handling of EXTENT_BUFFER_UNMAPPED flag in 
> free_extent_buffer. Also adjust the selftest code to account for this change 
> by calling one extra time free_extent_buffer. Also document which references 
> are being dropped. All in all this shouldn't have any functional bearing. 
> 
> This was tested with multiple full xfstest runs as well as unloading the btrfs 
> module after each one to trigger the leak check and ensure no eb's are leaked. 
> I've also run it through btrfs' selftests multiple times with no problems. 
> 
> With this set applied EXTENT_BUFFER_UNMAPPED seems to be relevant only for 
> selftest which leads me to believe it can be removed altogether. I will 
> investigate this next but in the meantime this series should be good to go.

It's not just for the tests but for the tree-mod-log things, so it can't
be removed yet.

The patchset has been in for-next for a few weaks, no problems reported.
Some of the artificial references are obviously redundant (get/free in
the same function), the tree-mod-log (get_old_root) span several
functions but otherwise this seems safe to remove as well.

I'd ask for more asserts and comments, eg. that the unmapped eb must
have refcount 1 at the time it's being freed. As it's used in special
context, the lifetime can be verified statically and the assert would
catch any future violations.

Anyway, I'm going to move the patches to misc-next and schedule for
4.20.
