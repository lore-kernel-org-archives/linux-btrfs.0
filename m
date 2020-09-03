Return-Path: <SRS0=42cL=CM=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 658F1C433E9
	for <linux-btrfs@archiver.kernel.org>; Thu,  3 Sep 2020 11:48:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 32F5F206EB
	for <linux-btrfs@archiver.kernel.org>; Thu,  3 Sep 2020 11:48:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728723AbgICLrn (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 3 Sep 2020 07:47:43 -0400
Received: from mx2.suse.de ([195.135.220.15]:45570 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728623AbgICLqV (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 3 Sep 2020 07:46:21 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 1CD48AC55;
        Thu,  3 Sep 2020 11:46:09 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 9C2F9DA6E0; Thu,  3 Sep 2020 13:44:55 +0200 (CEST)
Date:   Thu, 3 Sep 2020 13:44:55 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Qu Wenruo <wqu@suse.com>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2] btrfs: Only require sector size alignment for parent
 eb bytenr
Message-ID: <20200903114455.GS28318@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org
References: <20200826092643.113881-1-wqu@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200826092643.113881-1-wqu@suse.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Wed, Aug 26, 2020 at 05:26:43PM +0800, Qu Wenruo wrote:
> @@ -429,8 +429,9 @@ int btrfs_get_extent_inline_ref_type(const struct extent_buffer *eb,
>  	}
>  
>  	btrfs_print_leaf((struct extent_buffer *)eb);
> -	btrfs_err(eb->fs_info, "eb %llu invalid extent inline ref type %d",
> -		  eb->start, type);
> +	btrfs_err(eb->fs_info,
> +		  "eb %llu iref 0x%lu invalid extent inline ref type %d",

0x needs %lx, fixed and added to misc-next, thanks.
