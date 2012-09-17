Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.fusionio.com ([66.114.96.30]:42646 "EHLO mx1.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756707Ab2IQR1a (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 17 Sep 2012 13:27:30 -0400
Date: Mon, 17 Sep 2012 12:51:05 -0400
From: Chris Mason <chris.mason@fusionio.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: This code cannot be right
Message-ID: <20120917165105.GA4314@shiny>
References: <20120917172554.134b2014@pyramind.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <20120917172554.134b2014@pyramind.ukuu.org.uk>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Sep 17, 2012 at 10:25:54AM -0600, Alan Cox wrote:
> 
> ctree.c:btrfs_insert_some_items()
> {
> ...
> 
> 
> 		if (total_size + data_size[i]+ ...
> 		{
> 			break;
> 			nr = i;
> 		}
> 

Hi Alan,

Definitely not right ;) It's actually unused, but I thought I had gotten
rid of it long ago.  I'll queue up a patch for the next merge window,
thanks.

-chris

