Return-Path: <SRS0=5Bfi=RA=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_NEOMUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 656F3C43381
	for <linux-btrfs@archiver.kernel.org>; Mon, 25 Feb 2019 15:46:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 27E952087C
	for <linux-btrfs@archiver.kernel.org>; Mon, 25 Feb 2019 15:46:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20150623.gappssmtp.com header.i=@toxicpanda-com.20150623.gappssmtp.com header.b="K5aAcGkL"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727765AbfBYPqH (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 25 Feb 2019 10:46:07 -0500
Received: from mail-yb1-f194.google.com ([209.85.219.194]:45156 "EHLO
        mail-yb1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727638AbfBYPqG (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 25 Feb 2019 10:46:06 -0500
Received: by mail-yb1-f194.google.com with SMTP id c76so2466764ybf.12
        for <linux-btrfs@vger.kernel.org>; Mon, 25 Feb 2019 07:46:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to
         :user-agent;
        bh=+3AqGD3YK4Nm3j2P9atW6CaGg7U9HCP8PTU+T6zAlH0=;
        b=K5aAcGkLklU6P9k0qAIx0+utRQghgG0SyYL7TgtguogBpbsivezL5FJEGruG19ipX2
         ls7gKUNMW8Hn/83kmCN701puli6RIdk3P19NG+tKDtthl+JZ3rXaYVYqx527N356NSja
         OEQwMMGzFtiMBz25zWRPvr33G79lbxPrnSMl/Z6d8xGD+edrca3A95vC4Cnl26kS+yq7
         a1ULGdqrwee4S6D1c0PnAxhA3p1W1c4Cp7QEKBZ5Qhw89lUJRfYkiKNijj534wgF8I/C
         OTHbFyXw09bgvmt9sq0NQYoXgxhnhNubBJW7RHBumUHhda72X/nktqjYJZVGCvGuV7qo
         p/sA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=+3AqGD3YK4Nm3j2P9atW6CaGg7U9HCP8PTU+T6zAlH0=;
        b=WDpLP9nt2aur8O/h1tmJrbLZ0Sg0FLsOyPrBSX8dSMSlm8AeT+x5CwFvNhoYgjxvJ/
         rTZYXgLLJ8GitXKNXZatj1ZkV3D0bAeZaXsNgdB1qcP8gCJSD81H4o/wPEPgXlRpCfJT
         iijvE+KslalDeE+p2KtIbuW3IgQdoFiotnpV6e0tPdlHaQY2o8rcE1WGlzbIYUZb/E1d
         mJ6tgOeG/7K5fDzoNt0KM2aRs0MRm6utNSjVnWylD60gVFvrI3ZG1BE1DqurBp7wBV24
         V5jCjWzSCNBMEa0vv75LW6/FM5Sx+djSWDYl4GKQY7XBbfDPbQKfkZswsl3QTe1GL8XH
         YS3g==
X-Gm-Message-State: AHQUAuaJW4OlTwyw+INopudbDp98RcJhZ3r7lMf8bFDqQmj69FaOXEOM
        o+ecHaEkTK/Kc5+cNXPxFV84Vx2nvFw=
X-Google-Smtp-Source: AHgI3Ia2WoAa0EEp8DMjCi0ISiMJKhp/4pSV/1ITlhMB1MCvPK5IpIUxbzPIWlkzLChDS8eo84MGYA==
X-Received: by 2002:a25:c087:: with SMTP id c129mr15006420ybf.320.1551109565881;
        Mon, 25 Feb 2019 07:46:05 -0800 (PST)
Received: from localhost ([2620:10d:c091:180::1:917f])
        by smtp.gmail.com with ESMTPSA id g21sm3293065ywk.16.2019.02.25.07.46.04
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 25 Feb 2019 07:46:04 -0800 (PST)
Date:   Mon, 25 Feb 2019 10:46:03 -0500
From:   Josef Bacik <josef@toxicpanda.com>
To:     David Sterba <dsterba@suse.cz>
Cc:     Qu Wenruo <quwenruo.btrfs@gmx.com>, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org, josef@toxicpanda.com
Subject: Re: [PATCH] btrfs: Use struct inode* to replace
 extent_io_tree::private_data
Message-ID: <20190225154602.gsrmmp465l7rnkm3@macbook-pro-91.dhcp.thefacebook.com>
References: <20190225055043.1621-1-wqu@suse.com>
 <20190225121540.GN9874@twin.jikos.cz>
 <7a8afd82-7acf-e2cc-deff-38ccf702ef2d@gmx.com>
 <20190225122657.GP9874@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20190225122657.GP9874@twin.jikos.cz>
User-Agent: NeoMutt/20180716
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Mon, Feb 25, 2019 at 01:26:57PM +0100, David Sterba wrote:
> On Mon, Feb 25, 2019 at 08:17:52PM +0800, Qu Wenruo wrote:
> > 
> > 
> > On 2019/2/25 下午8:15, David Sterba wrote:
> > > On Mon, Feb 25, 2019 at 01:50:43PM +0800, Qu Wenruo wrote:
> > >> All users of extent_io_tree::private_data are expecting struct inode*.
> > >> So just use struct inode* to replace extent_io_tree::private_data, and
> > >> this should provide better type check.
> > >>
> > >> Signed-off-by: Qu Wenruo <wqu@suse.com>
> > >>  struct extent_io_tree {
> > >>  	struct rb_root state;
> > >> -	void *private_data;
> > >> +	struct inode *inode;
> > >>  	u64 dirty_bytes;
> > >>  	int track_uptodate;
> > >>  	spinlock_t lock;
> > > 
> > > So this is effectively reverting c6100a4b4e3d1650deafd ("Btrfs: replace
> > > tree->mapping with tree->private_data"),
> > 
> > That commit message doesn't explain why this is needed for btree_inode
> > removal.
> > 
> > Any idea what the extra type would be used in that case?
> 
> I don't know, Josef in CC to answer that.

Yeah there's a mapping tree thing I make to keep track of the metadata, it holds
the radix tree for the eb's and a bunch of other stuff.  This needs to stay a
void *.  Thanks,

Josef
