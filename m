Return-Path: <SRS0=+IVA=WD=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 872BAC433FF
	for <linux-btrfs@archiver.kernel.org>; Wed,  7 Aug 2019 14:57:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 68A0521E73
	for <linux-btrfs@archiver.kernel.org>; Wed,  7 Aug 2019 14:57:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388240AbfHGO5s (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 7 Aug 2019 10:57:48 -0400
Received: from mx2.suse.de ([195.135.220.15]:41178 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2387915AbfHGO5r (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 7 Aug 2019 10:57:47 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 4707AACB7;
        Wed,  7 Aug 2019 14:57:46 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id EAA36DA7D7; Wed,  7 Aug 2019 16:58:17 +0200 (CEST)
Date:   Wed, 7 Aug 2019 16:58:17 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Josef Bacik <josef@toxicpanda.com>
Cc:     kernel-team@fb.com, linux-btrfs@vger.kernel.org, nborisov@suse.com
Subject: Re: [PATCH 15/15] btrfs: remove comment and leftover cruft
Message-ID: <20190807145817.GW28208@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Josef Bacik <josef@toxicpanda.com>,
        kernel-team@fb.com, linux-btrfs@vger.kernel.org, nborisov@suse.com
References: <20190806162837.15840-1-josef@toxicpanda.com>
 <20190806162837.15840-16-josef@toxicpanda.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190806162837.15840-16-josef@toxicpanda.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Tue, Aug 06, 2019 at 12:28:37PM -0400, Josef Bacik wrote:
> Commit "btrfs: convert snapshot/nocow exlcusion to drw lock" removed
> this code, but didn't remove the comment or the definitions, do that
> now.

The DRW lock patchset is in for-next just as a preview and for early
testing so any fixups should be folded to the original patchset.
