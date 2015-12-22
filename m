Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail0200.smtp25.com ([174.37.170.200]:58950 "EHLO
	mail0200.smtp25.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751859AbbLVIpz (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 22 Dec 2015 03:45:55 -0500
Received: from ccs.covici.com (localhost [127.0.0.1])
	by ccs.covici.com (8.14.9/8.14.8) with ESMTP id tBM8E5XS028289
	for <linux-btrfs@vger.kernel.org>; Tue, 22 Dec 2015 03:14:05 -0500
From: covici@ccs.covici.com
To: linux-btrfs@vger.kernel.org
Subject: problem after using btrfs-convert
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Date: Tue, 22 Dec 2015 03:14:05 -0500
Message-ID: <28288.1450772045@ccs.covici.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi.  I had a problem after using btrfs-convert.  The file system would
notmount, it said could not create uuid tree and the reason was no space
left on device.  I tried mounting with some options, like
nospace_cache,nodatacow, but those did not work.  I  could not extend
the file system since it was not mounted, although there should be a way
to do thisk, so I rolled back, and extended  under ext4 which does allow
extending an offline file system and tried again, successfully.  

But I wonder is there a better way to solve this and why can't you
extend an offline system?

Thanks in advance for any suggestions.

-- 
Your life is like a penny.  You're going to lose it.  The question is:
How do
you spend it?

         John Covici
         covici@ccs.covici.com
