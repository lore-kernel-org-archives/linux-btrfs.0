Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:48033 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753943AbcCIVKH (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 9 Mar 2016 16:10:07 -0500
Date: Wed, 9 Mar 2016 13:10:04 -0800
From: Marc MERLIN <marc@merlins.org>
To: Tobias Hunger <tobias.hunger@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: btrfs and containers
Message-ID: <20160309211004.GK27437@merlins.org>
References: <CAMdWP3G9uaTcbDWE68LYd17sf8-j11Aqo+ACRrZFFGdB995gSQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAMdWP3G9uaTcbDWE68LYd17sf8-j11Aqo+ACRrZFFGdB995gSQ@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Mar 07, 2016 at 11:55:47PM +0100, Tobias Hunger wrote:
> Hi,
> 
> I have been running systemd-nspawn containers on top of a btrfs
> filesystem for a while now.
> 
> This works great: Snapshots are a huge help to manage containers!
> 
> But today I ran btrfs subvol list . *inside* a container. To my
> surprise I got a list of *all* subvolumes on that drive. That is
> basically a complete list of containers running on the machine. I do
> not want to have that kind of information exposed to my containers.

I have a very stripped down docker image that actually mounts portion of
of my root filesystem read only.
While it's running out of a btrfs filesystem, you can't run btrfs
commands against it:
05233e5c91f0:/# btrfs fi show
05233e5c91f0:/# btrfs subvol list /
ERROR: can't perform the search - Operation not permitted
05233e5c91f0:/# btrfs subvol list .
ERROR: can't perform the search - Operation not permitted

I didn't do anything special, it's just working that way.

Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/                         | PGP 1024R/763BE901
