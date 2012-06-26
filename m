Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.profihost.ag ([85.158.179.208]:60369 "EHLO
	mail.profihost.ag" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751079Ab2FZUTV (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 26 Jun 2012 16:19:21 -0400
Message-ID: <4FEA1945.7050906@profihost.ag>
Date: Tue, 26 Jun 2012 22:19:17 +0200
From: Stefan Priebe <s.priebe@profihost.ag>
MIME-Version: 1.0
To: Josef Bacik <jbacik@fusionio.com>
CC: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: btrfs deadlock in 3.5-rc3
References: <4FE8796E.9030300@profihost.ag> <20120625144807.GC7404@localhost.localdomain> <4FE8A21E.7050104@profihost.ag> <20120625180252.GD7404@localhost.localdomain> <4FE8ADBA.20505@profihost.ag> <4FE8BCF5.4080605@profihost.ag> <20120625201151.GG7404@localhost.localdomain> <4FE8C80F.2040009@profihost.ag> <20120625202310.GH7404@localhost.localdomain> <4FE9E7BC.1020104@profihost.ag> <20120626201418.GA24953@localhost.localdomain>
In-Reply-To: <20120626201418.GA24953@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am 26.06.2012 22:14, schrieb Josef Bacik:
> I can't reproduce so I'm going to have to figure out a way to debug it through
> you, as soon as I think of something I will let you know.  Thanks,
>

Thanks. You mentioned that discard shouldn't have any positive effects 
on a SSD.

May i see a sideffect? I mean with discard 13.000 IOPs in ceph without 
discard just 6000-9000 IOPs could this be real or might this just happen 
due to the bug i see?

Stefan
