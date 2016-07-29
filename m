Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:26536 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753230AbcG2RtY (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 29 Jul 2016 13:49:24 -0400
Date: Fri, 29 Jul 2016 10:53:15 -0700
From: Liu Bo <bo.li.liu@oracle.com>
To: dsterba@suse.cz
Cc: Holger =?iso-8859-1?Q?Hoffst=E4tte?=
	<holger@applied-asynchrony.com>,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: deal with unexpected return value in flush_space
Message-ID: <20160729175310.GA22477@localhost.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <1469670123-19839-1-git-send-email-bo.li.liu@oracle.com>
 <pan$5450c$1d8fe409$834c6bbc$1311860c@applied-asynchrony.com>
 <20160728184914.GA29799@localhost.localdomain>
 <20160729170150.GE30795@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20160729170150.GE30795@twin.jikos.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jul 29, 2016 at 07:01:50PM +0200, David Sterba wrote:
> On Thu, Jul 28, 2016 at 11:49:14AM -0700, Liu Bo wrote:
> > > For reviewers - this came up before here:
> > > https://patchwork.kernel.org/patch/7778651/

David, this patch made a mistake in commit log.

> > > 
> > > Same fix basically.
> > 
> > Aha, I've given it my Reviewed-by.
> > 
> > Taking either one works for me, I can make the clarifying comment into a
> > seperate patch if we need to.
> 
> I'll pick the first patch and please send the separate comment update.
> Thanks.

Sure.

Thanks,

-liubo
