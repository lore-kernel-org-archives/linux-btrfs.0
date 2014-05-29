Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:42278 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753991AbaE2B5T (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 28 May 2014 21:57:19 -0400
Message-ID: <1401328340.12380.19.camel@localhost.localdomain>
Subject: Re: [PATCH 1/3] btrfs-progs: cleanup btrfs-rescue output msgs
From: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
To: <dsterba@suse.cz>
CC: <linux-btrfs@vger.kernel.org>
Date: Thu, 29 May 2014 09:52:20 +0800
In-Reply-To: <20140528162457.GP5346@twin.jikos.cz>
References: <1400117349-2851-1-git-send-email-guihc.fnst@cn.fujitsu.com>
	 <20140528162457.GP5346@twin.jikos.cz>
Content-Type: text/plain; charset="UTF-8"
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, 2014-05-28 at 18:24 +0200, David Sterba wrote:
> On Thu, May 15, 2014 at 09:29:07AM +0800, Gui Hecheng wrote:
> > Use enum defined error codes to represent different kinds of errs
> > for super-recover and chunk-recover.
> 
> I think this change hides the low-level errors (like ENOMEM) that can
> possibly result into "recovery not possible", though it can be restarted
> and could work fine.
> 
> The human readable error messages are good, but should also reflect if
> the error was fatal or not and say "why".
> 
> Examples:
> 
> > @@ -2092,12 +2113,14 @@ int btrfs_recover_chunk_tree(char *path, int verbose, int yes)
> >  	ret = recover_prepare(&rc, path);
> >  	if (ret) {
> >  		fprintf(stderr, "recover prepare error\n");
> > +		ret = ERR_CR_FAILED_TO_RECOVER;
> 
> eg. recover_prepare can fail if it does not find the path or due to ENOMEM
> 
> >  		return ret;
> >  	}
> >  
> >  	ret = scan_devices(&rc);
> >  	if (ret) {
> >  		fprintf(stderr, "scan chunk headers error\n");
> > +		ret = ERR_CR_FAILED_TO_RECOVER;
> 
> device open fails, or ENOMEM
> 
> >  		goto fail_rc;
> >  	}
> 
> So, somehow wrap both values into one and convert into the enhanced
> messages.

Hi David,
Thanks for your advice. I'll rework it soon and resend.

Something to confirm below:

o Actually I've kept almost all the "fprintf"s in the original place as
*low level* messages(except an "PTR_ERR", I'll add it back).
But it seems that the original "fprintf"s do hide low level errors, and
I'll try to enhance them in the original "fprintf"s.

o What I've added are just some *user level* messages which will show
along with the low level messages, bug not replace them.
I would like to just keep this part.

What do you think?

-Gui


