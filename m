Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qc0-f195.google.com ([209.85.216.195]:33083 "EHLO
	mail-qc0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753173AbbFKNAD (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 11 Jun 2015 09:00:03 -0400
Received: by qcrw7 with SMTP id w7so491909qcr.0
        for <linux-btrfs@vger.kernel.org>; Thu, 11 Jun 2015 06:00:02 -0700 (PDT)
MIME-Version: 1.0
Date: Thu, 11 Jun 2015 20:44:35 +0800
Message-ID: <CAGnHSEkjM2LVCvHgtpL6BKu8tabnZO5pcBaJQdf=B4P10UC3OQ@mail.gmail.com>
Subject: What is `mkfs.btrfs -r $rootdir` supposed to be used with?
From: Tom Yan <tom.ty89@gmail.com>
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I know `mkfs.btrfs -r $rootdir` copies whatever in $rootdir to the
newly created filesystem.

When I try to use it for a block device, it creates a "minimal"
filesystem which can only be mounted read-only.

When I use it for an (qemu raw) image, it seems to work but it also gives:
 ERROR: device scan failed 'test.img' - Block device required
in the process.

So what is it supposed to be used with?
