Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:38760 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750919AbbDPUGO (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 16 Apr 2015 16:06:14 -0400
Date: Thu, 16 Apr 2015 13:06:13 -0700
From: Marc MERLIN <marc@merlins.org>
To: Miguel =?iso-8859-1?Q?Negr=E3o?=
	<miguel.negrao-lists@friendlyvirus.org>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: corruption in USB harddrive - backup via send/receive - question
Message-ID: <20150416200613.GN5610@merlins.org>
References: <loom.20150416T202016-456@post.gmane.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <loom.20150416T202016-456@post.gmane.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Apr 16, 2015 at 06:48:43PM +0000, Miguel Negrão wrote:
> Hello,
> 
> I'm running a laptop, macbook pro 8,2, with ubuntu, on kernel
> 3.13.0-49-lowlatency. I have a USB enclosure containing two harddrives

Btrfs send/receive is not known to work well enough until 3.14.x, and
several corruption bugs have been fixed between 3.13 and 3.19.

You should definitely upgrade to a much more recent kernel.

Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/  
