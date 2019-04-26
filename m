Return-Path: <SRS0=BNt3=S4=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C432FC43219
	for <linux-btrfs@archiver.kernel.org>; Fri, 26 Apr 2019 16:23:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9F93E206C1
	for <linux-btrfs@archiver.kernel.org>; Fri, 26 Apr 2019 16:23:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726294AbfDZQXs (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 26 Apr 2019 12:23:48 -0400
Received: from mx2.suse.de ([195.135.220.15]:49614 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726181AbfDZQXs (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 26 Apr 2019 12:23:48 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 19CD0AE9F;
        Fri, 26 Apr 2019 16:23:47 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 91729DA882; Fri, 26 Apr 2019 18:24:49 +0200 (CEST)
Date:   Fri, 26 Apr 2019 18:24:48 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Omar Sandoval <osandov@osandov.com>
Cc:     linux-btrfs@vger.kernel.org, kernel-team@fb.com
Subject: Re: [PATCH] libbtrfsutil: don't close fd on error in
 btrfs_util_subvolume_id_fd()
Message-ID: <20190426162448.GV20156@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Omar Sandoval <osandov@osandov.com>,
        linux-btrfs@vger.kernel.org, kernel-team@fb.com
References: <e9d3e2fd757f1a797089fa1122d4a7faa85c2ec8.1553537796.git.osandov@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e9d3e2fd757f1a797089fa1122d4a7faa85c2ec8.1553537796.git.osandov@fb.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Mon, Mar 25, 2019 at 11:17:56AM -0700, Omar Sandoval wrote:
> From: Omar Sandoval <osandov@fb.com>
> 
> The caller owns the fd passed to btrfs_util_subvolume_id_fd(), so we
> shouldn't close it on error. Fix it, add a regression test, and bump the
> library patch version.
> 
> Signed-off-by: Omar Sandoval <osandov@fb.com>

Applied, thanks.
