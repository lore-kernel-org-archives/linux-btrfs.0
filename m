Return-Path: <SRS0=RfiN=UY=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 38FDAC48BD5
	for <linux-btrfs@archiver.kernel.org>; Tue, 25 Jun 2019 18:12:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 11EA02054F
	for <linux-btrfs@archiver.kernel.org>; Tue, 25 Jun 2019 18:12:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730300AbfFYSMf (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 25 Jun 2019 14:12:35 -0400
Received: from mx2.suse.de ([195.135.220.15]:42256 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725921AbfFYSMf (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 25 Jun 2019 14:12:35 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 273E5AC70
        for <linux-btrfs@vger.kernel.org>; Tue, 25 Jun 2019 18:12:34 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 82977DA8F6; Tue, 25 Jun 2019 20:13:17 +0200 (CEST)
Date:   Tue, 25 Jun 2019 20:13:17 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Goldwyn Rodrigues <rgoldwyn@suse.de>
Cc:     linux-btrfs@vger.kernel.org, Goldwyn Rodrigues <rgoldwyn@suse.com>
Subject: Re: [PATCH] btrfs: Simplify update space_info in
 __reserve_metadata_bytes()
Message-ID: <20190625181316.GW8917@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Goldwyn Rodrigues <rgoldwyn@suse.de>,
        linux-btrfs@vger.kernel.org, Goldwyn Rodrigues <rgoldwyn@suse.com>
References: <20190619141249.23001-1-rgoldwyn@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190619141249.23001-1-rgoldwyn@suse.de>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Wed, Jun 19, 2019 at 09:12:49AM -0500, Goldwyn Rodrigues wrote:
> From: Goldwyn Rodrigues <rgoldwyn@suse.com>
> 
> Simplification.
> We don't need an if-else-if structure where we can use a
> simple OR since both conditions are performing the
> same action. The short-circuit for OR will ensure that if
> the first condition is true, can_overcommit() is not
> called.
> 
> Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>

Added to misc-next, thanks.
