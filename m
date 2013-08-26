Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:13072 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752083Ab3HZPPt convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 26 Aug 2013 11:15:49 -0400
Content-Type: text/plain; charset=windows-1252
Mime-Version: 1.0 (Mac OS X Mail 6.5 \(1508\))
Subject: Re: snapshot space available
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <201308262335.25871.russell@coker.com.au>
Date: Mon, 26 Aug 2013 09:15:46 -0600
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Message-Id: <6FCC5036-CC36-4DA3-8594-1FA23F3BB256@colorremedies.com>
References: <201308262335.25871.russell@coker.com.au>
To: russell@coker.com.au
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Aug 26, 2013, at 7:35 AM, Russell Coker <russell@coker.com.au> wrote:
>                                                                                                                                                                                                                                                                      
> root@xev:~# btrfs filesystem df /                                                                                                                                                                                                                                                                                                                               
> Data: total=101.57GB, used=81.50GB                                                                                                                                                                                                                                                                                                                              
> System, DUP: total=8.00MB, used=20.00KB                                                                                                                                                                                                                                                                                                                         
> System: total=4.00MB, used=0.00                                                                                                                                                                                                                                                                                                                                 
> Metadata, DUP: total=3.00GB, used=2.50GB                                                                                                                                                                                                                                                                                                                        
> Metadata: total=8.00MB, used=0.00
> root@xev:~# ls -l > test                                                                                                                                                                                                                                                                                                                                        
> bash: test: No space left on device                                                                                                                                                                                                                                                                                                                             
> root@xev:~# touch test
> touch: cannot touch ‘test’: No space left on device                                                                                                                                                                                                                                                                                                             
> root@xev:~#

The issue is data chunks remaining allocated for data, and not enough free space to allocate metadata chunks. Ultimately, the volume needs to be balanced.

I'm uncertain if autodefrag avoids this problem. It does seem like in certain instances, like this, the file system needs to be able to prune itself somehow, like a partial balance to consolidate data chunks and then release their space so they can become metadata chunks.

Chris Murphy