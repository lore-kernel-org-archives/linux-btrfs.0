Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:53031 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751783AbaI0QXg (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 27 Sep 2014 12:23:36 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1XXumT-0000JL-E6
	for linux-btrfs@vger.kernel.org; Sat, 27 Sep 2014 18:23:33 +0200
Received: from pd953eb7c.dip0.t-ipconnect.de ([217.83.235.124])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 27 Sep 2014 18:23:33 +0200
Received: from holger.hoffstaette by pd953eb7c.dip0.t-ipconnect.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 27 Sep 2014 18:23:33 +0200
To: linux-btrfs@vger.kernel.org
From: Holger =?iso-8859-1?q?Hoffst=E4tte?=
	<holger.hoffstaette@googlemail.com>
Subject: Wiki bug re. metadata_ratio mount option
Date: Sat, 27 Sep 2014 16:23:19 +0000 (UTC)
Message-ID: <pan.2014.09.27.16.23.19@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


The wiki page https://btrfs.wiki.kernel.org/index.php/Mount_options has
outdated information regarding the "metadata-ratio" option.

It says:

 metadata_ratio=number
   Sets the number of data chunks that need to be allocated to force a
   metadata chunk allocation. By default this is set to 8 (meaning that
   data:metadata are 1:8). 

Both the 'mount' man page and a look at the code (disk-io.c:open_ctree())
confirm that this is incorrect, and that forced metadata chunk allocation
will be skipped by default.

Could someone with an account please update this?

Thanks,
Holger

