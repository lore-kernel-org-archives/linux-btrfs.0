Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:37990 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751055AbaHIUK7 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sat, 9 Aug 2014 16:10:59 -0400
Date: Sat, 9 Aug 2014 13:10:51 -0700
From: Marc MERLIN <marc@merlins.org>
To: Filipe Manana <fdmanana@suse.com>
Cc: linux-btrfs@vger.kernel.org
Message-ID: <20140809201051.GJ12778@merlins.org>
References: <1407615747-12949-1-git-send-email-fdmanana@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1407615747-12949-1-git-send-email-fdmanana@suse.com>
Subject: Re: [PATCH] Btrfs: fix csum tree corruption, duplicate and outdated
 checksums
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Aug 09, 2014 at 09:22:27PM +0100, Filipe Manana wrote:

(100 lines of detailled explanations snipped)

> -			slot = 0;
> +			slot = path->slots[0];

And this is why, trying to rank kernel contributions by number of
lines or characters is a very poor guide of the actual work accomplished
and owed credit.

Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/                         | PGP 1024R/763BE901
