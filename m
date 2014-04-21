Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:47178 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754541AbaDUVvW (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 21 Apr 2014 17:51:22 -0400
Date: Mon, 21 Apr 2014 14:51:21 -0700
From: Marc MERLIN <marc@merlins.org>
To: Chris Murphy <lists@colorremedies.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: Planning for subvolumes of subvolumes and btrfs send/receive
Message-ID: <20140421215121.GR26949@merlins.org>
References: <20140420194627.GO7884@merlins.org> <5B1404BF-F985-4201-87FD-CBB3E6776531@colorremedies.com> <20140421054829.GT7884@merlins.org> <747CE4D2-2D83-474D-8D38-E06FF49ACF04@colorremedies.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <747CE4D2-2D83-474D-8D38-E06FF49ACF04@colorremedies.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Apr 21, 2014 at 12:08:30AM -0600, Chris Murphy wrote:
> I see hard links as completely different to either subvolume/snapshot/reflink. Three hardlinks for a file all point to one file, they're aren't four unique files. But with the latter, three reflinks or snapshots are independent from the parent, including permissions/ACLs, and xattr including selinux labels.

You are correct, but if I'm deduping files for backups of the same data,
hardlinks work fine, but more importantly, they do not get lost if I copy
the filesystem to another machine.

reflink relationship pretty much gets lost no matter what tool you use,
except hopefully btrfs send/receive.

Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/  
