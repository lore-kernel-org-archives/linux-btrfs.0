Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:37398 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751907Ab2JIJ0n (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 9 Oct 2012 05:26:43 -0400
Received: from int-mx10.intmail.prod.int.phx2.redhat.com (int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q999QgH4029772
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Tue, 9 Oct 2012 05:26:42 -0400
Received: from localhost (vpn1-7-176.ams2.redhat.com [10.36.7.176])
	by int-mx10.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id q999QeHF022135
	for <linux-btrfs@vger.kernel.org>; Tue, 9 Oct 2012 05:26:42 -0400
Date: Tue, 9 Oct 2012 10:26:38 +0100
From: "Richard W.M. Jones" <rjones@redhat.com>
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: Anyone seeing lots of "Check tree block failed" and other errors
 with latest kernel?
Message-ID: <20121009092638.GN24071@rhmail.home.annexia.org>
References: <20121008141642.GC24071@rhmail.home.annexia.org>
 <20121008142757.GB4132@shiny>
 <20121008145730.GD24071@rhmail.home.annexia.org>
 <20121008150419.GE4132@shiny>
 <20121008151513.GE24071@rhmail.home.annexia.org>
 <20121008212230.GA13692@rhmail.home.annexia.org>
 <20121009000051.GA12735@shiny>
 <20121009072002.GJ24071@rhmail.home.annexia.org>
 <20121009091657.GK4405@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20121009091657.GK4405@twin.jikos.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Oct 09, 2012 at 11:16:57AM +0200, David Sterba wrote:
> On Tue, Oct 09, 2012 at 08:20:02AM +0100, Richard W.M. Jones wrote:
> > On my local machine, I'm reproducing this with what Fedora calls
> > 3.7.0-0.rc0.git2.4.fc19.x86_64 (note I found an unrelated but very
> > serious bug in this kernel:
> > http://marc.info/?l=linux-kernel&m=134973394826408&w=2 )
> 
> And it's going to be fixed
> 
> http://marc.info/?l=linux-fsdevel&m=134973493227376&w=2

And this one too ...

http://marc.info/?l=linux-fsdevel&m=134977414011004&w=2

Rich.

-- 
Richard Jones, Virtualization Group, Red Hat http://people.redhat.com/~rjones
Read my programming blog: http://rwmj.wordpress.com
Fedora now supports 80 OCaml packages (the OPEN alternative to F#)
http://cocan.org/getting_started_with_ocaml_on_red_hat_and_fedora
