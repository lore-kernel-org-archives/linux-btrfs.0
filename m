Return-Path: <SRS0=lg0L=OQ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D3414C07E85
	for <linux-btrfs@archiver.kernel.org>; Fri,  7 Dec 2018 19:14:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 954DC20837
	for <linux-btrfs@archiver.kernel.org>; Fri,  7 Dec 2018 19:14:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 954DC20837
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726055AbeLGTOy (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 7 Dec 2018 14:14:54 -0500
Received: from mx2.suse.de ([195.135.220.15]:37450 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726018AbeLGTOy (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 7 Dec 2018 14:14:54 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 7C704AD49;
        Fri,  7 Dec 2018 19:14:52 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 41886DA6F5; Fri,  7 Dec 2018 20:14:31 +0100 (CET)
Date:   Fri, 7 Dec 2018 20:14:31 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Omar Sandoval <osandov@osandov.com>
Cc:     linux-btrfs@vger.kernel.org, kernel-team@fb.com
Subject: Re: [PATCH] libbtrfsutil: fix unprivileged tests if kernel lacks
 support
Message-ID: <20181207191431.GG23615@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Omar Sandoval <osandov@osandov.com>,
        linux-btrfs@vger.kernel.org, kernel-team@fb.com
References: <a75b30c33c1b7aa0abc4403338d19a03526303c1.1544142538.git.osandov@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a75b30c33c1b7aa0abc4403338d19a03526303c1.1544142538.git.osandov@fb.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Thu, Dec 06, 2018 at 04:29:32PM -0800, Omar Sandoval wrote:
> From: Omar Sandoval <osandov@fb.com>
> 
> I apparently didn't test this on a pre-4.18 kernel.
> test_subvolume_info_unprivileged() checks for an ENOTTY, but this
> doesn't seem to work correctly with subTest().
> test_subvolume_iterator_unprivileged() doesn't have a check at all. Add
> an explicit check to both before doing the actual test.
> 
> Signed-off-by: Omar Sandoval <osandov@fb.com>

Applied, thanks.
