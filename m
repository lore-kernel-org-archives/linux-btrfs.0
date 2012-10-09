Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from twin.jikos.cz ([89.185.236.188]:52133 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753058Ab2JIP5N (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 9 Oct 2012 11:57:13 -0400
Date: Tue, 9 Oct 2012 17:57:02 +0200
From: David Sterba <dave@jikos.cz>
To: Miao Xie <miaox@cn.fujitsu.com>
Cc: Chris Mason <chris.mason@fusionio.com>,
        Linux Btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH V4 0/7 ] Btrfs-progs: enhance btrfs subvol list only to
 show read-only snapshots
Message-ID: <20121009155701.GW4405@twin.jikos.cz>
Reply-To: dave@jikos.cz
References: <50584E6D.8000602@cn.fujitsu.com>
 <20121003000304.GH3214@shiny>
 <5073BDAE.7090908@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <5073BDAE.7090908@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Oct 09, 2012 at 02:01:18PM +0800, Miao Xie wrote:
> On Tue, 2 Oct 2012 20:03:04 -0400, Chris Mason wrote:
> > These are all really useful additions!  How do you plan on using the
> > table option? (just curious).
> 
> It is just used to make the output be read easily. The old output always throw
> out lots of inessential repeated strings, it is very ugly and make us giddy. So
> we add this option to make the users happy.

I really like the tabular output, thanks!

david
