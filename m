Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:55619 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754780AbaDLUF7 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 12 Apr 2014 16:05:59 -0400
Received: from c-75-70-18-61.hsd1.co.comcast.net ([75.70.18.61]:49284 helo=[192.168.1.145])
	by slmp-550-94.slc.westdc.net with esmtpsa (TLSv1:AES128-SHA:128)
	(Exim 4.82)
	(envelope-from <lists@colorremedies.com>)
	id 1WZ4Bb-002dCx-Fn
	for linux-btrfs@vger.kernel.org; Sat, 12 Apr 2014 14:05:59 -0600
From: Chris Murphy <lists@colorremedies.com>
Content-Type: text/plain; charset=us-ascii
Subject: Re: mount options ignored / unclear
Message-Id: <EFF3164F-AD2E-418C-9445-C67A3CABDC92@colorremedies.com>
Date: Sat, 12 Apr 2014 14:05:57 -0600
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Best as I can tell, the file system independent mount options can be done per subvolume; while the file system specific mount options apply file system wide, i.e. the options use to mount the first instance of the file system are the ones used for subsequent mounts. To change them requires use of -o remount in which case all mounted subvolume inherit the new mount options.


Chris Murphy