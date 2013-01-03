Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mailout01.t-online.de ([194.25.134.80]:54353 "EHLO
	mailout01.t-online.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754285Ab3ACWHm (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 3 Jan 2013 17:07:42 -0500
Date: 03 Jan 2013 23:07:00 +0100
From: Hullen@t-online.de (Helmut Hullen)
To: linux-btrfs@vger.kernel.org
Message-ID: <CO8jfs0uCXB@helmut.hullen.de>
In-Reply-To: <125D7A41-DBE8-40C0-B8EE-B64DD2D95A93@colorremedies.com>
Subject: Re: Option LABEL
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Reply-To: helmut@hullen.de
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hallo, Chris,

Du meintest am 03.01.13:

>>> On my system (a bundle of /dev/sdb, /dev/sdc, /dev/sdd)
>>>
>>>        btrfs fi label /dev/sdb mylabel
>>>
>>> only sets the label on the (unmounted) device /dev/sdb. "/dev/sdc"
>>> and "/dev/sdd" remain without label.

>>   This is a bug.

> It's a bug that appears to be fixed. I inadvertently tested it first
> on CentOS 6.0 which has quite an older kernel and btrfsprogs. And
> Fedora 18 of course has a much newer kernel and btrfs-progs so I have
> no idea when in between those two this was fixed.

> Helmut what kernel and btrfs-progs or distribution are you using? I
> think newer progs fixes this.

Kernel 3.4.6 (self made), btrfs-progs downloaded and compiled 2 days ago  
(Mason version, not Mills version).

I've just brewed Kernel 3.6.11 but I have to wait some days (backing up  
some Tbytes of data) before I can test btrfs with this newer kernel.

But looking for btrfs in the ChangeLog files for kernels 3.4 to 3.6  
doesn't show any entry which might be related to the above error.
(Kernels 3.4.3, 3.4.5, 3.4.8, 3.5.1, 3.5.4)

Viele Gruesse!
Helmut
