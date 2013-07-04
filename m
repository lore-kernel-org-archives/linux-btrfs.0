Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qe0-f44.google.com ([209.85.128.44]:46952 "EHLO
	mail-qe0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753387Ab3GDLDj (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 4 Jul 2013 07:03:39 -0400
Received: by mail-qe0-f44.google.com with SMTP id 5so675373qeb.31
        for <linux-btrfs@vger.kernel.org>; Thu, 04 Jul 2013 04:03:38 -0700 (PDT)
MIME-Version: 1.0
Date: Thu, 4 Jul 2013 14:03:38 +0300
Message-ID: <CADV-EXG2fjxomEBRVbKw7o5wNLmze1H+DQkMiuM56RONhfCvXg@mail.gmail.com>
Subject: mkfs: specify subvolume for rootfs directory
From: Yevhen Kyriukha <kirgene@gmail.com>
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi!

I'm using following command to create btrfs filesystem image with
predefined content:
mkfs.btrfs -b 300M -r /tmp/source-root-dir rootfs.btrfs
This command creates image and put everything under root subvolume (/).
But I want to put everything under "/my_rootfs" subvolume.

How can I accomplish this?
Or can you point me the way to develop this feature in mkfs.

Thanks!

Best regards,
Yevhen
