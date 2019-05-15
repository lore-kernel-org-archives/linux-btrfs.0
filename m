Return-Path: <SRS0=mA8v=TP=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8CD80C04E53
	for <linux-btrfs@archiver.kernel.org>; Wed, 15 May 2019 14:20:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 68C372084E
	for <linux-btrfs@archiver.kernel.org>; Wed, 15 May 2019 14:20:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726758AbfEOOUR (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 15 May 2019 10:20:17 -0400
Received: from mx2.suse.de ([195.135.220.15]:46288 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725953AbfEOOUR (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 15 May 2019 10:20:17 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 3C68AAF86;
        Wed, 15 May 2019 14:20:16 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 9CB3CDA8A7; Wed, 15 May 2019 16:21:16 +0200 (CEST)
Date:   Wed, 15 May 2019 16:21:16 +0200
From:   David Sterba <dsterba@suse.cz>
To:     fdmanana@kernel.org
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs-progs: receive, add debug information to write and
 clone commands
Message-ID: <20190515142116.GR3138@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, fdmanana@kernel.org,
        linux-btrfs@vger.kernel.org
References: <20190329193526.21315-1-fdmanana@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190329193526.21315-1-fdmanana@kernel.org>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Fri, Mar 29, 2019 at 07:35:26PM +0000, fdmanana@kernel.org wrote:
> From: Filipe Manana <fdmanana@suse.com>
> 
> Currently, when operating in a more verbose mode (-vv), the receive command
> does not mention any write or clone commands, unlike other commands.
> 
> This change adds debug messages for the write and clone operations, that do
> not include data but only offsets and lengths, as this is actually very
> useful to debug a send stream and I use it frequently.
> 
> Signed-off-by: Filipe Manana <fdmanana@suse.com>

Added to devel, sorry for the delay.
