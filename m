Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.fusionio.com ([66.114.96.31]:53954 "EHLO mx2.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750809Ab2FZUTy (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 26 Jun 2012 16:19:54 -0400
Date: Tue, 26 Jun 2012 16:19:51 -0400
From: Josef Bacik <jbacik@fusionio.com>
To: "Nathan A. Mourey II" <nmoureyii@ne.rr.com>
CC: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: btrfs oops with kernel 3.5-rc4
Message-ID: <20120626201950.GB24953@localhost.localdomain>
References: <1340741359.2226.5.camel@athena>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1340741359.2226.5.camel@athena>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jun 26, 2012 at 02:09:19PM -0600, Nathan A. Mourey II wrote:
> Oops with kernel v3.5-rc4.  This error produced while:
> 
> emerge --sync &&  emerge --update --newuse --deep --with-bdeps=y @world && emerge --depclean && revdep-rebuild
> and 
> stress --cpu 1 --io 8 -d 8  --vm 4  -t 8h
> 
> ver_linux.sh was ran on stable v3.4.4 system.  
> 
> Linux peach.example.com 3.4.4 #2 SMP Sun Jun 24 20:38:42 EDT 2012 i686
> Intel(R) Pentium(R) 4 CPU 2.80GHz GenuineIntel GNU/Linux
> 
>  Gnu C                  4.5.3
>  Gnu make               3.82
>  binutils               2.21.1
>  util-linux             ./ver_linux: line 23: fdformat: command not found
>  mount                  support
>  module-init-tools      found
>  quota-tools            3.17.
>  Linux C Library        2.14.1
>  Dynamic linker (ldd)   2.14.1
>  Procps                 3.2.8
>  Kbd                    1.15.3wip
>  Sh-utils               8.14
>  Modules Loaded         ext3 jbd ehci_hcd
> 

Can you gdb btrfs.ko and do 

list *(btrfs_finish_ordered_io+0x22)

please?  And are you running compression by chance?  Thanks,

Josef
