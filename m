Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from walhalla.sjomar.eu ([141.105.125.198]:48429 "EHLO
	mail.sjomar.eu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932171AbbIYOgB (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 25 Sep 2015 10:36:01 -0400
Received: from hoefnix.localnet (a83-163-227-207.adsl.xs4all.nl [83.163.227.207])
	(using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	(Authenticated sender: sjoerd@sjomar.eu)
	by mail.sjomar.eu (Postfix) with ESMTPSA id BDBD13288A
	for <linux-btrfs@vger.kernel.org>; Fri, 25 Sep 2015 16:35:57 +0200 (CEST)
From: Sjoerd <sjoerd@sjomar.eu>
To: linux-btrfs@vger.kernel.org
Subject: Re: Latest kernel to use?
Date: Fri, 25 Sep 2015 16:35:55 +0200
Message-ID: <2547790.9tRNNhiZP1@hoefnix>
In-Reply-To: <20150925135134.GF3749@carfax.org.uk>
References: <4362384.AA8xu4anSN@hoefnix> <3800342.Pn9bHBFuTx@hoefnix> <20150925135134.GF3749@carfax.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Friday 25 September 2015 13:51:34 Hugo Mills wrote:
> On Fri, Sep 25, 2015 at 03:36:18PM +0200, Sjoerd wrote:
> > Thanks all for the feedback. Still doubting though to go for 4.2.1 or not.
> > Main reason is that I am currently running 4.1.7 on my laptop which seems
> > to work fine and had some issues with the 4.2.0 kernel. No issues I thing
> > that were btrfs related, but more related to my nvidia card. Anyway
> > switching back to 4.1.7 resolved those, so I am a bit holding back to try
> > the 4.2.1 version ;)
> > Anyway I'll see and can always revert back if I don't like it ;)
> 
>    If 4.1.7 is working OK for you, stick with it. It's getting much
> less important now, as btrfs matures, to keep up with the _very_
> latest. Purely on gut feeling about issues we see on IRC and here,
> 3.19 or later would be reasonable at the moment.
> 

OK i'll stick with the longterm 4.1.x branch then..

>    Compared to, say, 3 or 4 years ago when running late -rc kernels
> was often preferable to running the latest stable, and things have
> improved quite a bit. :)

Good to know and thanks for the feedback :)

Cheers,
Sjoerd

