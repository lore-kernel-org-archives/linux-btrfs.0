Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:48918 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752505Ab3EASIO (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 1 May 2013 14:08:14 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1UXbRo-0000TW-3s
	for linux-btrfs@vger.kernel.org; Wed, 01 May 2013 20:08:10 +0200
Received: from pro75-5-88-162-203-35.fbx.proxad.net ([88.162.203.35])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 01 May 2013 20:08:08 +0200
Received: from g2p.code by pro75-5-88-162-203-35.fbx.proxad.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 01 May 2013 20:08:08 +0200
To: linux-btrfs@vger.kernel.org
From: Gabriel de Perthuis <g2p.code@gmail.com>
Subject: Re: [PATCH v3 2/2] Btrfs: online data deduplication
Date: Wed, 1 May 2013 18:07:57 +0000 (UTC)
Message-ID: <klrlls$l60$1@ger.gmane.org>
References: <1367425659-10803-1-git-send-email-bo.li.liu@oracle.com>
	<1367425659-10803-3-git-send-email-bo.li.liu@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

>  #define BTRFS_IOC_DEV_REPLACE _IOWR(BTRFS_IOCTL_MAGIC, 53, \
>  				    struct btrfs_ioctl_dev_replace_args)
> +#define BTRFS_IOC_DEDUP_REGISTER	_IO(BTRFS_IOCTL_MAGIC, 54)

This number has already been used by the offline dedup patches.

