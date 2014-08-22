Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:33938 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751937AbaHVWUF (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 22 Aug 2014 18:20:05 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1XKxBk-00048h-4w
	for linux-btrfs@vger.kernel.org; Sat, 23 Aug 2014 00:20:04 +0200
Received: from 83-64-176-131.alpenstrasse.xdsl-line.inode.at ([83.64.176.131])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 23 Aug 2014 00:20:04 +0200
Received: from mail by 83-64-176-131.alpenstrasse.xdsl-line.inode.at with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 23 Aug 2014 00:20:04 +0200
To: linux-btrfs@vger.kernel.org
From: Florian =?utf-8?b?R2FtYsO2Y2s=?= <mail@floga.de>
Subject: Re: superblock checksum mismatch after crash, cannot mount
Date: Fri, 22 Aug 2014 22:17:03 +0000 (UTC)
Message-ID: <loom.20140823T001402-541@post.gmane.org>
References: <53F7BD8E.10308@floga.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I am sorry, I totally forgot to post information about my systems. I use
Btrfs v3.14.2 on all systems. My Raspberry Pi, on which the crash occured,
runs on Linux Kernel 3.16.1, my other computer on which I try to recover the
file system, runs on 3.14.14.

