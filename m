Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:49248 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752397AbaKZMuS (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 26 Nov 2014 07:50:18 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1Xtc2w-0004lf-W9
	for linux-btrfs@vger.kernel.org; Wed, 26 Nov 2014 13:50:15 +0100
Received: from p4ff5822c.dip0.t-ipconnect.de ([79.245.130.44])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 26 Nov 2014 13:50:14 +0100
Received: from holger.hoffstaette by p4ff5822c.dip0.t-ipconnect.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 26 Nov 2014 13:50:14 +0100
To: linux-btrfs@vger.kernel.org
From: Holger =?iso-8859-1?q?Hoffst=E4tte?=
	<holger.hoffstaette@googlemail.com>
Subject: Re: [RFC PATCH] Btrfs: add sha256 checksum option
Date: Wed, 26 Nov 2014 12:50:03 +0000 (UTC)
Message-ID: <pan.2014.11.26.12.50.03@googlemail.com>
References: <1416806586-18050-1-git-send-email-bo.li.liu@oracle.com>
	<pan.2014.11.24.08.23.25@googlemail.com>
	<pan$e596a$cfc2cde2$6957e9d8$10a112b8@cox.net>
	<CAJBj3veoV=QYF27+zFcJHf9OA0mXVzTU4gYrRz_9cAmVRxrF6Q@mail.gmail.com>
	<20141125103024.GC23574@localhost.localdomain>
	<CAJBj3vckdFCwh0vr7kF-_z8-PnTN5zL1zy_zcma2waDfTqj6GA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, 25 Nov 2014 15:17:58 -0800, John Williams wrote:

> 2) CityHash : for 256-bit hashes on all systems
> https://code.google.com/p/cityhash/

Btw this is now superseded by Farmhash:
https://code.google.com/p/farmhash/

-h

