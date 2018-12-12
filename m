Return-Path: <SRS0=l3pb=OV=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6005EC04EB8
	for <linux-btrfs@archiver.kernel.org>; Wed, 12 Dec 2018 12:38:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3095C2084E
	for <linux-btrfs@archiver.kernel.org>; Wed, 12 Dec 2018 12:38:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3095C2084E
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727401AbeLLMiH (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 12 Dec 2018 07:38:07 -0500
Received: from mx2.suse.de ([195.135.220.15]:34766 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727313AbeLLMiG (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 12 Dec 2018 07:38:06 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 41A13AF5D
        for <linux-btrfs@vger.kernel.org>; Wed, 12 Dec 2018 12:38:05 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 579DEDA7E5; Wed, 12 Dec 2018 13:37:40 +0100 (CET)
Date:   Wed, 12 Dec 2018 13:37:39 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Qu Wenruo <wqu@suse.com>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v3 0/7] btrfs: qgroup: Delay subtree scan to reduce
 overhead
Message-ID: <20181212123739.GR23615@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org
References: <20181212003953.5643-1-wqu@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181212003953.5643-1-wqu@suse.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Wed, Dec 12, 2018 at 08:39:46AM +0800, Qu Wenruo wrote:
> changelog:
> v2:
> - Rebase to v4.20-rc1.
> - Instead commit transaction after each reloc tree merge, delay it until
>   merge_reloc_roots() finishes.
> - This provides a more natural behavior, and reduce the unnecessary
>   transaction commits.
> v3:
> - Fix backref walk deadlock by not triggering it at all.
>   This also removes the need for @exec_post refactor and replace the
>   patch to allow @old_root unpopulated.
> - Include the patch that fixes the unexpected data rsv free.

I've tested the deadlock fix but it still locks up and there are some
lockdep warnings. I can't spend more time on that given the pre-merge
window timing so I'm going to postpone all qgruop things until the next
cycle.

The deadlock fix can go to a -rc independently, so once I'm able to
gather logs I'll let you know.
