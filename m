Return-Path: <SRS0=hUT/=SD=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BBE3EC4360F
	for <linux-btrfs@archiver.kernel.org>; Mon,  1 Apr 2019 17:06:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9409B21924
	for <linux-btrfs@archiver.kernel.org>; Mon,  1 Apr 2019 17:06:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729190AbfDARGS (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 1 Apr 2019 13:06:18 -0400
Received: from mx2.suse.de ([195.135.220.15]:44558 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729189AbfDARGR (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 1 Apr 2019 13:06:17 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 6B015ABF4
        for <linux-btrfs@vger.kernel.org>; Mon,  1 Apr 2019 17:06:16 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 3336EDA823; Mon,  1 Apr 2019 19:07:24 +0200 (CEST)
Date:   Mon, 1 Apr 2019 19:07:22 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Nikolay Borisov <nborisov@suse.com>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v4 08/15] btrfs: Stop using call_rcu for device freeing
Message-ID: <20190401170722.GY29086@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Nikolay Borisov <nborisov@suse.com>,
        linux-btrfs@vger.kernel.org
References: <20190327122418.24027-1-nborisov@suse.com>
 <20190327122418.24027-9-nborisov@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190327122418.24027-9-nborisov@suse.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Wed, Mar 27, 2019 at 02:24:11PM +0200, Nikolay Borisov wrote:
> btrfs_device structs are freed from RCU context since device iteration
> is protected by RCU. Currently this is achieved by using call_rcu since
> no blocking functions are called within btrfs_free_device. Future
> refactoring of pending/pinned chunks will require calling sleeping
> functions. This patch is in preparation for these changes by simply
> switching from RCU callbacks to explicit calls of synchronize_rcu and
> calling btrfs_free_device directly.

A paragraph why this transition is correct would be good. It looks
correct to me, so this is a matter of documentation.
