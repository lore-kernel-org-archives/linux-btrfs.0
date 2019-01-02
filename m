Return-Path: <SRS0=VtQK=PK=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 999F5C43387
	for <linux-btrfs@archiver.kernel.org>; Wed,  2 Jan 2019 17:57:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 791D6218D3
	for <linux-btrfs@archiver.kernel.org>; Wed,  2 Jan 2019 17:57:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726951AbfABR5N (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 2 Jan 2019 12:57:13 -0500
Received: from mx2.suse.de ([195.135.220.15]:53840 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726240AbfABR5N (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 2 Jan 2019 12:57:13 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id DA5B3ADFF;
        Wed,  2 Jan 2019 17:57:11 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 651B5DA781; Wed,  2 Jan 2019 18:56:43 +0100 (CET)
Date:   Wed, 2 Jan 2019 18:56:43 +0100
From:   David Sterba <dsterba@suse.cz>
To:     fdmanana@kernel.org
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2] Btrfs: do not overwrite scrub error with fault error
 in scrub ioctl
Message-ID: <20190102175643.GE23615@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, fdmanana@kernel.org,
        linux-btrfs@vger.kernel.org
References: <20181214194459.21691-1-fdmanana@kernel.org>
 <20181214195017.17822-1-fdmanana@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181214195017.17822-1-fdmanana@kernel.org>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Fri, Dec 14, 2018 at 07:50:17PM +0000, fdmanana@kernel.org wrote:
> From: Filipe Manana <fdmanana@suse.com>
> 
> If scrub returned an error and then the copy_to_user() call did not
> succeed, we would overwrite the error returned by scrub with -EFAULT.
> Fix that by removing the call to copy_to_user() as there is no need
> to do it at all.
> 
> Signed-off-by: Filipe Manana <fdmanana@suse.com>
> ---
> 
> V2: Leave to copy_to_user() call since progress needs to be reported back
>     to user space.

The changelog does not reflect v2, I'll update the last sentence to

"Fix that by calling copy_to_user() only if btrfs_scrub_dev returned
success."

Thanks.

Reviewed-by: David Sterba <dsterba@suse.com>
