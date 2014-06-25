Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f171.google.com ([209.85.213.171]:41238 "EHLO
	mail-ig0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932143AbaFYXlT (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 25 Jun 2014 19:41:19 -0400
Received: by mail-ig0-f171.google.com with SMTP id h18so69364igc.16
        for <linux-btrfs@vger.kernel.org>; Wed, 25 Jun 2014 16:41:18 -0700 (PDT)
Received: from [192.168.1.6] ([216.26.106.6])
        by mx.google.com with ESMTPSA id aw9sm10971815igc.9.2014.06.25.16.41.17
        for <linux-btrfs@vger.kernel.org>
        (version=TLSv1 cipher=ECDHE-RSA-RC4-SHA bits=128/128);
        Wed, 25 Jun 2014 16:41:17 -0700 (PDT)
Message-ID: <53AB5E1C.1080409@gmail.com>
Date: Wed, 25 Jun 2014 18:41:16 -0500
From: Kevin Brandstatter <icarusthecow@gmail.com>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: df hangs / VirtualBox unable to start
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

i'm experiencing what I think are issues with btrfs and suspend/resume,
after a resume, I can no longer start any virtual machines in virtualbox
also, if I attempt a df command, it will just hang. Both of these events
work fine
prior to suspend resume as well as before I migrated to btrfs.

Things that I've tried

btrfs fi sync /home
btrfs scrub start /home
btrfs fi df /home (no errors reported)
btrfs fi show /home (Btrfs v3.14.2-dirty during scrub)

The only thing that I have found that fixes the problem is a total
system reboot

Additional info
kernel 3.15.1-1-ARCH
btrfsprogs v3.14.2

let me know what other information I can provide to figure out the cause.

-Kevin Brandstatter
