Return-Path: <SRS0=1LDH=ON=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CE51BC04EB8
	for <linux-btrfs@archiver.kernel.org>; Tue,  4 Dec 2018 10:20:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 914EB2082D
	for <linux-btrfs@archiver.kernel.org>; Tue,  4 Dec 2018 10:20:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 914EB2082D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725910AbeLDKU2 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 4 Dec 2018 05:20:28 -0500
Received: from mx2.suse.de ([195.135.220.15]:37400 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725613AbeLDKU2 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 4 Dec 2018 05:20:28 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 623C1AE78
        for <linux-btrfs@vger.kernel.org>; Tue,  4 Dec 2018 10:20:26 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id C024FDA907; Tue,  4 Dec 2018 11:20:07 +0100 (CET)
Date:   Tue, 4 Dec 2018 11:20:06 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Qu Wenruo <wqu@suse.com>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2 1/5] btrfs-progs: image: Refactor fixup_devices() to
 fixup_chunks_and_devices()
Message-ID: <20181204102005.GF17773@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org
References: <20181127083828.23861-1-wqu@suse.com>
 <20181127083828.23861-2-wqu@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181127083828.23861-2-wqu@suse.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Tue, Nov 27, 2018 at 04:38:24PM +0800, Qu Wenruo wrote:
> +error:
> +	error(
> +"failed to fix chunks and devices mapping, the fs may not be mountable: %s",
> +		strerror(-ret));

Recently the sterror(error code) have been converted to %m, so I changed
this to

	errno = -ret
	error("... %m");
