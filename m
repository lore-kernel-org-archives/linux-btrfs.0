Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from know-smtprelay-omc-1.server.virginmedia.net ([80.0.253.65]:40511
	"EHLO know-smtprelay-omc-1.server.virginmedia.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752980AbbC3OU7 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 30 Mar 2015 10:20:59 -0400
Message-ID: <551959D6.8020409@timedicer.co.uk>
Date: Mon, 30 Mar 2015 15:12:38 +0100
From: Dominic Raferd <dominic@timedicer.co.uk>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: duperemove minimal space saving on compressed volume?
Content-Type: text/plain; charset=iso-8859-15; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I am using 3.19.3 kernel, v3.19-rc2 btrfs-progs and v0.09-1 duperemove.

I have a btrfs lzo-compressed /home volume and I ran

duperemove -rdhv /home

It took over a day (no problem for me, it was a quiet time and it's a vm 
on so-so underlying hardware), and it reported lots of matched extents. 
Just the last few lines (file names removed) were:

Dedupe 59 extents with target: (0.0, 208.0M), "/home/..."
...
Dedupe 1 extents with target: (0.0, 224.8M), "/home/..."
...
Dedupe 1 extents with target: (0.0, 225.4M), "/home/..."
...
Dedupe 1 extents with target: (0.0, 1.5G), "/home/..."
Kernel processed data (excludes target files): 43.0G
Comparison of extent info shows a net change in shared extents of: 128.0K

 From `btrfs fi usage` before/after reporting of estimated free space I 
think I gained about 1G space (not 128K). But even this is a minimal 
gain compared with the reported 43G (which relates much more closely IMO 
to the actual shared extents found by duperemove). Why is the actual 
space gain (128K? 1G?) so small compared to the total of shared extents 
(43G maybe)?
