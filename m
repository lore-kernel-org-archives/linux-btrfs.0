Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:36217 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751330AbbEKXq2 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 11 May 2015 19:46:28 -0400
Date: Mon, 11 May 2015 16:46:04 -0700
From: Marc MERLIN <marc@merlins.org>
To: Matt McKinnon <matt@techsquare.com>
Cc: linux-btrfs@vger.kernel.org
Message-ID: <20150511234604.GF15670@merlins.org>
References: <55512147.5030708@techsquare.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <55512147.5030708@techsquare.com>
Subject: Re: btrfs send/receive error
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, May 11, 2015 at 05:38:15PM -0400, Matt McKinnon wrote:
> Hello,
> 
> What's the best way to deal with this send/receive error?
 
Typically get a new kernel where this is fixed, Filipe
has been working on fixing them.
What kernel was this on?

Marc

> ---
> 
> Create a readonly snapshot of 'users' in
> '/export/r2/.incrementals/users_ro.20150511_17:28:53'
> At subvol /export/r2/.incrementals/users_ro.20150511_17:28:53
> At snapshot users_ro.20150511_17:28:53
> ERROR: rename o46709324-421364-0 ->
> fspace2/120430RU/bold_nopace/SPMana failed. Directory not empty
> 
> ---
> 
> ./btrfs --version
> btrfs-progs v4.0
> 
> 
> -Matt
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/                         | PGP 1024R/763BE901
