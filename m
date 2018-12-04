Return-Path: <SRS0=1LDH=ON=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 27CA1C04EB8
	for <linux-btrfs@archiver.kernel.org>; Tue,  4 Dec 2018 12:17:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EA54F20851
	for <linux-btrfs@archiver.kernel.org>; Tue,  4 Dec 2018 12:17:28 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org EA54F20851
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726134AbeLDMR1 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 4 Dec 2018 07:17:27 -0500
Received: from mx2.suse.de ([195.135.220.15]:57270 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725767AbeLDMR1 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 4 Dec 2018 07:17:27 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id AA87BB0E8
        for <linux-btrfs@vger.kernel.org>; Tue,  4 Dec 2018 12:17:24 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id A5115DA7A3; Tue,  4 Dec 2018 13:17:05 +0100 (CET)
Date:   Tue, 4 Dec 2018 13:17:04 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Qu Wenruo <wqu@suse.com>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 7/9] btrfs-progs: Fix Wmaybe-uninitialized warning
Message-ID: <20181204121704.GL17773@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org
References: <20181116075426.4142-1-wqu@suse.com>
 <20181116075426.4142-8-wqu@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181116075426.4142-8-wqu@suse.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Fri, Nov 16, 2018 at 03:54:24PM +0800, Qu Wenruo wrote:
> The only location is the following code:
> 
> 	int level = path->lowest_level + 1;
>  	BUG_ON(path->lowest_level + 1 >= BTRFS_MAX_LEVEL);
>  	while(level < BTRFS_MAX_LEVEL) {
> 		slot = path->slots[level] + 1;
> 		...
> 	}
> 	path->slots[level] = slot;
> 
> Again, it's the stupid compiler needs some hint for the fact that
> we will always enter the while loop for at least once, thus @slot should
> always be initialized.

Harsh words for the compiler, and I say not deserved. The same code
pasted to kernel a built with the same version does not report the
warning, so it's apparently a missing annotation of BUG_ON in
btrfs-progs that does not give the right hint.
