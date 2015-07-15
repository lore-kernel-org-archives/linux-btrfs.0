Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:59968 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753980AbbGPAbz (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 15 Jul 2015 20:31:55 -0400
Date: Wed, 15 Jul 2015 14:49:13 -0700
From: Marc MERLIN <marc@merlins.org>
To: Donald Pearson <donaldwhpearson@gmail.com>
Cc: sander@humilis.net, Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: Anyone tried out btrbk yet?
Message-ID: <20150715214913.GG5274@merlins.org>
References: <11148188.L9vtSMaNHV@merkaba>
 <559FA280.8090309@tty0.ch>
 <20150712035523.GI5274@merlins.org>
 <20150713004249.GP5274@merlins.org>
 <CAB3_QuKuTeT7t--=y917AASM9QQHSRin4ZKRm57A0b+z0m=yvA@mail.gmail.com>
 <20150715031412.GZ5274@merlins.org>
 <20150715080057.GA15200@panda>
 <CAC=t97CxDRoakqzoOAoHpN=1qS1jyvMEfOCe+RWvGTm6xSCqPQ@mail.gmail.com>
 <CAC=t97BS2gNNLZEatTRCmmiUHLH8m6NFbgtkbWnaqrEsCye1KQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAC=t97BS2gNNLZEatTRCmmiUHLH8m6NFbgtkbWnaqrEsCye1KQ@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jul 15, 2015 at 01:02:29PM -0500, Donald Pearson wrote:
> BTW, is anybody else experiencing btrfs-cleaner consuming heavy
> resources for a very long time when snapshots are removed?
 
Yes, that's normal. It spends a long time to reclaim blocks and free
them, especially if they are on a hard drive and not SSD.

Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/                         | PGP 1024R/763BE901
