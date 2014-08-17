Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qc0-f171.google.com ([209.85.216.171]:63543 "EHLO
	mail-qc0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751133AbaHQMrt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 17 Aug 2014 08:47:49 -0400
Received: by mail-qc0-f171.google.com with SMTP id r5so3865116qcx.30
        for <linux-btrfs@vger.kernel.org>; Sun, 17 Aug 2014 05:47:48 -0700 (PDT)
MIME-Version: 1.0
Date: Sun, 17 Aug 2014 18:17:48 +0530
Message-ID: <CAH-HCWVO7VnT6C0wjWWJjRfaPfQy3zd_Q6oAqhyrUHfPpOZYrQ@mail.gmail.com>
Subject: exact nature of send/receive problems?
From: Shriramana Sharma <samjnaa@gmail.com>
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello. This is wrt this thread:
http://www.spinics.net/lists/linux-btrfs/msg36639.html

The OP of that thread had not clarified (IMO) what exactly he means by
"unreliability of btrfs send/receive". Is it only via ssh/network, or
even in the case of backup to local alternate (external) drive? What
exactly happens? Does it:

a) muck up existing data on the source,
b) or on the target,
c) or doesn't muck up any data but fails *silently* halfway,
d) or fails halfway and tells me it failed?

One of the important reasons I'm looking to use BTRFS is the backup
economy that send/receive promises. If this reason is going to be
affected seriously, then I'll return to BTRFS a year hence as was
suggested elsewhere...

-- 
Shriramana Sharma ஶ்ரீரமணஶர்மா श्रीरमणशर्मा
