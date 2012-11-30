Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from zeniv.linux.org.uk ([195.92.253.2]:57328 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751167Ab2K3EF5 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 29 Nov 2012 23:05:57 -0500
Date: Fri, 30 Nov 2012 04:05:56 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Abhijit Pawar <abhi.c.pawar@gmail.com>, linux-fsdevel@vger.kernel.org,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org
Subject: Re: [RESEND PATCH] fs/super.c set_anon_super calling optimization
Message-ID: <20121130040556.GD4939@ZenIV.linux.org.uk>
References: <CA+kxV1F5VxBGawhkV=02LcgHNWiKF-H_k6N-d1TEYNeFAScezg@mail.gmail.com>
 <508924AB.4060902@gmail.com>
 <20121026131441.GA22256@andromeda.usersys.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20121026131441.GA22256@andromeda.usersys.redhat.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Oct 26, 2012 at 11:14:41AM -0200, Carlos Maiolino wrote:
> Hi,
> 
> On Thu, Oct 25, 2012 at 05:08:19PM +0530, Abhijit Pawar wrote:
> > Hi,
> > set_anon_super is called by many filesystems. Some call directly and
> > some call through the wrapper. Many of them in the wrapper's call to
> > this function are passing the second argument to this function which
> > is not used anywhere.
> > 
> > This patch replaces the second variable with NULL.
> > 
> 
> If the variable isn't used anymore, why don't just get rid of it, instead of
> call the function passing a NULL pointer on it?

	Because we want it to be a valid sget() callback.  I doubt that this
optimization is worth doing, though - might even micro-pessimize the things
on architectures where all arguments are passed in registers.
