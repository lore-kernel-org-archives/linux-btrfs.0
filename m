Return-Path: <SRS0=hUT/=SD=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A7816C43381
	for <linux-btrfs@archiver.kernel.org>; Mon,  1 Apr 2019 18:25:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 77C1220883
	for <linux-btrfs@archiver.kernel.org>; Mon,  1 Apr 2019 18:25:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728744AbfDASZh (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 1 Apr 2019 14:25:37 -0400
Received: from mx2.suse.de ([195.135.220.15]:42254 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728007AbfDASZg (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 1 Apr 2019 14:25:36 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id C07F7AC5B
        for <linux-btrfs@vger.kernel.org>; Mon,  1 Apr 2019 18:25:35 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id D8A20DA823; Mon,  1 Apr 2019 20:26:44 +0200 (CEST)
Date:   Mon, 1 Apr 2019 20:26:40 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Nikolay Borisov <nborisov@suse.com>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v4 03/15] btrfs: Handle pending/pinned chunks before
 blockgroup relocation during device shrink
Message-ID: <20190401182639.GZ29086@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Nikolay Borisov <nborisov@suse.com>,
        linux-btrfs@vger.kernel.org
References: <20190327122418.24027-1-nborisov@suse.com>
 <20190327122418.24027-4-nborisov@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190327122418.24027-4-nborisov@suse.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Wed, Mar 27, 2019 at 02:24:06PM +0200, Nikolay Borisov wrote:
> During device shrink pinned/pending chunks (i.e those which have been
> deleted/created respectively, in the current transaction and haven't
> touched disk) need to be accounted when doing device shrink. Presently
> this happens after the main relocation loop in btrfs_shrink_device,
> which could lead to making another go in the body of the function.
> 
> Since there is no hard requirement to perform pinned/pending chunks
> handling after the relocation loop, move the code before it. This leads
> to simplifying the code flow around - i.e no need to use 'goto again'.

On the other hand this starts 2 transactions unconditionally, previously
it was 1 for the final change and 1 if there were pending chunks. This
should be mentioned or explained why this is needed, otherwise the code
looks equivalent to the original version. In this case some guidance in
the changelog could shorten the time to understand the change, I've been
starting at it for half an hour.
