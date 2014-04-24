Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:53193 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751504AbaDXXO4 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 24 Apr 2014 19:14:56 -0400
Date: Thu, 24 Apr 2014 16:14:56 -0700
From: Marc MERLIN <marc@merlins.org>
To: Justin Maggard <jmaggard10@gmail.com>
Cc: Daniel Lee <longinus00@gmail.com>, linux-btrfs@vger.kernel.org
Subject: Re: Which companies are using Btrfs in production?
Message-ID: <20140424231456.GW26949@merlins.org>
References: <20140424011834.GN26949@merlins.org> <20140424011952.GO26949@merlins.org> <535912E5.7080106@gmail.com> <CAKgsxVQcNGUU2Jt3PefwwTodVdy-QzujO69Nrby-BnkYzASY4A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAKgsxVQcNGUU2Jt3PefwwTodVdy-QzujO69Nrby-BnkYzASY4A@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Apr 24, 2014 at 03:03:24PM -0700, Justin Maggard wrote:
> On Thu, Apr 24, 2014 at 6:34 AM, Daniel Lee <longinus00@gmail.com> wrote:
> > On 04/23/2014 06:19 PM, Marc MERLIN wrote:
> >> Oh while we're at it, are there companies that can say they are using btrfs
> >> in production?
> >>
> >> Marc
> > Netgear uses BTRFS as the filesystem in their refreshed ReadyNAS line.
> > They apparently use Oracle's linux distro so I assume they're relying on
> > them to do most of the heavy lifting as far as support BTRFS and
> > backporting goes since they're still on 3.0! They also have raid5/6
> > support so they are probably running BTRFS on top of md.
> >
> 
> Yes, and any contributions you see coming from me so far, come from
> NETGEAR.  I've been using my gmail account because I can't make our

Thanks. 
https://btrfs.wiki.kernel.org/index.php/Contributors
Updated :)

and you were already on
https://btrfs.wiki.kernel.org/index.php/Production_Users

Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/  
