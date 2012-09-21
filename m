Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:36347 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753936Ab2IUFnP (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 21 Sep 2012 01:43:15 -0400
Date: Thu, 20 Sep 2012 22:43:14 -0700
From: Marc MERLIN <marc@merlins.org>
To: Stefan Behrens <sbehrens@giantdisaster.de>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: kernel BUG at fs/btrfs/extent_io.c:1884!
Message-ID: <20120921054314.GB9170@merlins.org>
References: <20120920171747.GG26105@merlins.org> <20120921034652.GA871@merlins.org> <505BF3BC.1030304@giantdisaster.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <505BF3BC.1030304@giantdisaster.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Sep 21, 2012 at 06:57:32AM +0200, Stefan Behrens wrote:
> >	    BUG_ON(!mirror_num); <<<<<
> >
> 
> This was fixed with commit c0901581ad077004145c9ee80e843fba71c100b8 and 
> is included in Linux 3.6 RC1.

Congrats for all having a time machine and fixing my reported bugs in the
past :)

Thanks for the fix and the link,
Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/  
