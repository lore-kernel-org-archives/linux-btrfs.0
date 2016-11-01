Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:43005 "EHLO
        mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754844AbcKAEVs (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 1 Nov 2016 00:21:48 -0400
Date: Mon, 31 Oct 2016 21:21:40 -0700
From: Marc MERLIN <marc@merlins.org>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: Hugo Mills <hugo@carfax.org.uk>, linux-btrfs@vger.kernel.org
Message-ID: <20161101042140.atn73lqehgpqslgz@merlins.org>
References: <60a0ce1f-7b2f-325e-51f7-ccad054fab8b@cn.fujitsu.com>
 <20161031054719.GN28648@merlins.org>
 <b31eaf2d-b339-6163-0108-28d1586c05e5@cn.fujitsu.com>
 <20161031062509.GO28648@merlins.org>
 <0c9e25b1-c8e1-6300-0c79-e9e3e8fd0f52@cn.fujitsu.com>
 <20161031063737.GP28648@merlins.org>
 <81e30812-be45-b4ff-3bf2-c79e805d445a@cn.fujitsu.com>
 <20161031084412.GI16645@carfax.org.uk>
 <20161031150422.GQ28648@merlins.org>
 <38fa8b04-ec2d-884f-e03c-8bc2fb888efb@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <38fa8b04-ec2d-884f-e03c-8bc2fb888efb@cn.fujitsu.com>
Subject: Re: btrfs check --repair: ERROR: cannot read chunk root
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Nov 01, 2016 at 12:13:38PM +0800, Qu Wenruo wrote:
> Would you try to locate the range where we starts to fail to read?
> 
> I still think the root problem is we failed to read the device in user
> space.
 
Understood.

I'll run this then:
myth:~# dd if=/dev/mapper/crypt_bcache0 of=/dev/null bs=1M &
[2] 21108
myth:~# while :; do killall -USR1 dd; sleep 1200; done
275+0 records in
274+0 records out
287309824 bytes (287 MB) copied, 7.20248 s, 39.9 MB/s

This will take a while to run, I'll report back on how far it goes.

Thanks,
Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/                         | PGP 1024R/763BE901
