Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f178.google.com ([209.85.213.178]:48149 "EHLO
	mail-ig0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751475AbaBJCdR (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 9 Feb 2014 21:33:17 -0500
Received: by mail-ig0-f178.google.com with SMTP id uq10so5775414igb.5
        for <linux-btrfs@vger.kernel.org>; Sun, 09 Feb 2014 18:33:16 -0800 (PST)
Received: from [10.0.1.18] (user-0cdvcvs.cable.mindspring.com. [24.223.179.252])
        by mx.google.com with ESMTPSA id kl8sm845928igb.3.2014.02.09.18.33.14
        for <linux-btrfs@vger.kernel.org>
        (version=TLSv1 cipher=ECDHE-RSA-RC4-SHA bits=128/128);
        Sun, 09 Feb 2014 18:33:15 -0800 (PST)
Message-ID: <52F83A69.8080503@gmail.com>
Date: Sun, 09 Feb 2014 21:33:13 -0500
From: Austin S Hemmelgarn <ahferroin7@gmail.com>
MIME-Version: 1.0
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Issue with btrfs balance
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I just recently discovered something about btrfs filesystem balance that
(as far as I can see) isn't documented anywhere, and doesn't necessarily
have an obvious (to the average user) explanation.

Apparently, trying to use -mconvert=dup or -sconvert=dup on a
multi-device filesystem using one of the RAID profiles for metadata
fails with a statement to look at the kernel log, which doesn't show
anything at all about the failure.

Based on what I've been able to understand from the source, it appears
that the kernel stops you from converting to a dup profile for metadata
in this case because it thinks that such a profile doesn't work on
multiple devices, despite the fact that you can take a single device
filesystem, and a device, and it will still work fine even without
converting the metadata/system profiles.

I feel at the very least, this should be documented, and the kernel
should give at least some indication of what went wrong.  Ideally, this
should be changed to allow converting to dup so that when converting a
multi-device filesystem to single-device, you never have to have
metadata or system chunks use a single profile.
