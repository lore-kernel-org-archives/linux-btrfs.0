Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vc0-f175.google.com ([209.85.220.175]:56300 "EHLO
	mail-vc0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751446Ab3HPQvA (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 16 Aug 2013 12:51:00 -0400
Received: by mail-vc0-f175.google.com with SMTP id ia10so1615113vcb.34
        for <linux-btrfs@vger.kernel.org>; Fri, 16 Aug 2013 09:50:59 -0700 (PDT)
MIME-Version: 1.0
Date: Fri, 16 Aug 2013 11:50:59 -0500
Message-ID: <CAPidFuhbjxYUqjLV_8tCCVX6aSNwZ1qJGCZvnSPx8cShGCrQvA@mail.gmail.com>
Subject: 4 vol raid5 segfault on device delete
From: Craig Johnson <crajohns@gmail.com>
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I have a 4 device volume with raid5 - trying to remove one of the
devices (plenty of free space) and I get an almost immediate segfault.
 Scrub shows no errors, repair show space cache invalid but nothing
else (I remounted with clear cache to be safe).  Lots of corrupt on
bdev (for 3 out of 4 drives), but I have no file access issues that I
know of.  Thanks!

Output below:

http://pastebin.com/AnrmZrt2

- Craig
