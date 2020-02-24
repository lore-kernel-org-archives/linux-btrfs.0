Return-Path: <SRS0=op+e=4M=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 00314C11D2F
	for <linux-btrfs@archiver.kernel.org>; Mon, 24 Feb 2020 15:16:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D29422082F
	for <linux-btrfs@archiver.kernel.org>; Mon, 24 Feb 2020 15:16:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727742AbgBXPQm (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 24 Feb 2020 10:16:42 -0500
Received: from mx2.suse.de ([195.135.220.15]:44734 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727359AbgBXPQm (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 24 Feb 2020 10:16:42 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 6DD66AC6B;
        Mon, 24 Feb 2020 15:16:40 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id CE335DA727; Mon, 24 Feb 2020 16:16:21 +0100 (CET)
Date:   Mon, 24 Feb 2020 16:16:21 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Nikolay Borisov <nborisov@suse.com>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: Fix uninitialized ret in
 btrfsic_process_superblock_dev_mirror
Message-ID: <20200224151621.GV2902@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Nikolay Borisov <nborisov@suse.com>,
        linux-btrfs@vger.kernel.org
References: <20200224125628.27121-1-nborisov@suse.com>
 <e51b2144-a4a1-2c10-3bf8-991a1347dbc9@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <e51b2144-a4a1-2c10-3bf8-991a1347dbc9@suse.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Mon, Feb 24, 2020 at 02:57:00PM +0200, Nikolay Borisov wrote:
> 
> 
> On 24.02.20 г. 14:56 ч., Nikolay Borisov wrote:
> > We could return ret uninitlaized in case of success. Before the code was
> > returning 0 explicitly in case of success but now it will be a random value from
> > the stack. That's due to ret being set only in error conditions.
> > 
> > Signed-off-by: Nikolay Borisov <nborisov@suse.com>
> 
> This ideally has to be folded in:
> 5a03d907a555 ("btrfs: remove buffer_heads form super block mirror
> integrity checking")

Folded and pushed, thanks.
