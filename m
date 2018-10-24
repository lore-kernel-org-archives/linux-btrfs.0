Return-Path: <SRS0=Pubh=NE=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DE621C004D3
	for <linux-btrfs@archiver.kernel.org>; Wed, 24 Oct 2018 15:14:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AE9FD207DD
	for <linux-btrfs@archiver.kernel.org>; Wed, 24 Oct 2018 15:14:57 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org AE9FD207DD
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726735AbeJXXnZ (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 24 Oct 2018 19:43:25 -0400
Received: from mx2.suse.de ([195.135.220.15]:43190 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726407AbeJXXnZ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 24 Oct 2018 19:43:25 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 3CD73ACDB
        for <linux-btrfs@vger.kernel.org>; Wed, 24 Oct 2018 15:14:50 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 8F3EFDABAA; Wed, 24 Oct 2018 17:14:42 +0200 (CEST)
Date:   Wed, 24 Oct 2018 17:14:42 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Qu Wenruo <wqu@suse.com>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 0/2] Enhanced error messages for btrfs-convert
Message-ID: <20181024151442.GU16290@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org
References: <20180914072505.15916-1-wqu@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180914072505.15916-1-wqu@suse.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Fri, Sep 14, 2018 at 03:25:03PM +0800, Qu Wenruo wrote:
> This patchset can be fetched from github:
> https://github.com/adam900710/btrfs-progs/tree/convert_error_messages
> As usual, it's based on latest stable tag (v4.17.1).
> 
> There is one error report of btrfs-convert, the error message looks
> pretty meaningless:
> 
>   create btrfs filesystem:
>       blocksize: 4096
>       nodesize:  16384
>       features:  extref, skinny-metadata (default)
>   creating ext2 image file
>   ERROR: failed to create ext2_saved/image: -1
>   WARNING: an error occurred during conversion, filesystem is partially
>   created but not finalized and not mountable
> 
> After some investigation, the problem turns out to be read failure.
> But the error number is intermediate number (-1) returned from
> read_disk_extent().
> 
> This patchset will first fix the intermediate return number of
> read_disk_extent(), then add more error messages for btrfs-convert (at
> least convert part) to makes it easier to identify the problem.
> 
> In this particular case, it should output things like:
> 
>   create btrfs filesystem:
>       blocksize: 4096
>       nodesize:  16384
>       features:  extref, skinny-metadata (default)
>   creating ext2 image file
>   ERROR: failed to calculate csum for bytenr 2732765184 len 4096, Input/output error
>   ERROR: failed to create ext2_saved/image: -5
>   WARNING: an error occurred during conversion, filesystem is partially
>   created but not finalized and not mountable
> 
> 
> Qu Wenruo (2):
>   btrfs: convert: Make read_disk_extent() return more meaningful -EIO
>     other -1
>   btrfs-progs: convert: Output meaningful error messages for
>     create_image()

Added to devel, thanks.
