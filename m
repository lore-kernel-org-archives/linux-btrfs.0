Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.fusionio.com ([66.114.96.30]:52698 "EHLO mx1.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755800Ab2FYUXN (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 25 Jun 2012 16:23:13 -0400
Date: Mon, 25 Jun 2012 16:23:11 -0400
From: Josef Bacik <jbacik@fusionio.com>
To: Stefan Priebe <s.priebe@profihost.ag>
CC: Josef Bacik <JBacik@fusionio.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: btrfs deadlock in 3.5-rc3
Message-ID: <20120625202310.GH7404@localhost.localdomain>
References: <4FE870DF.90308@profihost.ag>
 <20120625142048.GB7404@localhost.localdomain>
 <4FE8796E.9030300@profihost.ag>
 <20120625144807.GC7404@localhost.localdomain>
 <4FE8A21E.7050104@profihost.ag>
 <20120625180252.GD7404@localhost.localdomain>
 <4FE8ADBA.20505@profihost.ag>
 <4FE8BCF5.4080605@profihost.ag>
 <20120625201151.GG7404@localhost.localdomain>
 <4FE8C80F.2040009@profihost.ag>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <4FE8C80F.2040009@profihost.ag>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jun 25, 2012 at 02:20:31PM -0600, Stefan Priebe wrote:
> Am 25.06.2012 22:11, schrieb Josef Bacik:
> > On Mon, Jun 25, 2012 at 01:33:09PM -0600, Stefan Priebe wrote:
> >> With v3.4 the same. Can't go back more as this really results in very
> >> fast corruption. Any ideas how to debug?
> >>
> >
> > What workload are you running?  I have a ssd here with discard support I can try
> > and reproduce on.  Thanks,
> 
> i'm using fio with 50 jobs and randwrite of 4k blocks in ceph but i 
> don't know which load ceph then exactly generates. ;-(
> 

Thats fine, I have this handy "create a local ceph cluster" script from an
earlier problem, just send me your fio job and I'll run it locally.  Thanks,

Josef
