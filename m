Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.fusionio.com ([66.114.96.30]:56735 "EHLO mx1.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752758Ab2GTMke (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 20 Jul 2012 08:40:34 -0400
Date: Fri, 20 Jul 2012 08:40:30 -0400
From: Chris Mason <chris.mason@fusionio.com>
To: Liu Bo <liubo2009@cn.fujitsu.com>
CC: David Sterba <dave@jikos.cz>, "Chris L. Mason" <clmason@fusionio.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        Josef Bacik <JBacik@fusionio.com>
Subject: Re: [PATCH v3] Btrfs: improve multi-thread buffer read
Message-ID: <20120720124030.GI18878@shiny.int.fusionio.com>
References: <1342461925-22495-1-git-send-email-liubo2009@cn.fujitsu.com>
 <20120718115735.GI11226@twin.jikos.cz>
 <50075EAA.9030806@cn.fujitsu.com>
 <20120719020518.GE17430@twin.jikos.cz>
 <50077169.4070203@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <50077169.4070203@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jul 18, 2012 at 08:31:05PM -0600, Liu Bo wrote:
> On 07/19/2012 10:05 AM, David Sterba wrote:

[ pagevec vs array ]

> Sorry, I see no difference between 16 pages array and pagevec(14 pages), and
> I have no idea why ext4 use 16 pages array(maybe historical reasons), but IMO
> it is proper and natural to use pagevec to manage pages.
> 
> Anyway, either will be ok, but we'd better get Chris's confirmation.
> 
> So Chris?

Yeah, the array does sound better, and I would go with 16.  It's a nice
round number. Thanks Dave!

-chris

