Return-Path: <SRS0=lVOs=ZR=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C2BBAC432C0
	for <linux-btrfs@archiver.kernel.org>; Mon, 25 Nov 2019 13:46:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A09A4207FD
	for <linux-btrfs@archiver.kernel.org>; Mon, 25 Nov 2019 13:46:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727658AbfKYNqZ (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 25 Nov 2019 08:46:25 -0500
Received: from mx2.suse.de ([195.135.220.15]:38440 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727462AbfKYNqZ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 25 Nov 2019 08:46:25 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 99D3EB29C;
        Mon, 25 Nov 2019 13:46:24 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 629E9DA898; Mon, 25 Nov 2019 14:46:22 +0100 (CET)
Date:   Mon, 25 Nov 2019 14:46:21 +0100
From:   David Sterba <dsterba@suse.cz>
To:     fdmanana@kernel.org
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: fix cloning range with a hole when using the
 NO_HOLES feature
Message-ID: <20191125134621.GC2734@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, fdmanana@kernel.org,
        linux-btrfs@vger.kernel.org
References: <20191119120732.24729-1-fdmanana@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191119120732.24729-1-fdmanana@kernel.org>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Tue, Nov 19, 2019 at 12:07:32PM +0000, fdmanana@kernel.org wrote:
> From: Filipe Manana <fdmanana@suse.com>
[...]

Added to misc-next, thanks.
