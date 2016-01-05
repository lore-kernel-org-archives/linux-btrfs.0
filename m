Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ob0-f172.google.com ([209.85.214.172]:36782 "EHLO
	mail-ob0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751608AbcAEMZ4 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 5 Jan 2016 07:25:56 -0500
Received: by mail-ob0-f172.google.com with SMTP id ba1so272291856obb.3
        for <linux-btrfs@vger.kernel.org>; Tue, 05 Jan 2016 04:25:56 -0800 (PST)
MIME-Version: 1.0
From: Sylvain Joyeux <sylvain.joyeux@m4x.org>
Date: Tue, 5 Jan 2016 10:25:36 -0200
Message-ID: <CAFENT7KXjVBa0n16=FuWhK6xvgFZ7N5GdH_dVufaZbsx9wmeNA@mail.gmail.com>
Subject: Replace a corrupted block using a known-good file from another
 filesystem ?
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

In the course of the few btrfs crashes I had on my USB backup drive
(NOT the drive from my other bug report, which is an internal SATA
drive) - in the last 6 months or so - I ended up having a 4 to 5 bad
checksums reported by scrub.

This drive is used to synchronize snapshots from my main machine, and
the corrupted files are system files that are still present on the
main machine.

I could obviously reset the filesystem on the USB drive, but since the
goal is to keep a backup history (which the main machine does not
keep), I would rather avoid that.

Would there be a way to replace the bad blocks using the good file on
the main filesystem ? Replacing it in each snapshot separately does
not look very appealing as the file is present on most of them.

Sylvain
