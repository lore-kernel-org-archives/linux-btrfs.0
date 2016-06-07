Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:54705 "EHLO
	out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932348AbcFGNwU (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 7 Jun 2016 09:52:20 -0400
Message-Id: <1465307538.3786093.630450009.4FD7B429@webmail.messagingengine.com>
From: Kai Hendry <hendry@iki.fi>
To: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>,
        Chris Murphy <lists@colorremedies.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Subject: Re: btrfs device delete /dev/sdc1 /mnt/raid1 user experience
Date: Tue, 07 Jun 2016 21:52:18 +0800
In-Reply-To: <abecd302-3ef4-ba0e-eba1-fe27bb68a539@gmail.com>
References: <1465191858.3381218.628872649.1C5D6003@webmail.messagingengine.com>
 <CAJCQCtSYfX3M0DVd9WA+yru8Jm=wwfkmYCUUeeswE9DnsMAG1g@mail.gmail.com>
 <1465272129.3661627.630003937.6FC96567@webmail.messagingengine.com>
 <abecd302-3ef4-ba0e-eba1-fe27bb68a539@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, 7 Jun 2016, at 07:10 PM, Austin S. Hemmelgarn wrote:
> Yes, although you would then need to be certain to run a balance with 
> -dconvert=raid1 -mconvert=raid1 to clean up anything that got allocated 
> before the new disk was added.

I don't quite understand when I should run this command.

Before I take it out? Once I take it out? One the new one is added?

And why doesn't it do this automatically? =)
