Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:45499 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757886AbaEKARH (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 10 May 2014 20:17:07 -0400
Date: Sat, 10 May 2014 17:16:50 -0700
From: Marc MERLIN <marc@merlins.org>
To: Chris Murphy <lists@colorremedies.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: 3.15-rc5 btrfs send/receive corruption errors?
Message-ID: <20140511001649.GF27530@merlins.org>
References: <20140510220710.GA6772@merlins.org>
 <20140510224249.GA15909@merlins.org>
 <D55BDA6A-5DFA-4981-AC69-3156317ED169@colorremedies.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <D55BDA6A-5DFA-4981-AC69-3156317ED169@colorremedies.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, May 10, 2014 at 06:06:46PM -0600, Chris Murphy wrote:
> I think the issue might be there are still problems and changing code on the receive side (btrfs-progs). The kernel side code responsible for send is probably working correctly.

Mmmh, good point, I didn't consider that.
Do you think I should downgrade btrfs-progs back down from 3.14 to 3.12?

Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/                         | PGP 1024R/763BE901
