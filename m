Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:49198 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S932475AbaBUQzx convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 21 Feb 2014 11:55:53 -0500
Received: from c-50-183-15-223.hsd1.co.comcast.net ([50.183.15.223]:57314 helo=[192.168.1.145])
	by slmp-550-94.slc.westdc.net with esmtpsa (TLSv1:AES128-SHA:128)
	(Exim 4.82)
	(envelope-from <lists@colorremedies.com>)
	id 1WGtOB-003e44-GH
	for linux-btrfs@vger.kernel.org; Fri, 21 Feb 2014 09:55:51 -0700
From: Chris Murphy <lists@colorremedies.com>
Content-Type: text/plain; charset=us-ascii
Subject: VM nocow, should VM software set +C by default?
Message-Id: <A2EE3F12-97D9-46CD-8360-ACCFF71F149B@colorremedies.com>
Date: Fri, 21 Feb 2014 09:55:50 -0700
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Use case is a user who doesn't know that today xattr +C ought to be set on vm images when on Btrfs. They use e.g. Gnome Boxes, or Virtual Machine Manager (virt-manager) to configure pools, images, and VMs.

If libvirt were to set +C on any containing directory configured as a pool, then any copied as well as newly created images would inherit +C. So is this the long term recommended practice, and should various VM projects be asked to build this functionality? Or will there be optimizations, such as autodefrag, that will obviate the need for +C on such VM images in the somewhat near future?


Chris Murphy