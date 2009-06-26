From: Steven Pratt <slpratt@austin.ibm.com>
Subject: Single disk performance
Date: Fri, 26 Jun 2009 09:28:51 -0500
Message-ID: <4A44DB23.5000400@austin.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Upgraded the btrfs tree to 6-17 and all of the stability problems went 
away on the single disk system, so not sure if this was a code problem 
or hardware, but at least stable now.
Performance results updated at:
 http://btrfs.boxacle.net/repository/single-disk/History/History.html

The fixed to the cow path are obvious for random write, although even on 
single disk the CPU overhead is very noticeable as the efficiency graphs 
show.

The good news is that now the only workload that Btrfs is not at or near 
the top in performance for single disk is MailServer.

Steve
