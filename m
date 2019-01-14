Return-Path: <SRS0=huBW=PW=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.5 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 11A6CC43387
	for <linux-btrfs@archiver.kernel.org>; Mon, 14 Jan 2019 14:21:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D1CF320873
	for <linux-btrfs@archiver.kernel.org>; Mon, 14 Jan 2019 14:21:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1547475669;
	bh=zRFQ8dtNvtcRIC5svnGx0c9J2AKxPJiMm+I5g4Ij5CY=;
	h=Date:From:To:Subject:References:In-Reply-To:List-ID:From;
	b=jDUCTz5+ONCllauQo7J36sz1dqxAHQdPi9zwHZ9eXyN77bu2pAeTHD8MYBxoSbtAC
	 mGNQ2bZluEjbLde/leaKnyLSxWBRBuOY4ucNFkaOpHEB+vyr/7wY3noWEn6ZTZVLde
	 FZyD5ezSrky07r7BR5XptKmXVXWz4m6A/IIdDtpM=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726586AbfANOVJ (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 14 Jan 2019 09:21:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:60426 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726470AbfANOVI (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 14 Jan 2019 09:21:08 -0500
Received: from localhost (unknown [178.227.249.135])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A03FA20651;
        Mon, 14 Jan 2019 14:21:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1547475668;
        bh=zRFQ8dtNvtcRIC5svnGx0c9J2AKxPJiMm+I5g4Ij5CY=;
        h=Date:From:To:Subject:References:In-Reply-To:From;
        b=UQVOIEoaZlqZxR4HFXGfLZcXbCUV0X+tMa7GNN6Mh0lAnzT/ahQbZIM7DnyEWzq4I
         LtCR7ZHuhcGLXrdbQY/jgFKXYFw0mr+vbqSoBziXvymlHvUI9k7HlmvV5/hlboyODU
         FEKR+PFyfhCak34feMIQhSBwSQYFWPH0sYs9rrXU=
Date:   Mon, 14 Jan 2019 15:21:04 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     dsterba@suse.cz, Chris Mason <clm@fb.com>,
        Josef Bacik <josef@toxicpanda.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: no need to check return value of debugfs_create
 functions
Message-ID: <20190114142104.GA12343@kroah.com>
References: <20190104132520.GA22613@kroah.com>
 <20190104134449.GL23615@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190104134449.GL23615@suse.cz>
User-Agent: Mutt/1.11.2 (2019-01-07)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Fri, Jan 04, 2019 at 02:44:49PM +0100, David Sterba wrote:
> On Fri, Jan 04, 2019 at 02:25:20PM +0100, Greg Kroah-Hartman wrote:
> > When calling debugfs functions, there is no need to ever check the
> > return value.  The function can work or not, but the code logic should
> > never do something different based on this.
> > 
> > Cc: Chris Mason <clm@fb.com>
> > Cc: Josef Bacik <josef@toxicpanda.com>
> > Cc: David Sterba <dsterba@suse.com>
> > Cc: linux-btrfs@vger.kernel.org
> > Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > ---
> >  fs/btrfs/sysfs.c | 10 ++--------
> >  1 file changed, 2 insertions(+), 8 deletions(-)
> > 
> > Meta-comment, why is there a btrfs debugfs directory at all?  All you
> > have here is a single "test" file that doesn't do anything except expose
> > a variable that never changes.  What is this directory and single file
> > for?  Can I just delete the whole thing?
> 
> As explained in the commit that introduces the function
> (1bae30982bc86ab66d61ccb):
> 
>   Help during debugging to export various interesting infromation and
>   tunables without the need of extra mount options or ioctls.
> 
>   Usage:
>   * declare your variable in sysfs.h, and include where you need it
>   * define the variable in sysfs.c and make it visible via
>     debugfs_create_TYPE
> 
>   Depends on CONFIG_DEBUG_FS.
> 
> It's there for developers, so don't delete it. Which also means the
> error code should be handled and not ignored.

If no one has used it, why keep it?

Anyway, if you want it there, that's fine, but no, the error message can
be ignored.  You should never have a different code flow if a debugfs
call fails or not.  So the patch I posted here is still correct and
should be applied.

> I can enhance the comment so it's explained in-place and not too
> tempting to remove it. This is not the first time somebody wants to
> remove it
> (https://lore.kernel.org/linux-btrfs/d6715b5b-0aa3-3032-43c6-eccd907a60b8@redhat.com/),

If it keeps wanting to get removed, that's a big hint maybe you should :)

thanks,

greg k-h
