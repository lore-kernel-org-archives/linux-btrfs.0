Return-Path: <SRS0=nVQC=RK=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 88AC6C43381
	for <linux-btrfs@archiver.kernel.org>; Thu,  7 Mar 2019 16:03:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5EDD820652
	for <linux-btrfs@archiver.kernel.org>; Thu,  7 Mar 2019 16:03:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726214AbfCGQDm (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 7 Mar 2019 11:03:42 -0500
Received: from mx2.suse.de ([195.135.220.15]:57662 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726186AbfCGQDl (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 7 Mar 2019 11:03:41 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id A3B94AC69;
        Thu,  7 Mar 2019 16:03:40 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id DCBB1DA83C; Thu,  7 Mar 2019 17:04:54 +0100 (CET)
Date:   Thu, 7 Mar 2019 17:04:53 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Josef Bacik <josef@toxicpanda.com>
Cc:     kernel-team@fb.com, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: remove WARN_ON() in log_dir_items
Message-ID: <20190307160452.GI31119@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Josef Bacik <josef@toxicpanda.com>,
        kernel-team@fb.com, linux-btrfs@vger.kernel.org
References: <20190306221304.29503-1-josef@toxicpanda.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190306221304.29503-1-josef@toxicpanda.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Wed, Mar 06, 2019 at 05:13:04PM -0500, Josef Bacik wrote:
> When Filipe added the recursive directory logging stuff he specifically
> didn't take the directory i_mutex for the children directories that we
> need to log because of lockdep.  This is generally fine, but can lead to
> this WARN_ON() tripping if we happen to run delayed deletion's in
> between our first search and our second search of dir_item/dir_indexes
> for this directory.  We expect this to happen, so the WARN_ON() isn't
> necessary.  Drop the WARN_ON() and add a comment so we know why this
> case can happen.
> 
> Signed-off-by: Josef Bacik <josef@toxicpanda.com>

Added to misc-next, thanks.
