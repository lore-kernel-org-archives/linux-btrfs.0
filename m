Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:42797 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754412AbaEEFXN (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 5 May 2014 01:23:13 -0400
Date: Sun, 4 May 2014 22:22:52 -0700
From: Marc MERLIN <marc@merlins.org>
To: Brendan Hide <brendan@swiftspirit.co.za>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Using mount -o bind vs mount -o subvol=vol
Message-ID: <20140505052252.GJ10159@merlins.org>
References: <20140504004732.GE9061@merlins.org>
 <5365E74B.6020805@swiftspirit.co.za>
 <20140505005644.GB10159@merlins.org>
 <53670FEA.8050806@swiftspirit.co.za>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <53670FEA.8050806@swiftspirit.co.za>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, May 05, 2014 at 06:13:30AM +0200, Brendan Hide wrote:
> >Oh, really, it's slower to mount the device directly? Not that I really
> >care, but that's unexpected.
> 
> Um ... the penalty is if you're mounting indirectly. ;)

I'd be willing to believe that more then :)
(but indeed, if slowdown there is, it must be pretty irrelevant in the
big picture.

Cheers,
Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/                         | PGP 1024R/763BE901
