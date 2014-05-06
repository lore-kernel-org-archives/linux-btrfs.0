Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:55490 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934798AbaEFLJU (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 6 May 2014 07:09:20 -0400
Date: Tue, 6 May 2014 04:08:48 -0700
From: Marc MERLIN <marc@merlins.org>
To: Wolfgang Mader <Wolfgang_Mader@brain-frog.de>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Scrub status: no stats available
Message-ID: <20140506110848.GZ10159@merlins.org>
References: <1839807.xjkknF9CU6@discus>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1839807.xjkknF9CU6@discus>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, May 06, 2014 at 11:52:58AM +0200, Wolfgang Mader wrote:
> Dear list,
> 
> I am running btrfs on Arch Linux ARM (Linux 3.14.2, Btrfs v3.14.1). I can run 
> scrub w/o errors, but I never get stats from scrub status
> 
> What I get is
>    btrfs scrub status /pools/dataPool
>    
>    scrub status for b5f082e2-2ce0-4f91-b54b-c2d26185a635
>            no stats available
>            total bytes scrubbed: 694.13GiB with 0 errors
> 
> Please mind the line "no stats available". Where can I start digging?

Here:
legolas:~# l /var/lib/btrfs/
total 16
drwxr-xr-x 1 root root  494 May  6 04:08 ./
drwxr-xr-x 1 root root 1360 Apr 27 22:15 ../
srwxr-xr-x 1 root root    0 May  6 03:48 scrub.progress.4850ee22-bf32-4131-a841-02abdb4a5ba6=
-rw------- 1 root root  428 May  6 04:08 scrub.status.4850ee22-bf32-4131-a841-02abdb4a5ba6
-rw------- 1 root root  427 May  5 05:04 scrub.status.6afd4707-876c-46d6-9de2-21c4085b7bed
-rw------- 1 root root  418 Jan 11  2013 scrub.status.92584fa9-85cd-4df6-b182-d32198b76a0b
-rw------- 1 root root  420 May 17  2013 scrub.status.9f52c100-8c89-45b6-a005-3f5de1c12b38


Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/                         | PGP 1024R/763BE901
