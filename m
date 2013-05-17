Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:46481 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755698Ab3EQLZq (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 17 May 2013 07:25:46 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1UdIn9-0001Wa-RW
	for linux-btrfs@vger.kernel.org; Fri, 17 May 2013 13:25:43 +0200
Received: from pro75-5-88-162-203-35.fbx.proxad.net ([88.162.203.35])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 17 May 2013 13:25:43 +0200
Received: from g2p.code by pro75-5-88-162-203-35.fbx.proxad.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 17 May 2013 13:25:43 +0200
To: linux-btrfs@vger.kernel.org
From: Gabriel de Perthuis <g2p.code@gmail.com>
Subject: Re: [PATCH 0/4] a structure for the disks scan for btrfs
Date: Fri, 17 May 2013 11:25:28 +0000 (UTC)
Message-ID: <kn5438$gkb$2@ger.gmane.org>
References: <1368788082-12090-1-git-send-email-anand.jain@oracle.com>
	<519612B1.7050601@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

> Just scan /dev/block/*.  That contains all block devices.

Oh, this is about finding nicer names.  Never mind.


