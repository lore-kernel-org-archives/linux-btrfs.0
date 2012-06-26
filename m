Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.fusionio.com ([66.114.96.31]:49187 "EHLO mx2.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751989Ab2FZUsD (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 26 Jun 2012 16:48:03 -0400
Date: Tue, 26 Jun 2012 16:48:00 -0400
From: Josef Bacik <jbacik@fusionio.com>
To: Stefan Priebe <s.priebe@profihost.ag>
CC: Josef Bacik <JBacik@fusionio.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: btrfs deadlock in 3.5-rc3
Message-ID: <20120626204759.GC24953@localhost.localdomain>
References: <4FE8A21E.7050104@profihost.ag>
 <20120625180252.GD7404@localhost.localdomain>
 <4FE8ADBA.20505@profihost.ag>
 <4FE8BCF5.4080605@profihost.ag>
 <20120625201151.GG7404@localhost.localdomain>
 <4FE8C80F.2040009@profihost.ag>
 <20120625202310.GH7404@localhost.localdomain>
 <4FE9E7BC.1020104@profihost.ag>
 <20120626201418.GA24953@localhost.localdomain>
 <4FEA1945.7050906@profihost.ag>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <4FEA1945.7050906@profihost.ag>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jun 26, 2012 at 02:19:17PM -0600, Stefan Priebe wrote:
> Am 26.06.2012 22:14, schrieb Josef Bacik:
> > I can't reproduce so I'm going to have to figure out a way to debug it through
> > you, as soon as I think of something I will let you know.  Thanks,
> >
> 
> Thanks. You mentioned that discard shouldn't have any positive effects 
> on a SSD.
> 
> May i see a sideffect? I mean with discard 13.000 IOPs in ceph without 
> discard just 6000-9000 IOPs could this be real or might this just happen 
> due to the bug i see?
> 

Beats me, it would seem to me that discard would make things slower since we
have to wait for the commit to discard everybody, but who knows, stranger things
have happened.  Can you reproduce 2 more times and get sysrq+w each time so I
have a few different outputs to compare, maybe I'm missing something.  Thanks,

Josef
