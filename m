Return-Path: <SRS0=6Gfh=7H=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A7F26C433E0
	for <linux-btrfs@archiver.kernel.org>; Mon, 25 May 2020 12:38:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 93B9E2071A
	for <linux-btrfs@archiver.kernel.org>; Mon, 25 May 2020 12:38:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390515AbgEYMiM (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 25 May 2020 08:38:12 -0400
Received: from mx2.suse.de ([195.135.220.15]:47216 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390488AbgEYMiM (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 25 May 2020 08:38:12 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 0AC97AD17;
        Mon, 25 May 2020 12:38:14 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 742C0DA728; Mon, 25 May 2020 14:37:14 +0200 (CEST)
Date:   Mon, 25 May 2020 14:37:14 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Ethan Edwards <ethancarteredwards@gmail.com>
Cc:     clm@fb.com, linux-kernel@vger.kernel.org,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] FS: BTRFS: ulist.c: Fixed a brace coding style and space
 before tab
Message-ID: <20200525123714.GR18421@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz,
        Ethan Edwards <ethancarteredwards@gmail.com>, clm@fb.com,
        linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org
References: <20200522212902.20994-1-ethancarteredwards@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200522212902.20994-1-ethancarteredwards@gmail.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Fri, May 22, 2020 at 05:29:02PM -0400, Ethan Edwards wrote:
> From: Ethan Edwards <ethancarteredwards@gmail.com
> 
> Fixed coding style

No thanks.

Long answer: https://btrfs.wiki.kernel.org/index.php/Developer%27s_FAQ#How_not_to_start
