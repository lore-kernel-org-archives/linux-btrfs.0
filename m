Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:42874 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751577AbaFAV3v (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 1 Jun 2014 17:29:51 -0400
Date: Sun, 1 Jun 2014 14:29:26 -0700
From: Marc MERLIN <marc@merlins.org>
To: =?iso-8859-1?Q?Torbj=F8rn?= <lists@skagestad.org>
Cc: Chris Mason <clm@fb.com>, linux-btrfs <linux-btrfs@vger.kernel.org>
Message-ID: <20140601212926.GH22161@merlins.org>
References: <5384D53C.9070509@skagestad.org>
 <5384E2FA.1070509@fb.com>
 <5384F0B4.7040309@skagestad.org>
 <5384F8A4.1050206@skagestad.org>
 <5384FAB2.6000204@fb.com>
 <5385007A.4000301@fb.com>
 <538579F1.10106@skagestad.org>
 <5385E794.1030002@fb.com>
 <5385F938.9010009@skagestad.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <5385F938.9010009@skagestad.org>
Subject: Re: 3.15-rc6 - btrfs-transacti:4157 blocked for more than 120
 seconds.
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, May 28, 2014 at 04:56:56PM +0200, Torbjørn wrote:
> On 05/28/2014 03:41 PM, Chris Mason wrote:
> >On 05/28/2014 01:53 AM, Torbjørn wrote:
> >
> >>It's actually a raid10 array of 11 dm-crypt devices.
> >>I'm able to read data from the array (accessing files), and also read
> >>directly from all the underlying dm-crypt devices using dd, if that's
> >>what you meant.
> >>
> >>I have not rebooted the system since that dmesg, so it's still stuck in
> >>the same state.
> >>I can keep it like that for some days. The system is not critical at all.
> >>
> >Thanks,
> >
> >Can you please capture the result of sysrq-t and sysrq-l?  Maybe the IO
> >is stuck in a thread that isn't in the D state.
> >
> >-chris
> The output of sysrq-t was too much data for pastebin, will send both
> to you as attachments outside of the list.

Considering I have experienced this with with 3.15rc but wasn't able to
save a sysrq since my save file and syslog got lost, did you find out
anything from that?

Thanks,
Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/                         | PGP 1024R/763BE901
