Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f174.google.com ([209.85.223.174]:34725 "EHLO
	mail-io0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751652AbcBEU15 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 5 Feb 2016 15:27:57 -0500
Received: by mail-io0-f174.google.com with SMTP id 9so141532115iom.1
        for <linux-btrfs@vger.kernel.org>; Fri, 05 Feb 2016 12:27:57 -0800 (PST)
Received: from [192.168.0.233] ([65.94.14.3])
        by smtp.googlemail.com with ESMTPSA id o14sm101897igi.21.2016.02.05.12.27.56
        for <linux-btrfs@vger.kernel.org>
        (version=TLSv1/SSLv3 cipher=OTHER);
        Fri, 05 Feb 2016 12:27:56 -0800 (PST)
To: linux-btrfs@vger.kernel.org
From: Nicholas D Steeves <nsteeves@gmail.com>
Subject: btrfs-progs4.4 with linux-3.16.7 (with truncation of extends patch)
Message-ID: <56B505CB.8080604@gmail.com>
Date: Fri, 5 Feb 2016 15:27:55 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

Is it safe to use btrfs-progs-4.4 with linux-3.16.7 patched with the 
following:

linux-3.16.7
Btrfs: fix truncation of compressed and inlined extents
https://git.kernel.org/linus/0305cd5f7fca85dae392b9ba85b116896eb7c1c7

The specific case I'm looking into is when a Debian user sticks with the 
default kernel, but installs btrfs-progs-4.4 from backports.  I've also 
read that there will be some userspace<->kernel compatibility checks 
added to btrfs-progs at some point, but I wasn't able to find recent 
news on its progress.

Kind regards,
Nicholas
