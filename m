Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:39852 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751219AbcDWHR5 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 23 Apr 2016 03:17:57 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1atrpC-0001eR-F2
	for linux-btrfs@vger.kernel.org; Sat, 23 Apr 2016 09:17:54 +0200
Received: from p5090971f.dip0.t-ipconnect.de ([80.144.151.31])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 23 Apr 2016 09:17:54 +0200
Received: from matthias by p5090971f.dip0.t-ipconnect.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 23 Apr 2016 09:17:54 +0200
To: linux-btrfs@vger.kernel.org
From: Matthias Bodenbinder <matthias@bodenbinder.de>
Subject: Re: Question: raid1 behaviour on failure
Date: Sat, 23 Apr 2016 09:17:48 +0200
Message-ID: <nff7is$13g$1@ger.gmane.org>
References: <nf1q0j$ug4$1@ger.gmane.org> <57148B2E.6010904@cn.fujitsu.com>
 <nf73cv$7vh$1@ger.gmane.org>
 <9ade4472-c99d-82a8-27c9-704b75bd87ab@cn.fujitsu.com>
 <nf9o32$7r4$1@ger.gmane.org>
 <180d89ae-32cf-ad59-2b6e-56ed82e9f439@cn.fujitsu.com>
 <nfb39q$iv0$1@ger.gmane.org>
 <1772508d-40b5-5303-8edb-29b5504216aa@cn.fujitsu.com>
 <nff6vr$odm$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <nff6vr$odm$1@ger.gmane.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am 23.04.2016 um 09:07 schrieb Matthias Bodenbinder:
> 14# mount /mnt/raid1/
> mount: wrong fs type, bad option, bad superblock on /dev/sdh,
>        missing codepage or helper program, or other error
> 
>        In some cases useful info is found in syslog - try
>        dmesg | tail or so.
> ####

My /etc/fstab has the following entry for the raid1:

UUID=16d5891f-5d52-4b29-8591-588ddf11e73d /mnt/raid1 btrfs    noauto,noatime,autodefrag  1   2

Matthias

