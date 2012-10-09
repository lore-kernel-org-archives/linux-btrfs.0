Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.fusionio.com ([66.114.96.30]:43097 "EHLO mx1.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753202Ab2JIAAy (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 8 Oct 2012 20:00:54 -0400
Date: Mon, 8 Oct 2012 20:00:51 -0400
From: Chris Mason <chris.mason@fusionio.com>
To: "Richard W.M. Jones" <rjones@redhat.com>
CC: Chris Mason <clmason@fusionio.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: Anyone seeing lots of "Check tree block failed" and other errors
 with latest kernel?
Message-ID: <20121009000051.GA12735@shiny>
References: <20121008141642.GC24071@rhmail.home.annexia.org>
 <20121008142757.GB4132@shiny>
 <20121008145730.GD24071@rhmail.home.annexia.org>
 <20121008150419.GE4132@shiny>
 <20121008151513.GE24071@rhmail.home.annexia.org>
 <20121008212230.GA13692@rhmail.home.annexia.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <20121008212230.GA13692@rhmail.home.annexia.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Oct 08, 2012 at 03:22:30PM -0600, Richard W.M. Jones wrote:
> 
> I have now reproduced this bug locally.
> 
> Adding sync() + fsync of each /dev/sd* device after the mkfs command
> does appear to fix the problem.
> 
> However it's a little bit difficult to know for sure because I might
> just be changing the timing of things by adding these calls.

Ok, what's a rough idea of the mainline git equiv of the buggy kernel?

-chris

