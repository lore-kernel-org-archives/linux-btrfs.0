Return-Path: <SRS0=E4Z9=YI=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E3825ECE588
	for <linux-btrfs@archiver.kernel.org>; Tue, 15 Oct 2019 15:42:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B867D205F4
	for <linux-btrfs@archiver.kernel.org>; Tue, 15 Oct 2019 15:42:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1571154150;
	bh=95hmQLfjm+IZao22sg7YuzL+pTlvV1nZN8TteD1eElk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=xOT+aBasvEHUBRr44YdQ/L8YNhkW/9UZOVfg9Yf8w7xd65fpRo7nCRDRPDRJQqHLH
	 I81YUts//pjha0qWSRApbFhQEeI2hyV8vxTrJABGkyoVVYbW+cWkfL/spCXmviQIa3
	 esmr2T4RcajCLY5jJfjX5ion4T/1AkHty4VJx11s=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728966AbfJOPm3 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 15 Oct 2019 11:42:29 -0400
Received: from mail-qt1-f194.google.com ([209.85.160.194]:39819 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726422AbfJOPm3 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 15 Oct 2019 11:42:29 -0400
Received: by mail-qt1-f194.google.com with SMTP id n7so31186632qtb.6
        for <linux-btrfs@vger.kernel.org>; Tue, 15 Oct 2019 08:42:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=vkjukRMYGkOvQPapFg2EWMbIaB4s2EdbEN222R7K6JE=;
        b=cMDFvz4nZmCm+UTlKirACkHHv6MZmiQjJRC050mdyCnfwV5oTVLPccQy0WBDVNra9Y
         D3P8R514iIl8f8v0EfqJwQYAv+VHgWYMnLrfz9FtNazYgo20Y+NoU7IbpV2lfTlq6Xa+
         Ll5HA2FX+GnmHa0Yz5iE2rZnlgNmn6m2rzsNZUyFyVvZ2gQ3Qa5Uhj608iZh/klycWda
         9FjZ9CAxTci5bfW8ndHwrEJaSTu5BEBQY/6B3ipRi9VUGKTH9xO1AZhJlxDUk2wM9+5W
         w8wNtXDbWWFujlLnAQXpiTmIi9IkdBXEIIDuiXZDyrEQKNZLgXvuJIwg6zQQv8HSHuI2
         hkhw==
X-Gm-Message-State: APjAAAX1Ir6bOPdW0JII8CCfzIMh6jnrsI4ZM5XR8xzZfao3KPvsTLsD
        e1Oz22Aj0INQ76kN9B7lmII=
X-Google-Smtp-Source: APXvYqwQd7qaUpAnAf+YTcpKMjbhYxme3vpzoy1R95IyD6rX9I3Xqt9KyDW9Yp4bjzL4cl+GeJI7Jw==
X-Received: by 2002:ac8:6c9:: with SMTP id j9mr38203846qth.81.1571154148727;
        Tue, 15 Oct 2019 08:42:28 -0700 (PDT)
Received: from dennisz-mbp ([2620:10d:c091:500::c97c])
        by smtp.gmail.com with ESMTPSA id b130sm10172132qkc.100.2019.10.15.08.42.27
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 15 Oct 2019 08:42:28 -0700 (PDT)
Date:   Tue, 15 Oct 2019 11:42:25 -0400
From:   Dennis Zhou <dennis@kernel.org>
To:     David Sterba <dsterba@suse.cz>
Cc:     Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>, Chris Mason <clm@fb.com>,
        Omar Sandoval <osandov@osandov.com>, kernel-team@fb.com,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 15/19] btrfs: load block_groups into discard_list on mount
Message-ID: <20191015154225.GB66037@dennisz-mbp>
References: <cover.1570479299.git.dennis@kernel.org>
 <31ce602fac88f25567a0b3e89037693ec962c1c7.1570479299.git.dennis@kernel.org>
 <20191010171137.xxuhjvmqzgifuixd@macbook-pro-91.dhcp.thefacebook.com>
 <20191014201746.GF40077@dennisz-mbp.dhcp.thefacebook.com>
 <20191014233825.GR2751@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191014233825.GR2751@twin.jikos.cz>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Tue, Oct 15, 2019 at 01:38:25AM +0200, David Sterba wrote:
> On Mon, Oct 14, 2019 at 04:17:46PM -0400, Dennis Zhou wrote:
> > On Thu, Oct 10, 2019 at 01:11:38PM -0400, Josef Bacik wrote:
> > > On Mon, Oct 07, 2019 at 04:17:46PM -0400, Dennis Zhou wrote:
> > > > Async discard doesn't remember the discard state of a block_group when
> > > > unmounting or when we crash. So, any block_group that is not fully used
> > > > may have undiscarded regions. However, free space caches are read in on
> > > > demand. Let the discard worker read in the free space cache so we can
> > > > proceed with discarding rather than wait for the block_group to be used.
> > > > This prevents us from indefinitely deferring discards until that
> > > > particular block_group is reused.
> > > > 
> > > > Signed-off-by: Dennis Zhou <dennis@kernel.org>
> > > 
> > > What if we did completely discard the last time, now we're going back and
> > > discarding again?  I think by default we just assume we discarded everything.
> > > If we didn't then the user can always initiate a fitrim later.  Drop this one.
> > > Thanks,
> > > 
> > 
> > Yeah this is something I wasn't sure about.
> > 
> > It makes me a little uncomfortable to make the lack of persistence a
> > user problem. If in some extreme case where someone frees a large amount
> > of space and then unmounts.
> 
> Based on past experience, umount should not be slowed down unless really
> necessary.
> 
> > We can either make them wait on unmount to
> > discard everything or retrim the whole drive which in an ideal world
> > should just be a noop on already free lba space.
> 
> Without persistence of the state, we can't make it perfect and I think,
> without any hard evidence, that trimming already trimmed blocks is no-op
> on the device. We all know that we don't know what SSDs actually do, so
> it's best effort and making it "device problem" is a good solution from
> filesystem POV.

That makes sense and sounds good to me. I've dropped this patch.

Thanks,
Dennis
