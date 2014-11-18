Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:43991 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754107AbaKRPfv (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 18 Nov 2014 10:35:51 -0500
Date: Tue, 18 Nov 2014 07:35:26 -0800
From: Marc MERLIN <marc@merlins.org>
To: Brendan Hide <brendan@swiftspirit.co.za>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: scrub implies failing drive - smartctl blissfully unaware
Message-ID: <20141118153526.GS20972@merlins.org>
References: <E1XqYMg-0000YI-8y@watricky.valid.co.za> <546AF572.2020101@swiftspirit.co.za>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <546AF572.2020101@swiftspirit.co.za>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Nov 18, 2014 at 09:29:54AM +0200, Brendan Hide wrote:
> Hey, guys
> 
> See further below extracted output from a daily scrub showing csum 
> errors on sdb, part of a raid1 btrfs. Looking back, it has been getting 
> errors like this for a few days now.
> 
> The disk is patently unreliable but smartctl's output implies there are 
> no issues. Is this somehow standard faire for S.M.A.R.T. output?

Try running hdrecover on your drive, it'll scan all your blocks and try to
rewrite the ones that are failing, if any:
http://hdrecover.sourceforge.net/

Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/  
