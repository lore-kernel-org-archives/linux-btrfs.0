Return-Path: <SRS0=T+sm=Q2=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 33E6AC43381
	for <linux-btrfs@archiver.kernel.org>; Tue, 19 Feb 2019 19:44:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 00DBF2146F
	for <linux-btrfs@archiver.kernel.org>; Tue, 19 Feb 2019 19:44:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726215AbfBSTo6 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 19 Feb 2019 14:44:58 -0500
Received: from mx2.suse.de ([195.135.220.15]:57116 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725807AbfBSTo5 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 19 Feb 2019 14:44:57 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id C144FAEF6;
        Tue, 19 Feb 2019 19:44:56 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 4D2F9DA83C; Tue, 19 Feb 2019 20:46:18 +0100 (CET)
Date:   Tue, 19 Feb 2019 20:46:17 +0100
From:   David Sterba <dsterba@suse.cz>
To:     fdmanana@kernel.org
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2 1/2] Btrfs: add missing error handling after doing
 leaf/node binary search
Message-ID: <20190219194616.GV9874@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, fdmanana@kernel.org,
        linux-btrfs@vger.kernel.org
References: <20190218165726.22884-1-fdmanana@kernel.org>
 <20190218170730.19965-1-fdmanana@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190218170730.19965-1-fdmanana@kernel.org>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Mon, Feb 18, 2019 at 05:07:30PM +0000, fdmanana@kernel.org wrote:
> From: Filipe Manana <fdmanana@suse.com>
> 
> The function map_private_extent_buffer() can return an -EINVAL error, and
> it is called by generic_bin_search() which will return back the error. The
> btrfs_bin_search() function in turn calls generic_bin_search() and the
> key_search() function calls btrfs_bin_search(), so both can return the
> -EINVAL error coming from the map_private_extent_buffer() function. Some
> callers of these functions were ignoring that these functions can return
> an error, so fix them to deal with error return values.
> 
> Signed-off-by: Filipe Manana <fdmanana@suse.com>

Reviewed-by: David Sterba <dsterba@suse.com>

The binary search functions are called from functions that return errors
and those are handled.

Grepping for map_private_extent_buffer pointed to the set/get function
template DEFINE_BTRFS_SETGET_BITS, handling errors there seems to be
more tricky.
