Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:59042 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753809AbaKSCy4 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 18 Nov 2014 21:54:56 -0500
Content-Type: text/plain; charset=windows-1252
Mime-Version: 1.0 (Mac OS X Mail 7.3 \(1878.6\))
Subject: Re: BTRFS messes up snapshot LV with origin
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <546BA96D.4050805@ubuntu.com>
Date: Tue, 18 Nov 2014 19:54:55 -0700
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Message-Id: <2A57F99C-80AA-4FD4-AA41-57F02AD4E1A2@colorremedies.com>
References: <CAE8gLhnLUBJmN=3n1SVTc3y0zbBAxSBXtMxe7rhANtwC+3dCow@mail.gmail.com> <pan$f02e0$7a5e2052$d1925753$4ad202f9@cox.net> <54699CC7.1050909@swiftspirit.co.za> <546A46A5.8030603@inwind.it> <CAE8gLh=VubBbZdeKTAuWRjOxPF7C+ouUeeVvmGfT2ckYWGhQVA@mail.gmail.com> <CAE8gLh=Lf+z2B_9EXQM_ODSOa5HZsFpFMB=kKGmQXJSjYdy5kg@mail.gmail.com> <27BDAC3B-789C-4477-B065-E703CE425F54@colorremedies.com> <546B68F8.6080008@ubuntu.com> <FC0BA13C-21E3-44DD-A87C-4BEAE4FBF9EA@colorremedies.com> <546BA96D.4050805@ubuntu.com>
To: Phillip Susi <psusi@ubuntu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Nov 18, 2014, at 1:17 PM, Phillip Susi <psusi@ubuntu.com> wrote:

> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
> 
> On 11/18/2014 2:17 PM, Chris Murphy wrote:
>> What if you have a Btrfs raid1 volume using two LV’s and then 
>> snapshot both LV’s?
> 
> That's even more silly than a single lvm snapshot under btrfs.  Just
> don't do it.

Why is it silly? Btrfs on a thin volume has practical use case aside from just being thinly provisioned, its snapshots are block device based, not merely that of an fs tree.

Looks like lvm.conf does have a way to affect LV autoactivation, and there may be another way to achieve this also. Right after the snapshot(s) they’d need to have their autoactivation disabled to avoid UUID confusion.


Chris Murphy