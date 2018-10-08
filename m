Return-Path: <SRS0=2j5R=MU=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5C57BC65C20
	for <linux-btrfs@archiver.kernel.org>; Mon,  8 Oct 2018 13:45:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2AA3920652
	for <linux-btrfs@archiver.kernel.org>; Mon,  8 Oct 2018 13:45:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2AA3920652
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726278AbeJHU4s (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 8 Oct 2018 16:56:48 -0400
Received: from mx2.suse.de ([195.135.220.15]:49612 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726056AbeJHU4s (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 8 Oct 2018 16:56:48 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 36DE9AD67;
        Mon,  8 Oct 2018 13:44:59 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id D0AB7DAD2B; Mon,  8 Oct 2018 15:44:55 +0200 (CEST)
Date:   Mon, 8 Oct 2018 15:44:55 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Josef Bacik <josef@toxicpanda.com>
Cc:     kernel-team@fb.com, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 24/42] btrfs: assert on non-empty delayed iputs
Message-ID: <20181008134454.GF29418@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Josef Bacik <josef@toxicpanda.com>,
        kernel-team@fb.com, linux-btrfs@vger.kernel.org
References: <20180928111821.24376-1-josef@toxicpanda.com>
 <20180928111821.24376-25-josef@toxicpanda.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180928111821.24376-25-josef@toxicpanda.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Fri, Sep 28, 2018 at 07:18:03AM -0400, Josef Bacik wrote:
> I ran into an issue where there was some reference being held on an
> inode that I couldn't track.  This assert wasn't triggered, but it at
> least rules out we're doing something stupid.
> 
> Reviewed-by: Omar Sandoval <osandov@fb.com>
> Signed-off-by: Josef Bacik <josef@toxicpanda.com>

Reviewed-by: David Sterba <dsterba@suse.com>
