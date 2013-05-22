Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pa0-f51.google.com ([209.85.220.51]:46734 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753984Ab3EVNWn (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 22 May 2013 09:22:43 -0400
Received: by mail-pa0-f51.google.com with SMTP id lf10so763900pab.24
        for <linux-btrfs@vger.kernel.org>; Wed, 22 May 2013 06:22:42 -0700 (PDT)
MIME-Version: 1.0
Date: Wed, 22 May 2013 15:22:42 +0200
Message-ID: <CAFirYm_LZh74n=x7_Jp_M_t3FHsuPfvWsiNRNmJY1H5gvXg8hQ@mail.gmail.com>
Subject: Top shows brtfs-cache-1 and brtfs-endio-met while the hard drives
 seem busy
From: Laurent Humblet <laurent.humblet@gmail.com>
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

I have setup about a year ago a BTRFS RAID 1 filesystem on two 2TB
Western Digital WD20EARS hard drives and I have created subvolumes
that I mount regularly as I need them.  I put mostly music, videos and
various files on them as well as some Git bare repositories for my
work files but for the last couple of weeks, there seems to be some
activity happening on the drives for a few minutes and the following
processes are showing up while this happens: brtfs-cache-1 and
brtfs-endio-met.  It seems that brtfs-cache-1 is more 'busy' than
brtfs-endio-met but after a while everything seems fine again.

Is there anything I should worry about?  I will soon do a full backup
on ext4 just to make sure I don't loose anything but is there any
checks I can run on the drives to make sure everything is fine both on
a hardware standpoint and on a data integrity standoint?

Thank you for your help,
All the best,
Laurent
