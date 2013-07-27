Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.187]:58738 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752592Ab3G0Swx (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 27 Jul 2013 14:52:53 -0400
Message-ID: <51F41702.2000508@friedels.name>
Date: Sat, 27 Jul 2013 20:52:50 +0200
From: Hendrik Friedel <hendrik@friedels.name>
MIME-Version: 1.0
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Mount multiple-device-filesystem by UUID
References: <51F41660.1070405@friedels.name>
In-Reply-To: <51F41660.1070405@friedels.name>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

As stated in the wiki, multiple-device filesystems (e.g. raid 1) will 
only mount after a btfs device scan, or if all devices are passed with 
the mount options.

I remember, that for Ubuntu 12.04 I changed the initrd. But after a 
re-install, I have to do this again, and I don't remember how I did it.

So, the other option would be passing the devices in the fstab. But 
here, I'd prefer UUIDs rather than device names, as they can change.

Is this possible? What is the syntax?

Regards,
Hendrik


