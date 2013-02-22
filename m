Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pa0-f51.google.com ([209.85.220.51]:34986 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757765Ab3BVRLb (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 22 Feb 2013 12:11:31 -0500
Received: by mail-pa0-f51.google.com with SMTP id hz1so573961pad.10
        for <linux-btrfs@vger.kernel.org>; Fri, 22 Feb 2013 09:11:30 -0800 (PST)
Message-ID: <5127A6C0.6080104@alumni.calpoly.edu>
Date: Fri, 22 Feb 2013 09:11:28 -0800
From: Mike Power <dodtsair@gmail.com>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: copy on write misconception
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I think I have a misconception of what copy on write in btrfs means for 
individual files.

I had originally thought that I could create a large file:
time dd if=/dev/zero of=10G bs=1G count=10
10+0 records in
10+0 records out
10737418240 bytes (11 GB) copied, 100.071 s, 107 MB/s

real    1m41.082s
user    0m0.000s
sys    0m7.792s

Then if I copied this file no blocks would be copied until they are 
written.  Hence the two files would use the same blocks underneath. But 
specifically that copy would be fast.  Since it would only need to write 
some metadata.  But when I copy the file:
time cp 10G 10G2

real    3m38.790s
user    0m0.124s
sys    0m10.709s

Oddly enough it actually takes longer then the initial file creation.  
So I am guessing that the long duration copy of the file is expected and 
that is not one of the virtues of btrfs copy on write.  Does that sound 
right?

I was looking at a virtual machine solution and thought btrfs would be 
great if I could copy the vm disk to a new file at low cost and then 
launch that vm and customize it to my needs.

OS Ubuntu 12.10

Mike Power
