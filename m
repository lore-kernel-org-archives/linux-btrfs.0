Return-Path: <SRS0=+tZ8=RW=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8A015C43381
	for <linux-btrfs@archiver.kernel.org>; Tue, 19 Mar 2019 18:04:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5461E20811
	for <linux-btrfs@archiver.kernel.org>; Tue, 19 Mar 2019 18:04:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727443AbfCSSEG (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 19 Mar 2019 14:04:06 -0400
Received: from mx2.suse.de ([195.135.220.15]:41956 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727178AbfCSSEF (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 19 Mar 2019 14:04:05 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id D3B45AE0A
        for <linux-btrfs@vger.kernel.org>; Tue, 19 Mar 2019 18:04:04 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 8C325DAC36; Tue, 19 Mar 2019 19:05:20 +0100 (CET)
Date:   Tue, 19 Mar 2019 19:05:20 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Qu Wenruo <wqu@suse.com>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 1/2] btrfs: Make btrfs_(set|clear)_header_flag return void
Message-ID: <20190319180520.GO3516@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org
References: <20190319060418.29575-1-wqu@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190319060418.29575-1-wqu@suse.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Tue, Mar 19, 2019 at 02:04:17PM +0800, Qu Wenruo wrote:
> >From the introduce of btrfs_(set|clear)_header_flag, there is no usage
> of its return value.
> 
> So just make it return void.
> 
> Signed-off-by: Qu Wenruo <wqu@suse.com>

This is an independent patch so I'll add it to misc-next, thanks.

Reviewed-by: David Sterba <dsterba@suse.com>
