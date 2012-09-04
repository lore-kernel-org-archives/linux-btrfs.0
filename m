Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.fusionio.com ([66.114.96.30]:46532 "EHLO mx1.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753512Ab2IDQMH (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 4 Sep 2012 12:12:07 -0400
Date: Tue, 4 Sep 2012 12:12:03 -0400
From: Chris Mason <chris.mason@fusionio.com>
To: Jan Schmidt <list.btrfs@jan-o-sch.net>
CC: Suman C <schakrava@gmail.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        "Chris L. Mason" <clmason@fusionio.com>
Subject: Re: Btrfs-Progs integration branch question
Message-ID: <20120904161203.GB4013@shiny.int.fusionio.com>
References: <CAPF83mvX6ueqaR62bvRygapGtw6RPuSTo1+oeYUrYAD0MPsULA@mail.gmail.com>
 <5045C881.40402@jan-o-sch.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <5045C881.40402@jan-o-sch.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Sep 04, 2012 at 03:23:13AM -0600, Jan Schmidt wrote:
> On Mon, September 03, 2012 at 18:31 (+0200), Suman C wrote:
> > I am trying to integrate the quota patch from August 10th by Jan
> > Schmidt and getting conflicts when I git apply.
> 
> I've rebased it on top of Chris' current master, you can pull from
> 
> 	git://git.jan-o-sch.net/btrfs-progs qgroup
> 
> if you like.
> 
> Chris: probably saves you some minutes too if you just pull that one :-)

Thanks Jan, your qgroup branch is now in my master on kernel.org.

-chris

