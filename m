Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from v-27-120-84-145.ub-freebit.net ([27.120.84.145]:51334 "EHLO
	mail.reasonset.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754777AbbIAITn (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 1 Sep 2015 04:19:43 -0400
Received: from hydrangea (211-19-57-172.flets.kamome.or.jp [211.19.57.172])
	by mail.reasonset.net (Postfix) with ESMTPSA id 2881C25108E6
	for <linux-btrfs@vger.kernel.org>; Tue,  1 Sep 2015 17:19:39 +0900 (JST)
Date: Tue, 1 Sep 2015 17:19:38 +0900
From: MASAKI Yuhsuke <yek@reasonset.net>
To: linux-btrfs@vger.kernel.org
Subject: Re: btrfs send/receive freezes a system
Message-Id: <20150901171938.e45888976b68594cd285d526@reasonset.net>
In-Reply-To: <55DDB9D5.5070001@gmail.com>
References: <20150821021146.eb0d8b756fe7f3600685ee53@reasonset.net>
	<pan$cfe41$8e4e4add$ad942ea0$b8e86edd@cox.net>
	<20150826210416.04c96b66ab9e4d0727c0ec67@reasonset.net>
	<55DDB9D5.5070001@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Austin,　Thank you for your reply.


You wrote:
> On 2015-08-26 08:04, MASAKI Yuhsuke wrote:
> > Hi Duncan, thank you for your reply.
> >
> > I understood it is guessed from development between 3.10 and 4.1.
> >
> > I will try to replace CentOS 7 Receiver with Manjaro (same as sender) and sync.
> > I will report the result here anyway.
> > If it doesn't work, I report it Kernel BTS.
> >
> >
> > I searched distro for server use with later kernel.
> > But I couldn't find.
> > I wonder Arch Linux is better if I desire btrfs stability.
> If you want the latest kernel and userspace, then Arch is definitely one 
> of the two best options, the other being Gentoo.  For someone who is 
> used to Manjaro or CentOS, Arch will be a lot easier to adapt to than 
> Gentoo however.  Both Gentoo and Arch work very well for server systems, 
> and make it a lot easier to keep up to date on security patches and 
> bugfixes than most of the other popular distributions.
I need complex storage (encrypt, network storage devices, bonding storages and btrfs,)
so I expect newer kernel solves some problem.
I hesitated because some prople say server os should use matured technology.
But I was certain of Arch Linux is best for my case.

> > After on previous post, it completed on 8th try with nc and piped btrfs receive.
> > But the unstability make me nervous.
> > I hope that latest kernel makes good.
> I actually just recently tested send/recieve over the network myself 
> using ssh (along the lines of 'btrfs send snapshot | ssh user@remotehost 
> btrfs recieve /target'), and only about 1 out of 3 attempts actually 
> worked.  At the time, I was on kernel 4.0.  I'm thinking that something 
> about recieve is timing dependent, as I got lower success rates as I 
> artificially increased the network latency.
Finally, the problem is reappeared between kernel 4.2rc8 at transfared 2.79 TiB.
They are connected with generic GbE. 2.79TiB transfarred In approximately sixteen hours.

Thank you.
