Return-Path: <SRS0=fY4Z=NX=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 430A7C43441
	for <linux-btrfs@archiver.kernel.org>; Mon, 12 Nov 2018 18:26:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 127932245E
	for <linux-btrfs@archiver.kernel.org>; Mon, 12 Nov 2018 18:26:32 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 127932245E
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729133AbeKMEUy (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 12 Nov 2018 23:20:54 -0500
Received: from mx2.suse.de ([195.135.220.15]:49148 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727354AbeKMEUy (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 12 Nov 2018 23:20:54 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 5B1E8AFB5;
        Mon, 12 Nov 2018 18:26:29 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 5E834DAFAE; Mon, 12 Nov 2018 19:26:14 +0100 (CET)
Date:   Mon, 12 Nov 2018 19:26:14 +0100
From:   David Sterba <dsterba@suse.cz>
To:     fdmanana@kernel.org
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: simpler and more efficient cleanup of a log
 tree's extent io tree
Message-ID: <20181112182614.GK24115@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, fdmanana@kernel.org,
        linux-btrfs@vger.kernel.org
References: <20181109104308.13123-1-fdmanana@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181109104308.13123-1-fdmanana@kernel.org>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Fri, Nov 09, 2018 at 10:43:08AM +0000, fdmanana@kernel.org wrote:
> From: Filipe Manana <fdmanana@suse.com>
> 
> We currently are in a loop finding each range (corresponding to a btree
> node/leaf) in a log root's extent io tree and then clean it up. This is a
> waste of time since we are traversing the extent io tree's rb_tree more
> times then needed (one for a range lookup and another for cleaning it up)
> without any good reason.
> 
> We free the log trees when we are in the critical section of a transaction
> commit (the transaction state is set to TRANS_STATE_COMMIT_DOING), so it's
> of great convenience to do everything as fast as possible in order to
> reduce the time we block other tasks from starting a new transaction.
> 
> So fix this by traversing the extent io tree once and cleaning up all its
> records in one go while traversing it.
> 
> Signed-off-by: Filipe Manana <fdmanana@suse.com>

Added to misc-next, thanks.
