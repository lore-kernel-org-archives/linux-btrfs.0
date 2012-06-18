Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from twin.jikos.cz ([89.185.236.188]:34548 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751042Ab2FRMVr (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 18 Jun 2012 08:21:47 -0400
Date: Mon, 18 Jun 2012 14:20:42 +0200
From: David Sterba <dave@jikos.cz>
To: kreijack@inwind.it
Cc: Andrei Popa <ierdnah@gmail.com>, linux-btrfs@vger.kernel.org,
        arnd@arndnet.de
Subject: Re: [PATCH] Btrfs: add "nocompress" mount option
Message-ID: <20120618122042.GY32402@twin.jikos.cz>
Reply-To: dave@jikos.cz
References: <1339754209.2212.22.camel@ierdnac-hp>
 <20120615105006.GV32402@twin.jikos.cz>
 <4FDB6943.2030601@libero.it>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <4FDB6943.2030601@libero.it>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jun 15, 2012 at 06:56:35PM +0200, Goffredo Baroncelli wrote:
> On 06/15/2012 12:50 PM, David Sterba wrote:
> > I prefer this over adding an extra option to disable. This
> > way there's no confusion if the compression is on or off.
> > 
> >   mount -o compress,nocompress /dev /mnt
> 
> The confusion still exists if an user does:
> 
> 	mount -o compress,compress=no /dev /mnt

Ah right. The precedence is simply given by order on the options line,
and this is same in case of 'nocompress'.

> However I prefer the form "compress=" because already exists the option
> "compress=lzo|zlib".

My comment about precedence is not valid now and the (rather small)
benefit of having a single option is to have the code handling this in a
single location.


david
