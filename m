Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wi0-f177.google.com ([209.85.212.177]:44717 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750849AbaALOtQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 12 Jan 2014 09:49:16 -0500
Received: by mail-wi0-f177.google.com with SMTP id hm2so1272347wib.4
        for <linux-btrfs@vger.kernel.org>; Sun, 12 Jan 2014 06:49:15 -0800 (PST)
Received: from ?IPv6:2001:980:5211:1:bdc3:8c28:edf0:e7cd? ([2001:980:5211:1:bdc3:8c28:edf0:e7cd])
        by mx.google.com with ESMTPSA id eo4sm12270425wib.9.2014.01.12.06.49.14
        for <linux-btrfs@vger.kernel.org>
        (version=TLSv1 cipher=ECDHE-RSA-RC4-SHA bits=128/128);
        Sun, 12 Jan 2014 06:49:14 -0800 (PST)
From: Remco Hosman - Yerf IT <remco@yerf-it.nl>
Content-Type: text/plain; charset=windows-1252
Subject: ENOSPC during balance
Message-Id: <97A7F0AC-8A96-4BFA-A6C0-DD878629FCF2@yerf-it.nl>
Date: Sun, 12 Jan 2014 15:49:12 +0100
To: linux-btrfs@vger.kernel.org
Mime-Version: 1.0 (Mac OS X Mail 7.1 \(1827\))
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

HI,

I am trying to convert my array from raid10 to 1, and its partially completed, but at the moment i am getting a '59366.459092] btrfs: 185 enospc errors during balance’ when i try to balance anything more with `btrfs bal start -dconvert=raid1,soft /mountpoint`

I have already scanned for files with extends over 1gig gig, and there is at least 100gig unallocated on each of the disks, and scrub reports no error at all.
Kernel is 3.13-rc7 and tools are latest from git.

Anything else i can try ?

Thanks,
Remco