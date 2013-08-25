Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:41104 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756573Ab3HYRF3 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 25 Aug 2013 13:05:29 -0400
Date: Sun, 25 Aug 2013 09:29:13 -0700
From: Marc MERLIN <marc@merlins.org>
To: Matthieu Dalstein <matthieu.dalstein@dalmat.net>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Ability to free space on a full btrfs filesystem
Message-ID: <20130825162913.GD1387@merlins.org>
References: <521A2F78.908@dalmat.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <521A2F78.908@dalmat.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Aug 25, 2013 at 06:23:20PM +0200, Matthieu Dalstein wrote:
> Hello,
> 
> I'm currently experiencing some space issue on btrfs with linux kernel 3.10.
> My btrfs partition is full and I fail to remove any data to give some 
> free space:

Did you snapshot your filesystem? If so, delete some/all snapshots first.
Then, note that brtfs frees space after you deleted snapshots, it can take
one or several minutes before the space ends up being garbage collected.

Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/  
