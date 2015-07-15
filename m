Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:59964 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753980AbbGPAbP (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 15 Jul 2015 20:31:15 -0400
Date: Wed, 15 Jul 2015 14:48:03 -0700
From: Marc MERLIN <marc@merlins.org>
To: Donald Pearson <donaldwhpearson@gmail.com>
Cc: sander@humilis.net, Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: Anyone tried out btrbk yet?
Message-ID: <20150715214803.GF5274@merlins.org>
References: <11148188.L9vtSMaNHV@merkaba>
 <559FA280.8090309@tty0.ch>
 <20150712035523.GI5274@merlins.org>
 <20150713004249.GP5274@merlins.org>
 <CAB3_QuKuTeT7t--=y917AASM9QQHSRin4ZKRm57A0b+z0m=yvA@mail.gmail.com>
 <20150715031412.GZ5274@merlins.org>
 <20150715080057.GA15200@panda>
 <CAC=t97CxDRoakqzoOAoHpN=1qS1jyvMEfOCe+RWvGTm6xSCqPQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAC=t97CxDRoakqzoOAoHpN=1qS1jyvMEfOCe+RWvGTm6xSCqPQ@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jul 15, 2015 at 09:42:28AM -0500, Donald Pearson wrote:
> Implementation question about your scripts Marc..

make sure you Cc me then, I could have missed that Email :)

> I've set up some routines for different backup and retention intervals
> and periods in cron but quickly ran in to stepping on my own toes by
> the locking mechanism.  I could just disable the locking but I'm not
> sure if that's the best approach and I don't know what it was
> implemented to prevent in the first place.

Try --postfix servername
it'll add the destination server in the snapshot rotation and the
lockfile.

Otherwise, you can just trivially modify the script to take --lock as an
argument, or you can even 
ln -s btrfs-subvolume-backup btrfs-subvolume-backupserver2
and the script will automatically make a /var/run/btrfs-subvolume-backupserver2
as a lockfile.

Hope this helps.
Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/                         | PGP 1024R/763BE901
