Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:57327 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750918AbaCWS6R (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 23 Mar 2014 14:58:17 -0400
Received: from merlin by mail1.merlins.org with local (Exim 4.80 #2)
	id 1WRnb6-0002ZZ-Gr
	for <linux-btrfs@vger.kernel.org>; Sun, 23 Mar 2014 11:58:16 -0700
Date: Sun, 23 Mar 2014 11:58:16 -0700
From: Marc MERLIN <marc@merlins.org>
To: linux-btrfs@vger.kernel.org
Subject: Re: Cannot add device "is mounted" for unmounted drive that used to be in raidset that is mounted
Message-ID: <20140323185816.GA3732@merlins.org>
References: <20140323180907.GA22171@merlins.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20140323180907.GA22171@merlins.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Mar 23, 2014 at 11:09:07AM -0700, Marc MERLIN wrote:
> I found out that a drive that used to be part of a raid system that is mounted
> and running without it, btrfs apparently decides that the drive is part of the mounted
> raidset and in use.
> As a result, I had to eventually dd 0's over it, btrfs device scan, and finally
> I was able to use it again.

I filed a bug for this, it's a bit more minor, but worth fixing eventually
https://bugzilla.kernel.org/show_bug.cgi?id=72771

Marc

-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/  
