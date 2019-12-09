Return-Path: <SRS0=15Oe=Z7=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8AF2BC00454
	for <linux-btrfs@archiver.kernel.org>; Mon,  9 Dec 2019 18:16:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6ABDA206D3
	for <linux-btrfs@archiver.kernel.org>; Mon,  9 Dec 2019 18:16:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726379AbfLISQ1 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 9 Dec 2019 13:16:27 -0500
Received: from mx2.suse.de ([195.135.220.15]:58188 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726335AbfLISQ1 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 9 Dec 2019 13:16:27 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id DEC37AB98;
        Mon,  9 Dec 2019 18:16:25 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id D1E91DA82A; Mon,  9 Dec 2019 19:16:18 +0100 (CET)
Date:   Mon, 9 Dec 2019 19:16:18 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Josef Bacik <josef@toxicpanda.com>
Cc:     linux-btrfs@vger.kernel.org, kernel-team@fb.com
Subject: Re: [PATCH 0/5] Various fixes
Message-ID: <20191209181618.GP2734@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Josef Bacik <josef@toxicpanda.com>,
        linux-btrfs@vger.kernel.org, kernel-team@fb.com
References: <20191206143718.167998-1-josef@toxicpanda.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191206143718.167998-1-josef@toxicpanda.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Fri, Dec 06, 2019 at 09:37:13AM -0500, Josef Bacik wrote:
> These were discovered while reworking how we handle root refs.  They are all
> relatively straightforward and mostly deal with error cases, with the exception
> of
> 
> [PATCH 1/5] btrfs: drop log root for dropped roots
> [PATCH 4/5] btrfs: skip log replay on orphaned roots
> 
> These two are pretty important and were uncovered with my fsstress patch.  The
> first fixes a space leak in the case that we delete a subvol that has a tree log
> attached to it.  The leak does not persist across mounts so it's not too bad,
> but still pretty important.  The second patch I've only seen in production once
> in the last 90 days, but could keep us from mounting if we have a subvol that
> was deleted with a tree log that we didn't finish deleting.
> 
> The rest of these are just for various error conditions and are less important,
> but should be safe enough to send along now if desired.  Thanks,

2-5 added to misc-next, 1 has some comments. Thanks.
