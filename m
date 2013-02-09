Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:56936 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752605Ab3BIKbx (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sat, 9 Feb 2013 05:31:53 -0500
Date: Sat, 9 Feb 2013 02:30:39 -0800
From: Marc MERLIN <marc@merlins.org>
To: Florian Hofmann <fhofmann@techfak.uni-bielefeld.de>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Fwd: Current State of BTRFS
Message-ID: <20130209103039.GA11520@merlins.org>
References: <CAM-0MpVDJ+TGC6x9JHd+wG5dsACdN4Y+JFgksQCsiwzGQYNanA@mail.gmail.com>
 <CAM-0MpXTU5KUAy0tEcMu_eh5Fa75kEkUiuY8NBV-RpWp1GtypQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAM-0MpXTU5KUAy0tEcMu_eh5Fa75kEkUiuY8NBV-RpWp1GtypQ@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Feb 08, 2013 at 10:30:04PM +0100, Florian Hofmann wrote:
> Hi everybody,
> 
> I am using btrfs as my main fs for some time now, but I am
> experiencing severe performance drawbacks. I can't qualify the
> circumstances, but sometimes during disc access the whole system
> freezes for some time.
> 
> Maybe somebody could suggest some general things I could try to search
> for the problem?

Are you running on an SSD?

If so, that is likely your problem.

Depending on your SSD:
- it's going bad
- it's running out of blocks to reallocate, or being very slow 
- other firmware issue

Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/
