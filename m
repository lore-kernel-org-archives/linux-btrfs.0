Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.fusionio.com ([66.114.96.31]:38258 "EHLO mx2.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932228Ab2F0VR2 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 27 Jun 2012 17:17:28 -0400
Date: Wed, 27 Jun 2012 17:17:26 -0400
From: Josef Bacik <jbacik@fusionio.com>
To: Stefan Priebe - Profihost AG <s.priebe@profihost.ag>
CC: Josef Bacik <JBacik@fusionio.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: btrfs deadlock in 3.5-rc3
Message-ID: <20120627211725.GB17383@localhost.localdomain>
References: <4FE8ADBA.20505@profihost.ag>
 <4FE8BCF5.4080605@profihost.ag>
 <20120625201151.GG7404@localhost.localdomain>
 <4FE8C80F.2040009@profihost.ag>
 <20120625202310.GH7404@localhost.localdomain>
 <4FE9E7BC.1020104@profihost.ag>
 <20120626201418.GA24953@localhost.localdomain>
 <4FEA1945.7050906@profihost.ag>
 <20120626204759.GC24953@localhost.localdomain>
 <4FEA9E63.50000@profihost.ag>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <4FEA9E63.50000@profihost.ag>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jun 26, 2012 at 11:47:15PM -0600, Stefan Priebe - Profihost AG wrote:
> Yes i will do so. Right now i was trying to compare discard with non 
> discard with this simple command:
> for i in `seq 0 1 1000`; do dd if=/dev/zero of=t_$i bs=4M count=1; rm 
> t_$i; done;
> 
> But i hit a new bug:
> 

Fixed this one with

Btrfs: hold a ref on the inode during writepages

Apply that and carry on with your tests :).  Thanks,

Josef
