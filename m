Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:35694 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932762AbaFQSPv (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 17 Jun 2014 14:15:51 -0400
Date: Tue, 17 Jun 2014 11:15:49 -0700
From: Marc MERLIN <marc@merlins.org>
To: Holger =?iso-8859-1?Q?Hoffst=E4tte?=
	<holger.hoffstaette@googlemail.com>,
        Wang Shilong <wangsl.fnst@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org, "dsterba@suse.cz Sterba" <dsterba@suse.cz>
Subject: Re: Transaction commit: none (default)
Message-ID: <20140617181549.GN19071@merlins.org>
References: <20140614160554.GP6584@merlins.org> <539E49DB.80305@cn.fujitsu.com> <20140616014739.GB19071@merlins.org> <pan.2014.06.16.07.06.08@googlemail.com> <539E9841.8040108@cn.fujitsu.com> <20140614160554.GP6584@merlins.org> <539E49DB.80305@cn.fujitsu.com> <20140616014739.GB19071@merlins.org> <pan.2014.06.16.07.06.08@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <539E9841.8040108@cn.fujitsu.com> <pan.2014.06.16.07.06.08@googlemail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jun 16, 2014 at 07:06:08AM +0000, Holger Hoffstätte wrote:
> > If it annoys other people, maybe having a -q (quiet) that removes this
> > message would be useful?
> 
> IMHO it should be the reverse: be quiet by default and require -v, just 
> as more explicit behaviour also requires additional options.
> With default options I expect default behaviour. Telling me that the 
> default behaviour happened is just noise.

So that's my general thought by default too :) but 
1) I wanted to be nice :)
2) More generally I would have missed this new feature without the output
and I thought it might not be unreasonable to show it to draw attention to
it. But at the same time, I wouldn't complain if it were quiet by default.

On Mon, Jun 16, 2014 at 03:09:53PM +0800, Wang Shilong wrote:
> >as more explicit behaviour also requires additional options.
> >With default options I expect default behaviour. Telling me that the
> >default behaviour happened is just noise.
>
> Fair point, Another question is that current default output has been there.
> Let's Cc David, and see what is his opinion.

Thanks for taking the feedback.

Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/  
