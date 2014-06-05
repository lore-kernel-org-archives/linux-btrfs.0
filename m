Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:56687 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751221AbaFETF1 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 5 Jun 2014 15:05:27 -0400
Date: Thu, 5 Jun 2014 12:05:26 -0700
From: Marc MERLIN <marc@merlins.org>
To: Chris Murphy <lists@colorremedies.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: Using BTRFS on SSD now ?
Message-ID: <20140605190526.GS7210@merlins.org>
References: <2215647.hErg5R77lo@zafu> <20140605145632.GD14713@merlins.org> <FFF0E455-5905-47D4-A768-96CA2FEDF3B3@colorremedies.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <FFF0E455-5905-47D4-A768-96CA2FEDF3B3@colorremedies.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jun 05, 2014 at 12:13:37PM -0600, Chris Murphy wrote:
> I'd say, what slight additional wear occurs from not using discard, makes the SSD die sooner in order to justify getting a new SSD that maybe (?) doesn't have this problem anymore.

Your points are well noted, although on the flipside I've had an SSD
perform horribly because without TRIM, it had to use its own garbage
collection which was horrible. Also, if you rely on garbage collection, you
need to make sure to make an empty partition with 5 or 10% of your space and
never use it so that yoru SSD can easily use that for garbage collection
without impacting performance too much.

Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/  
