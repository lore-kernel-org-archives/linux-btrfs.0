Return-Path: <SRS0=E+Vc=DW=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 30A00C433E7
	for <linux-btrfs@archiver.kernel.org>; Thu, 15 Oct 2020 20:01:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D430D20714
	for <linux-btrfs@archiver.kernel.org>; Thu, 15 Oct 2020 20:01:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731037AbgJOUBG (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 15 Oct 2020 16:01:06 -0400
Received: from mx2.suse.de ([195.135.220.15]:59058 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729327AbgJOUBG (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 15 Oct 2020 16:01:06 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 59BADAD79;
        Thu, 15 Oct 2020 20:01:05 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id B614ADA7C3; Thu, 15 Oct 2020 21:59:37 +0200 (CEST)
Date:   Thu, 15 Oct 2020 21:59:37 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Josef Bacik <josef@toxicpanda.com>
Cc:     linux-btrfs@vger.kernel.org, kernel-team@fb.com
Subject: Re: [PATCH] btrfs: drop the path before adding blockgroup sysfs files
Message-ID: <20201015195937.GR6756@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Josef Bacik <josef@toxicpanda.com>,
        linux-btrfs@vger.kernel.org, kernel-team@fb.com
References: <03a94ec83095d00b19dcb65fda1b58f1b41f1297.1602709223.git.josef@toxicpanda.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <03a94ec83095d00b19dcb65fda1b58f1b41f1297.1602709223.git.josef@toxicpanda.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Wed, Oct 14, 2020 at 05:00:51PM -0400, Josef Bacik wrote:
> Dave reported a problem with my rwsem conversion patch where we got the
> following lockdep splat
...
> Signed-off-by: Josef Bacik <josef@toxicpanda.com>

Added to misc-next, thanks.
