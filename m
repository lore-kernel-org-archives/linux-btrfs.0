Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pg0-f52.google.com ([74.125.83.52]:35620 "EHLO
        mail-pg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750995AbdBXSe4 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 24 Feb 2017 13:34:56 -0500
Received: by mail-pg0-f52.google.com with SMTP id b129so14443066pgc.2
        for <linux-btrfs@vger.kernel.org>; Fri, 24 Feb 2017 10:34:56 -0800 (PST)
Date: Fri, 24 Feb 2017 10:34:11 -0800
From: Omar Sandoval <osandov@osandov.com>
To: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Cc: Qu Wenruo <quwenruo@cn.fujitsu.com>, Christian Theune <ct@flyingcircus.io>,
        linux-btrfs@vger.kernel.org
Subject: Re: Downgrading kernel 4.9 to 4.4 with space_cache=v2 enabled?
Message-ID: <20170224183411.GA27484@vader.DHCP.thefacebook.com>
References: <BB064A3C-6F5C-4490-80A6-F42BEFAA945A@flyingcircus.io>
 <fe942684-deb3-08f1-d4c1-ae25a912f799@cn.fujitsu.com>
 <bb8ea7fc-8607-f130-47f0-94175e20e330@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <bb8ea7fc-8607-f130-47f0-94175e20e330@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Feb 24, 2017 at 07:23:42AM -0500, Austin S. Hemmelgarn wrote:
> On 2017-02-23 19:54, Qu Wenruo wrote:
> > 
> > 
> > At 02/23/2017 06:51 PM, Christian Theune wrote:
> > > Hi,
> > > 
> > > not sure whether it’s possible, but we tried space_cache=v2 and
> > > obviously after working fine in staging it broke in production. Or
> > > rather: we upgraded from 4.4 to 4.9 and enabled the space_cache. Our
> > > production volume is around 50TiB usable (underlying HW Raid 6).
> > > 
> > > The machine crashes silently every 15 hours or so and takes _ages_ to
> > > reboot. It current is stuck trying to mount the local filesystems and
> > > I guess btrfs is doing something, but I don’t have shell access yet.
> > > 
> > > I’m wondering whether we can downgrade by booting back into 4.4 or
> > > will this break things even further? (We’ve had some unpleasant
> > > surprises with FS’ in the last months, so I thought I’d rather ask.)
> > 
> > You could use "btrfs check --clear-space-cache" to completely cleanup
> > space cache. Both v1(free space cache, file based) or v2(free space
> > tree) are supported.
> > 
> > And specially for v2 space cache (space cache tree), "btrfs check
> > --clear-space-cache" will also clear the ro_compat flag, so older kernel
> > should mount the fs without problem.
> That's really good to know.  I hadn't remembered that using mount options
> didn't clear the flag.

Mounting with -oclear_cache,nospace_cache will clear the free space tree
and the ro_compat flag. Mounting with just -oclear_cache rebuilds the
free space tree (and keeps the ro_compat flag).
