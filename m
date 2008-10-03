From: Chris Mason <chris.mason@oracle.com>
Subject: Re: different oops
Date: Fri, 03 Oct 2008 13:59:16 -0400
Message-ID: <1223056756.13375.29.camel@think.oraclecorp.com>
References: <200810031814.06897.mbuerger@edu.uni-klu.ac.at>
	 <1223052035.13375.27.camel@think.oraclecorp.com>
	 <9cdbb57f0810031016m5ba208a8xbaa0a9e963a7b887@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: linux-btrfs@vger.kernel.org
To: Andrea Gelmini <andrea.gelmini@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <9cdbb57f0810031016m5ba208a8xbaa0a9e963a7b887@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, 2008-10-03 at 19:16 +0200, Andrea Gelmini wrote:
> 2008/10/3 Chris Mason <chris.mason@oracle.com>:
> > This is a long standing bug that so far we've only heard about on gentoo
> > installs.  Could you please give the attached patch a try against your
> > sources?
> 
> I've got same problem, with lastest ubuntu, and my own kernel (vanilla).
> I can trigger disk copying ~2GB of data from my home to btrfs (65GB
> test partition), everytime I try.
> 
> It seems easier to trigger when copying files of size > 300MB.
> 
> I can give you root access to my laptop if it helps.
> 
> Ciao,
> Gelma

Ok are you also on i386 (not 64bit)

-chris


