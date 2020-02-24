Return-Path: <SRS0=op+e=4M=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8851EC11D2F
	for <linux-btrfs@archiver.kernel.org>; Mon, 24 Feb 2020 16:03:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6428520828
	for <linux-btrfs@archiver.kernel.org>; Mon, 24 Feb 2020 16:03:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727934AbgBXQDF (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 24 Feb 2020 11:03:05 -0500
Received: from mx2.suse.de ([195.135.220.15]:41282 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727730AbgBXQDF (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 24 Feb 2020 11:03:05 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 1D9EEAE48;
        Mon, 24 Feb 2020 16:03:04 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 7C54EDA727; Mon, 24 Feb 2020 17:02:45 +0100 (CET)
Date:   Mon, 24 Feb 2020 17:02:45 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Nikolay Borisov <nborisov@suse.com>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v3 0/2] Refactor snapshot vs nocow writers locking
Message-ID: <20200224160245.GX2902@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Nikolay Borisov <nborisov@suse.com>,
        linux-btrfs@vger.kernel.org
References: <20200224152637.30774-1-nborisov@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200224152637.30774-1-nborisov@suse.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Mon, Feb 24, 2020 at 05:26:35PM +0200, Nikolay Borisov wrote:
> Here is v3 of the DRW locking patches.

As discussed, let's rename it to DREW locks, where E stands for
exclusion: double reader/writer exclusion.
