Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:46893 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758382AbaD2RSA (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 29 Apr 2014 13:18:00 -0400
Date: Tue, 29 Apr 2014 10:17:49 -0700
From: Marc MERLIN <marc@merlins.org>
To: Duncan <1i5t5.duncan@cox.net>
Cc: linux-btrfs@vger.kernel.org
Message-ID: <20140429171749.GI12281@merlins.org>
References: <cover.1398786620.git.dsterba@suse.cz>
 <pan$274e8$4b1540e1$e4bc4fe0$2126c4cf@cox.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <pan$274e8$4b1540e1$e4bc4fe0$2126c4cf@cox.net>
Subject: Re: [PATCH 00/14] Enhanced df - followup
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Apr 29, 2014 at 05:10:31PM +0000, Duncan wrote:
> David Sterba posted on Tue, 29 Apr 2014 17:56:47 +0200 as excerpted:
> 
> > Changes:
> > * btrfs filesystem disk_usage - renamed to usage
> 
> Hopefully this isn't rehashing an old discussion, but...
> 
> Simpler is good, and getting rid of the _ is good, but...
(...) 
> Given that confusion, I'd suggest either simply making it du, or making 
> it "device_usage" but with "du" a documented alias printing exactly the 
> same output, thus giving folks an easy way to avoid the _.

It's also fine to just use disk-usage instead of disk_usage.

Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/                         | PGP 1024R/763BE901
