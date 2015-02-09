Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f172.google.com ([209.85.213.172]:35809 "EHLO
	mail-ig0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750794AbbBIFRv (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 9 Feb 2015 00:17:51 -0500
Received: by mail-ig0-f172.google.com with SMTP id l13so14159419iga.5
        for <linux-btrfs@vger.kernel.org>; Sun, 08 Feb 2015 21:17:51 -0800 (PST)
Received: from [127.0.0.1] ([162.220.216.23])
        by mx.google.com with ESMTPSA id s10sm5046894igr.2.2015.02.08.21.17.50
        for <linux-btrfs@vger.kernel.org>
        (version=TLSv1 cipher=ECDHE-RSA-RC4-SHA bits=128/128);
        Sun, 08 Feb 2015 21:17:50 -0800 (PST)
Message-ID: <54D842FD.1010806@virtualcomplete.com>
Date: Mon, 09 Feb 2015 00:17:49 -0500
From: "Devon B." <devon.b@virtualcomplete.com>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: Accepting discard to free space from disk images
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Looking to use btrfs with disk images that contain ext4, xfs, and other
possible filesystems.  One of my main concerns is reclaiming disk space
when files are deleted on the disk image's filesystem.  Using fstrim on
the mount point of the disk image or mounting the disk image (loop) with
discard doesn't appear to pass the freed blocks to btrfs.

The image file on the btrfs filesystem just keeps growing in size.  When
hosting images on ext4, using fstrim or discard frees up the space on
the host filesystem (ext4).

I see discard is pretty well supported for btrfs to the underlying block
devices but is there any way to properly free space on the btrfs host
filesystem from overlying filesystems while they are online?

Thanks.
