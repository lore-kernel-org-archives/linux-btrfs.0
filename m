Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim2.fusionio.com ([66.114.96.54]:48185 "EHLO
	dkim2.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759111Ab3BMNbk (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 13 Feb 2013 08:31:40 -0500
Received: from mx1.fusionio.com (unknown [10.101.1.160])
	by dkim2.fusionio.com (Postfix) with ESMTP id 1B2879A0682
	for <linux-btrfs@vger.kernel.org>; Wed, 13 Feb 2013 06:31:40 -0700 (MST)
Date: Wed, 13 Feb 2013 08:31:37 -0500
From: Chris Mason <chris.mason@fusionio.com>
To: "Richard W.M. Jones" <rjones@redhat.com>
CC: Chris Mason <clmason@fusionio.com>, Josef Bacik <JBacik@fusionio.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: What can I do to make btrfs work?
Message-ID: <20130213133137.GA21623@shiny.masoncoding.com>
References: <20130212185449.GA16773@rhmail.home.annexia.org>
 <20130212191637.GD2611@localhost.localdomain>
 <20130212210535.GC16773@rhmail.home.annexia.org>
 <20130212214225.GM16687@shiny.masoncoding.com>
 <20130213110033.GA1543@rhmail.home.annexia.org>
 <20130213131044.GE16773@rhmail.home.annexia.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <20130213131044.GE16773@rhmail.home.annexia.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Feb 13, 2013 at 06:10:44AM -0700, Richard W.M. Jones wrote:
> On Wed, Feb 13, 2013 at 11:00:33AM +0000, Richard W.M. Jones wrote:
> > Will try the btrfsprogs patch next.
> 
> I applied this patch:
> 
> https://git.kernel.org/?p=linux/kernel/git/mason/btrfs-progs.git;a=commitdiff_plain;h=8fe354744cd7b5c4f7a3314dcdbb5095192a032f
> 
> to the version of btrfs-progs in Fedora Rawhide (currently
> "0.20.rc1.20121017git91d9eec").  Then I ran the simple reproducer, and
> the full libguestfs test suite on two machines.
> 
> This does appear to fix the problem for me, but only on Rawhide.
> 
> On Fedora 18 which has an older kernel, the patch does not fix the
> problem (same errors as before).
> 
> Rawhide kernel: kernel-3.8.0-0.rc7.git0.1.fc19.x86_64
> 
> Fedora 18 kernel: kernel-3.7.6-201.fc18.x86_64
> 
> Anyway, it's an improvement so I'll make sure the patch is added to
> the Rawhide btrfs-progs package.

Ok, the patch is more of a bandaid, but between running my vtest program
and the patch helping, we're clearly not clearing caches properly
(somehow).  I'll take another stab at fixing this on the kernel side.

-chris

