Return-Path: <SRS0=IMPl=S2=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A80C8C10F11
	for <linux-btrfs@archiver.kernel.org>; Wed, 24 Apr 2019 13:37:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7C0AE21773
	for <linux-btrfs@archiver.kernel.org>; Wed, 24 Apr 2019 13:37:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727512AbfDXNh5 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 24 Apr 2019 09:37:57 -0400
Received: from mx2.suse.de ([195.135.220.15]:35422 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727112AbfDXNh5 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 24 Apr 2019 09:37:57 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 4B1E5AE03
        for <linux-btrfs@vger.kernel.org>; Wed, 24 Apr 2019 13:37:56 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 37DF4DA85E; Wed, 24 Apr 2019 15:38:57 +0200 (CEST)
Date:   Wed, 24 Apr 2019 15:38:57 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Nikolay Borisov <nborisov@suse.com>
Cc:     dsterba@suse.cz, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: Fix off-by-one error btrfs_trim_free_extents
Message-ID: <20190424133857.GV20156@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Nikolay Borisov <nborisov@suse.com>,
        linux-btrfs@vger.kernel.org
References: <20190424084655.31615-1-nborisov@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190424084655.31615-1-nborisov@suse.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Wed, Apr 24, 2019 at 11:46:55AM +0300, Nikolay Borisov wrote:
> btrfs_trim_free_extents always caps the range it's going to trim based
> on the size of the device. This happens if find_first_clear_extent_bit
> detects that untrimmed range is past the last allocated range. Since it
> doesn't have knowledge of the size of the device it just returns (u64)-1
> for end. Then btrfs_trim_free_extents caps this to device->total_bytes.
> However, btrfs_trim_free_extent calculates 'len' based off of the
> actual usable end byte - in this case total_bytes - 1.
> 
> Signed-off-by: Nikolay Borisov <nborisov@suse.com>
> 
> Fixes: 4d877687cbbc ("btrfs: Switch btrfs_trim_free_extents to find_first_clear_extent_bit")
> ---
> 
> David you might want to squash that in the 'Fixes' commit. With this I see 
> generic/500 passing and also full xfstest didn't uncover any new regressions. 

Folded, thanks.
