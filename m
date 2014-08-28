Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:50195 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S933950AbaH1DXn convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 27 Aug 2014 23:23:43 -0400
Received: from c-75-70-18-61.hsd1.co.comcast.net ([75.70.18.61]:64143 helo=ming.hsd1.co.comcast.net)
	by slmp-550-94.slc.westdc.net with esmtpsa (TLSv1:AES128-SHA:128)
	(Exim 4.82)
	(envelope-from <lists@colorremedies.com>)
	id 1XMqJK-000Xoj-Fg
	for linux-btrfs@vger.kernel.org; Wed, 27 Aug 2014 21:23:42 -0600
Content-Type: text/plain; charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: fs corruption report
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <1409193972.2879.2.camel@localhost.localdomain>
Date: Wed, 27 Aug 2014 21:23:41 -0600
Message-Id: <71FAE8F7-F5F7-4105-A01A-3EC8B0502A90@colorremedies.com>
References: <CAM_a8JxJBFQykuF13UF1Fi9jbM-=yromXbQ5PrWM5JPR7u6pXA@mail.gmail.com> <1409193972.2879.2.camel@localhost.localdomain>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Aug 27, 2014, at 8:46 PM, Gui Hecheng <guihc.fnst@cn.fujitsu.com> wrote:

> BTW，there is a develop branch from the btrfs-progs's maintainer David:
> http://github.com/kdave/btrfs-progs.git
> 
> Maybe you'd like to try it, it may make some differences.
> 

I think the current development version is here:

git://repo.or.cz/btrfs-progs-unstable/devel.git integration-20140827

And current stable went to v3.16 in master branch here:

git://git.kernel.org/pub/scm/linux/kernel/git/mason/btrfs-progs.git

I'd probably try 3.16 first? *shrug* At least do a btrfs check only without --repair and see what it says.


Chris Murphy