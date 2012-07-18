Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:45341 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751405Ab2GRVed (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 18 Jul 2012 17:34:33 -0400
Received: by obbuo13 with SMTP id uo13so2695617obb.19
        for <linux-btrfs@vger.kernel.org>; Wed, 18 Jul 2012 14:34:32 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAG1y0seiFAWfcc0onUuK8K6+2sXkB-AAhe_okRDWaB9um97abA@mail.gmail.com>
References: <20120202124241.GW16796@shiny>
	<20120202152722.GI12429@merlins.org>
	<20120201175624.GE16796@shiny>
	<20120218160702.GB32373@merlins.org>
	<20120215165540.GC4763@merlins.org>
	<20120213001400.GD31989@merlins.org>
	<20120212223242.GA31989@merlins.org>
	<20120202032345.GB31903@merlins.org>
	<20120130003754.GD4380@merlins.org>
	<20120718181316.GD16899@merlins.org>
	<CAG1y0seiFAWfcc0onUuK8K6+2sXkB-AAhe_okRDWaB9um97abA@mail.gmail.com>
Date: Wed, 18 Jul 2012 23:34:32 +0200
Message-ID: <CAFvQSYSAoL2=jmwbP1JE7rRg+LRbmpaO+sETmacVZomWFgtE-Q@mail.gmail.com>
Subject: Re: brtfs on top of dmcrypt with SSD -> Trim or no Trim
From: Clemens Eisserer <linuxhippy@gmail.com>
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

> Not using TRIM on my Crucial RealSSD C300 256GB is most likely what caused
> its garbage collection algorithm to fail (killing the drive and all its
> data), and it was also causing BRTFS to hang badly when I was getting
> within 10GB of the drive getting full.

Funny thing, as without TRIM the drive does not even know how "full" it is ;)

- Clemens
