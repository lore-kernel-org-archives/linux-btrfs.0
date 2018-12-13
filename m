Return-Path: <SRS0=1olR=OW=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1A6F9C65BAE
	for <linux-btrfs@archiver.kernel.org>; Thu, 13 Dec 2018 16:08:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DF8972054F
	for <linux-btrfs@archiver.kernel.org>; Thu, 13 Dec 2018 16:08:05 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org DF8972054F
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729552AbeLMQIE (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 13 Dec 2018 11:08:04 -0500
Received: from mx2.suse.de ([195.135.220.15]:34810 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728718AbeLMQIE (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 13 Dec 2018 11:08:04 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id C2011AEE1;
        Thu, 13 Dec 2018 16:08:02 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 219BCDA7EE; Thu, 13 Dec 2018 17:07:41 +0100 (CET)
Date:   Thu, 13 Dec 2018 17:07:40 +0100
From:   David Sterba <dsterba@suse.cz>
To:     fdmanana@kernel.org
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 3/4] Btrfs: check if destination root is read-only for
 deduplication
Message-ID: <20181213160740.GE23615@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, fdmanana@kernel.org,
        linux-btrfs@vger.kernel.org
References: <20181212180559.15249-1-fdmanana@kernel.org>
 <20181212180559.15249-4-fdmanana@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181212180559.15249-4-fdmanana@kernel.org>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Wed, Dec 12, 2018 at 06:05:58PM +0000, fdmanana@kernel.org wrote:
> From: Filipe Manana <fdmanana@suse.com>
> 
> Checking if the destination root is read-only was being performed only for
> clone operations. Make deduplication check it as well, as it does not make
> sense to not do it, even if it is an operation that does not change the
> file contents (such as defrag for example, which checks first if the root
> is read-only).

And this is also change in user-visible behaviour of dedupe, so this
needs to be verified if it's not breaking existing tools.
