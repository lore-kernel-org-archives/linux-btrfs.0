Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:52948 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755282AbaCCXNN (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 3 Mar 2014 18:13:13 -0500
Date: Mon, 3 Mar 2014 15:13:10 -0800
From: Marc MERLIN <marc@merlins.org>
To: Josef Bacik <jbacik@fb.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: 3.14.0-rc3 btrfs scrub is preventing my laptop from going to
 sleep
Message-ID: <20140303231310.GB16854@merlins.org>
References: <20140227190656.GA28338@merlins.org>
 <5314B446.6000400@fb.com>
 <5314B737.10609@fb.com>
 <20140303220558.GA16865@merlins.org>
 <5314FFB9.9090306@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <5314FFB9.9090306@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Mar 03, 2014 at 05:18:33PM -0500, Josef Bacik wrote:
> > Maybe it will work if we cancel the scrub as opposed to pausing it,
> > but of course it's not ideal. Is that the next step?
> 
> Sigh I thought the PM stuff called freeze_fs() but I think that was
> just tuxonice.  I don't have a quick fix at the moment, I really will
> have to wait on this until after qgroups.  Thanks,

That's ok, thanks for giving it a shot.

For now, I just stuck this in /etc/acpi/sleep.sh
awk '/btrfs/ { print $1 }' /proc/mounts | sort -u | while read fs; do btrfs scrub cancel $fs; done

Not great, but it ensures my laptop will go to sleep and not kill my
batteries with the lid closed :)

Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/                         | PGP 1024R/763BE901
