Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp206.alice.it ([82.57.200.102]:38147 "EHLO smtp206.alice.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751355Ab2FOQ4a (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 15 Jun 2012 12:56:30 -0400
Message-ID: <4FDB6943.2030601@libero.it>
Date: Fri, 15 Jun 2012 18:56:35 +0200
From: Goffredo Baroncelli <kreijack@libero.it>
Reply-To: kreijack@inwind.it
MIME-Version: 1.0
To: Andrei Popa <ierdnah@gmail.com>, linux-btrfs@vger.kernel.org,
        arnd@arndnet.de
Subject: Re: [PATCH] Btrfs: add "nocompress" mount option
References: <1339754209.2212.22.camel@ierdnac-hp> <20120615105006.GV32402@twin.jikos.cz>
In-Reply-To: <20120615105006.GV32402@twin.jikos.cz>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 06/15/2012 12:50 PM, David Sterba wrote:
> I prefer this over adding an extra option to disable. This
> way there's no confusion if the compression is on or off.
> 
>   mount -o compress,nocompress /dev /mnt

The confusion still exists if an user does:

	mount -o compress,compress=no /dev /mnt

However I prefer the form "compress=" because already exists the option
"compress=lzo|zlib".

BR
G.Baroncelli

> 
> Is it on or off? Yeah we can document that nocompress has higher
> priority. But then I can't turn a nocompress option back to compress via
> remount. This is possible with Arnd's patch.
> 
> 
> david

