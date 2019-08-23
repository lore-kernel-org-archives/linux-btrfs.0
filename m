Return-Path: <SRS0=V1nM=WT=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1BB96C3A5A4
	for <linux-btrfs@archiver.kernel.org>; Fri, 23 Aug 2019 12:17:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EDEA123401
	for <linux-btrfs@archiver.kernel.org>; Fri, 23 Aug 2019 12:17:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393407AbfHWMRG (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 23 Aug 2019 08:17:06 -0400
Received: from mx2.suse.de ([195.135.220.15]:35202 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2394435AbfHWMRG (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 23 Aug 2019 08:17:06 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id DA58AAF9C;
        Fri, 23 Aug 2019 12:17:04 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 61FE1DA796; Fri, 23 Aug 2019 14:17:29 +0200 (CEST)
Date:   Fri, 23 Aug 2019 14:17:28 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Josef Bacik <josef@toxicpanda.com>
Cc:     kernel-team@fb.com, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 3/9] btrfs: add space reservation tracepoint for reserved
 bytes
Message-ID: <20190823121727.GM2752@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Josef Bacik <josef@toxicpanda.com>,
        kernel-team@fb.com, linux-btrfs@vger.kernel.org
References: <20190822191102.13732-1-josef@toxicpanda.com>
 <20190822191102.13732-4-josef@toxicpanda.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190822191102.13732-4-josef@toxicpanda.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Thu, Aug 22, 2019 at 03:10:56PM -0400, Josef Bacik wrote:
> I noticed when folding the trace_btrfs_space_reservation() tracepoint
> into the btrfs_space_info_update_* helpers that we didn't emit a
> tracepoint when doing btrfs_add_reserved_bytes().  I know this is
> because we were swapping bytes_may_use for bytes_reserved, so in my mind
> there was no reason to have the tracepoint there.  But now there is
> because we always emit the unreserve for the bytes_may_use side, and
> this would have broken if compression was on anyway.  Add a tracepoint
> to cover the bytes_reserved counter so the math still comes out right.
> 
> Signed-off-by: Josef Bacik <josef@toxicpanda.com>

Reviewed-by: David Sterba <dsterba@suse.com>
