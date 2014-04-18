Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mondschein.lichtvoll.de ([194.150.191.11]:59949 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751305AbaDYJbe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 25 Apr 2014 05:31:34 -0400
Received: from merkaba.localnet (host-188-174-207-215.customer.m-online.net [188.174.207.215])
	by mail.lichtvoll.de (Postfix) with ESMTPSA id 066CC7DA
	for <linux-btrfs@vger.kernel.org>; Fri, 25 Apr 2014 11:31:06 +0200 (CEST)
From: Martin Steigerwald <Martin@lichtvoll.de>
To: linux-btrfs@vger.kernel.org
Subject: how to cancel scrub which got aborted due to hardly switching off the machine?
Date: Fri, 18 Apr 2014 19:18:18 +0200
Message-ID: <12598280.ebLKYkuoEp@merkaba>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

I have:

merkaba:/mnt#1> btrfs scrub status -d /home
scrub status for […]
scrub device /dev/dm-0 (id 1) status
        scrub started at Fri Apr 18 17:48:10 2014, running for 335 seconds
        total bytes scrubbed: 74.80GiB with 0 errors
scrub device /dev/mapper/sata-home (id 2) status
        scrub started at Fri Apr 18 17:48:10 2014, running for 335 seconds
        total bytes scrubbed: 69.86GiB with 0 errors


merkaba:/mnt#2> btrfs scrub resume /home
ERROR: scrub is already running.
To cancel use 'btrfs scrub cancel /home'.
To see the status use 'btrfs scrub status [-d] /home'.


merkaba:/mnt#1> btrfs scrub cancel /home
ERROR: scrub cancel failed on /home: not running

merkaba:~> btrfs scrub start /home    
ERROR: scrub is already running.
To cancel use 'btrfs scrub cancel /home'.
To see the status use 'btrfs scrub status [-d] /home'.


merkaba:~> cat /proc/version
Linux version 3.14.0-tp520 (martin@merkaba) (gcc version 4.8.2 (Debian 
4.8.2-17) ) #52 SMP PREEMPT Mon Mar 31 13:41:48 CEST 2014


Seems like an logic error.

How to get out of there?


Thanks,
-- 
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
