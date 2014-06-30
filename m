Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:49198 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753407AbaF3Bx1 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 29 Jun 2014 21:53:27 -0400
Message-ID: <1404092877.1748.1.camel@localhost.localdomain>
Subject: Re: [PATCH 5/6] btrfs-progs: limit minimal num of args for
 btrfs-image
From: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
To: <dsterba@suse.cz>
CC: <linux-btrfs@vger.kernel.org>
Date: Mon, 30 Jun 2014 09:47:57 +0800
In-Reply-To: <20140627123528.GC1553@twin.jikos.cz>
References: <1403751186-31559-1-git-send-email-guihc.fnst@cn.fujitsu.com>
	 <1403751186-31559-5-git-send-email-guihc.fnst@cn.fujitsu.com>
	 <20140627123528.GC1553@twin.jikos.cz>
Content-Type: text/plain; charset="UTF-8"
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, 2014-06-27 at 14:35 +0200, David Sterba wrote:
> On Thu, Jun 26, 2014 at 10:53:05AM +0800, Gui Hecheng wrote:
> > @@ -2521,6 +2521,9 @@ int main(int argc, char *argv[])
> >  	}
> >  
> >  	argc = argc - optind;
> > +	if (argc < 2)
> 
> Please use the check_argc_min helper instead. Thanks.

Yes, actually I just wanted to prevent including "btrfs.c" in
btrfs-image.c.
I will move the check_argc_* functions into utils.c and resend. Thanks,
David.

-Gui
> 
> > +		print_usage();
> > +
> >  	dev_cnt = argc - 1;
> >  
> >  	if (create) {


