Return-Path: <SRS0=SOow=SE=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B0DC9C4360F
	for <linux-btrfs@archiver.kernel.org>; Tue,  2 Apr 2019 16:11:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7DB6C206DF
	for <linux-btrfs@archiver.kernel.org>; Tue,  2 Apr 2019 16:11:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729535AbfDBQLO (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 2 Apr 2019 12:11:14 -0400
Received: from mx2.suse.de ([195.135.220.15]:54684 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729136AbfDBQLN (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 2 Apr 2019 12:11:13 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id CE107AEEA
        for <linux-btrfs@vger.kernel.org>; Tue,  2 Apr 2019 16:11:12 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 93B7EDA824; Tue,  2 Apr 2019 18:12:22 +0200 (CEST)
Date:   Tue, 2 Apr 2019 18:12:22 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Nikolay Borisov <nborisov@suse.com>
Cc:     dsterba@suse.cz, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v4 08/15] btrfs: Stop using call_rcu for device freeing
Message-ID: <20190402161222.GD29086@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Nikolay Borisov <nborisov@suse.com>,
        linux-btrfs@vger.kernel.org
References: <20190327122418.24027-1-nborisov@suse.com>
 <20190327122418.24027-9-nborisov@suse.com>
 <20190401170722.GY29086@twin.jikos.cz>
 <318e1daa-3bef-3474-cba4-ec6faa527e26@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <318e1daa-3bef-3474-cba4-ec6faa527e26@suse.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Mon, Apr 01, 2019 at 08:20:56PM +0300, Nikolay Borisov wrote:
> 
> 
> On 1.04.19 г. 20:07 ч., David Sterba wrote:
> > On Wed, Mar 27, 2019 at 02:24:11PM +0200, Nikolay Borisov wrote:
> >> btrfs_device structs are freed from RCU context since device iteration
> >> is protected by RCU. Currently this is achieved by using call_rcu since
> >> no blocking functions are called within btrfs_free_device. Future
> >> refactoring of pending/pinned chunks will require calling sleeping
> >> functions. This patch is in preparation for these changes by simply
> >> switching from RCU callbacks to explicit calls of synchronize_rcu and
> >> calling btrfs_free_device directly.
> > 
> > A paragraph why this transition is correct would be good. It looks
> > correct to me, so this is a matter of documentation.
> 
> Well call_rcu and synchronize_rcu() are functionally equivalent in that
> they run the code that follows them after a grace period has expired.

This is enough to make the point about the correctness a bit more
explicit, patch updated. When there's too much implicit assumptions, eg.
about how RCU is used, then one sentence is ok to show that the patch
author knows what he's doing. It's like pointing to the right direction,
but repeating the whole mechanism is not necessary for the typical usage
patterns.
