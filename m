Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:59711 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751677AbbHRIda (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 18 Aug 2015 04:33:30 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1ZRcKl-0004Ns-HQ
	for linux-btrfs@vger.kernel.org; Tue, 18 Aug 2015 10:33:27 +0200
Received: from pro75-5-88-162-203-35.fbx.proxad.net ([88.162.203.35])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 18 Aug 2015 10:33:27 +0200
Received: from g2p.code by pro75-5-88-162-203-35.fbx.proxad.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 18 Aug 2015 10:33:27 +0200
To: linux-btrfs@vger.kernel.org
From: Gabriel de Perthuis <g2p.code@gmail.com>
Subject: Re: [survey] sysfs layout for btrfs
Date: Tue, 18 Aug 2015 08:33:20 +0000 (UTC)
Message-ID: <mquqkg$vh9$1@ger.gmane.org>
References: <55CE7C78.1020509@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, 15 Aug 2015 07:40:40 +0800, Anand Jain wrote:

> Hello,
> 
> as of now btrfs sysfs does not include the attributes for the volume 
> manager part in its sysfs layout, so its being developed and there are 
> two types of layout here below, so I have a quick survey to know which 
> will be preferred. contenders are:
> 1. FS and VM (volume manager) attributes[1] merged sysfs layout
> 
>    /sys/fs/btrfs/<fsid> <-- holds FS attr, VM attr will be added here.
>    /sys/fs/btrfs/<fsid>/devices/<uuid [2] > <-- btrfs_devices attr here

My vote is for the first one.
Lengthening the UI/API with /pools/ seems unnecessary, and it's
better to get attributes exposed earlier.

> 2. FS and VM attributes separated sysfs layout.
> 
>   /sys/fs/btrfs/<fsid> <--- as is, will continue to hold fs attributes.
>   /sys/fs/btrfs/pools/<fsid>/ <-- will hold VM attributes
>   /sys/fs/btrfs/pools/<fsid>/devices/<sdx> <-- btrfs_devices attr here

