Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:40558 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751988AbbJEInl (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 5 Oct 2015 04:43:41 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1Zj1Mu-0002n7-KB
	for linux-btrfs@vger.kernel.org; Mon, 05 Oct 2015 10:43:36 +0200
Received: from coffee.modeemi.fi ([130.230.72.140])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 05 Oct 2015 10:43:36 +0200
Received: from flux-btrfs by coffee.modeemi.fi with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 05 Oct 2015 10:43:36 +0200
To: linux-btrfs@vger.kernel.org
From: Erkki Seppala <flux-btrfs@inside.org>
Subject: Re: BTRFS as image store for KVM?
Date: Mon, 05 Oct 2015 11:43:18 +0300
Message-ID: <m498u7hd7tl.fsf@coffee.modeemi.fi>
References: <55F88ECC.1040604@menke.ac>
	<201510021421.09558.russell@coker.com.au> <560E737C.7050206@gmail.com>
	<201510031832.17802.russell@coker.com.au>
	<pan$e9b6$f764fa8a$deeffa51$be52ef68@cox.net>
	<56111598.2080403@bouton.name>
Mime-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Lionel Bouton <lionel-subscription@bouton.name> writes:

> 1/ AFAIK the kernel md RAID1 code behaves the same (last time I checked
> you need 2 processes to read from 2 devices at once) and I've never seen
> anyone arguing that the current md code is unstable.

This indeed seems to be the case on my MD RAID1 HDD.

But on MD SSD RAID10 it does use all the four devices (using dd on the
md raid device and inspection iostat at the samy time).

So the lack of MD RAID1 doing it on HDDs seems to be for devices that
don't perform well in random access scenarios, as you mentioned.

In practical terms I seem to be getting about 1.1 GB/s from the 4 SSDs
with 'dd', whereas I seem to be getting ~650 MB/s when I dd from two
fastest components of the MD device at the same time. As it seems that I
get 330 M/s from two of the SSDs and 150M/s from the other two, it seems
the concurrent RAID10 IO is scaling linearly.

(In fact maybe I should look into why the two devices are getting lower
speeds overall - they used to be fast.)

I didn't calculate how large the linearly transferred chunks would need
to be to overcome the seek altency. Probably quite large.

-- 
  _____________________________________________________________________
     / __// /__ ____  __               http://www.modeemi.fi/~flux/\   \
    / /_ / // // /\ \/ /                                            \  /
   /_/  /_/ \___/ /_/\_\@modeemi.fi                                  \/

