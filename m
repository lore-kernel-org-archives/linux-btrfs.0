Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:42741 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754345AbaEEFNl (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 5 May 2014 01:13:41 -0400
Date: Sun, 4 May 2014 22:06:17 -0700
From: Marc MERLIN <marc@merlins.org>
To: Daniel Lee <longinus00@gmail.com>
Cc: Brendan Hide <brendan@swiftspirit.co.za>, linux-btrfs@vger.kernel.org
Subject: Re: Is metadata redundant over more than one drive with raid0 too?
Message-ID: <20140505050617.GG10159@merlins.org>
References: <20140503232702.GC9061@merlins.org>
 <5365E4CF.3050405@swiftspirit.co.za>
 <20140504072420.GJ9061@merlins.org>
 <5366DF48.40209@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <5366DF48.40209@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, May 04, 2014 at 05:46:00PM -0700, Daniel Lee wrote:
> This often seems to confuse people and I think there is a common
> misconception that the btrfs raid/single/dup features work at the file
> level when in reality they work at a level closer to lvm/md.
> 
> If someone told you that they lost a device out of a jbod or multi disk
> lvm group(somewhat analogous to -d single) with ext on top you would
> expect them to lose data in any file that had a fragment in the lost
> region (lets ignore metadata for a moment). This is potentially up to
> 100% of the files but this should not be a surprising result. Similarly,
> someone who has lost a disk out of a md/lvm raid0 volume should not be
> surprised to have a hard time recovering any data at all from it.

That's true, but in this case I barely see the point of -m single vs -m
raid0. It sounds like they both stripe data anyway, maybe not at the
same level, but if both are striped, than they're almost the same in my
book :)

Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/                         | PGP 1024R/763BE901
