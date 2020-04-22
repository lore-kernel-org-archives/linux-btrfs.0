Return-Path: <SRS0=dx4s=6G=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_2 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 650EBC5518A
	for <linux-btrfs@archiver.kernel.org>; Wed, 22 Apr 2020 10:05:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1A15520CC7
	for <linux-btrfs@archiver.kernel.org>; Wed, 22 Apr 2020 10:05:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nic.cz header.i=@nic.cz header.b="mUtpTGhF"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728100AbgDVKE6 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 22 Apr 2020 06:04:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726596AbgDVKE4 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 22 Apr 2020 06:04:56 -0400
Received: from mail.nic.cz (mail.nic.cz [IPv6:2001:1488:800:400::400])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70EC4C03C1A8;
        Wed, 22 Apr 2020 03:04:55 -0700 (PDT)
Received: from localhost (unknown [172.20.6.135])
        by mail.nic.cz (Postfix) with ESMTPSA id 2811A14088B;
        Wed, 22 Apr 2020 12:04:53 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=nic.cz; s=default;
        t=1587549893; bh=wwTHWAA9E3wrvopb0/Q15y7NVHabmvXLjzRlaQnJhH0=;
        h=Date:From:To;
        b=mUtpTGhFVAgHMSd4KqmJUW9YqSx22n5pxbBQFB2fuyo3oSwNzVRvJ9CjTvrvvnFbX
         hc7I1eoSwhlf9laDlCYSRfL0/9zztT/57n+1jLAOHNOcdvb5SEDPtk8lS97o8c8Yzl
         xk62TaLMeNr61caXobiH32Q12i2Ln2zWwlAJYHQ0=
Date:   Wed, 22 Apr 2020 12:04:51 +0200
From:   Marek Behun <marek.behun@nic.cz>
To:     Su Yue <Damenly_Su@gmx.com>
Cc:     Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org,
        fstests@vger.kernel.org, u-boot@lists.denx.de
Subject: Re: [PATCH U-BOOT 18/26] fs: btrfs: Implement btrfs_lookup_path()
Message-ID: <20200422120451.5864d812@nic.cz>
In-Reply-To: <368vvoni.fsf@gmx.com>
References: <20200422065009.69392-1-wqu@suse.com>
        <20200422065009.69392-19-wqu@suse.com>
        <368vvoni.fsf@gmx.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Virus-Scanned: clamav-milter 0.101.4 at mail
X-Virus-Status: Clean
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Wed, 22 Apr 2020 17:46:25 +0800
Su Yue <Damenly_Su@gmx.com> wrote:

> > +	while (*cur != '\0') {
> > +
> > +		cur = skip_current_directories(cur);
> > +		len = next_length(cur);
> > +		if (len > BTRFS_NAME_LEN) {  
> 
> next_length() promises @len <= BTRFS_NAME_LEN, so the check is trivial.

Hmm. This is a bug in next_length. I meant for next_length to return
len > BTRFS_NAME_LEN in case of too long name. Thanks for noticing.

> > +			ret = btrfs_readlink(root, ino, target);
> > +			if (ret < 0) {
> > +				free(target);
> > +				return ret;
> > +			}
> > +			target[ret] = '\0';  
> 
> It was done in btrfs_readlink() already.

It is in old btrfs_readlink, but is it even after this patches? I don't
see it in the new implementation.

> > +
> > +			ret = btrfs_lookup_path(root, ino, target, &next_root,
> > +						&next_ino, &next_type,
> > +						symlink_limit);  
> 
> Just notify gentlely this is a recursive call here. I don't know
> whether uboot cares about stack things. But, recursion makes coding simpler :).

It is limited by symlink_limit. Until somebody complains about stack
issues I would like to keep it simple.
