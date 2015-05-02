Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:43273 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750966AbbEBRaH (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sat, 2 May 2015 13:30:07 -0400
Date: Sat, 2 May 2015 10:29:42 -0700
From: Marc MERLIN <marc@merlins.org>
To: Christian Dysthe <christian@vivaldi.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>,
        Filipe David Manana <fdmanana@gmail.com>
Message-ID: <20150502172942.GN13624@merlins.org>
References: <20150502163010.GK13624@merlins.org>
 <55450046.6040100@vivaldi.com>
 <20150502170509.GM13624@merlins.org>
 <55450740.2010100@vivaldi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <55450740.2010100@vivaldi.com>
Subject: Re: 3.19.3: check tree block failed + WARNING: device 0 not present
 on scrub
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, May 02, 2015 at 01:20:00PM -0400, Christian Dysthe wrote:
> 
> 
> On 05/02/2015 01:05 PM, Marc MERLIN wrote:
> >On Sat, May 02, 2015 at 12:50:14PM -0400, Christian Dysthe wrote:
> >>Mine is still doing it. This is from today's log:
> >>
> >>/etc/cron.daily/btrfs-scrub:
> >>WARNING: device 0 not present
> >>scrub device /dev/sda3 (id 1) done
> >>	scrub started at Sat May  2 08:03:46 2015 and finished after 241 seconds
> >>	total bytes scrubbed: 109.06GiB with 0 errors
> >>scrub device  (id 0) canceled
> >>	scrub started at Sat May  2 08:03:46 2015 and was aborted after 0 seconds
> >>	total bytes scrubbed: 0.00B with 0 errors
> >>
> >>It doesn't seem to cause any problems but it would of course be good to know what it is and even get rid of it. This is my laptop with a SSD containing a small ext4 /boot partition and a latrge btrfs partition / with a /home subvolume (close to Ubuntu standard for btrfs).
> >Please run the equivalent of this on your filesystem:
> >btrfs-debug-tree -t 2 /dev/mapper/cryptroot 2>&1 | tee /tmp/debug_2.txt
> >
> >And see if it completes or fails in the middle.
> All I get is: Could not open /dev/mapper/cryptroot  The only thing
> in that directory is -control I do not have any kinds of encryption
> on anything.

I wrote "the equivalent of", so change /dev/mapper/cryptroot for your
device name :)

Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/                         | PGP 1024R/763BE901
