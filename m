Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:45603 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751808AbcG2RCM (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 29 Jul 2016 13:02:12 -0400
Date: Fri, 29 Jul 2016 19:01:50 +0200
From: David Sterba <dsterba@suse.cz>
To: Liu Bo <bo.li.liu@oracle.com>
Cc: Holger =?iso-8859-1?Q?Hoffst=E4tte?=
	<holger@applied-asynchrony.com>,
        linux-btrfs@vger.kernel.org, David Sterba <dsterba@suse.cz>
Subject: Re: [PATCH] Btrfs: deal with unexpected return value in flush_space
Message-ID: <20160729170150.GE30795@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1469670123-19839-1-git-send-email-bo.li.liu@oracle.com>
 <pan$5450c$1d8fe409$834c6bbc$1311860c@applied-asynchrony.com>
 <20160728184914.GA29799@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20160728184914.GA29799@localhost.localdomain>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jul 28, 2016 at 11:49:14AM -0700, Liu Bo wrote:
> > For reviewers - this came up before here:
> > https://patchwork.kernel.org/patch/7778651/
> > 
> > Same fix basically.
> 
> Aha, I've given it my Reviewed-by.
> 
> Taking either one works for me, I can make the clarifying comment into a
> seperate patch if we need to.

I'll pick the first patch and please send the separate comment update.
Thanks.
