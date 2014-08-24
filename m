Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from csamuel.org ([74.50.50.137]:51151 "EHLO csamuel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752443AbaHXMt4 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 24 Aug 2014 08:49:56 -0400
Received: from localhost (localhost [127.0.0.1])
	by csamuel.org (Postfix) with ESMTP id 898E7405C7
	for <linux-btrfs@vger.kernel.org>; Sun, 24 Aug 2014 22:49:55 +1000 (EST)
Received: from csamuel.org ([127.0.0.1])
 by localhost (csamuel.org [127.0.0.1]) (amavisd-maia, port 10024) with LMTP
 id 01810-05 for <linux-btrfs@vger.kernel.org>;
 Sun, 24 Aug 2014 22:49:55 +1000 (EST)
Received: from quad.localnet (2001-44b8-41dd-d500-5c25-1b76-13ce-24c4.static.ipv6.internode.on.net [IPv6:2001:44b8:41dd:d500:5c25:1b76:13ce:24c4])
	by csamuel.org (Postfix) with ESMTPSA id 17FF5405C4
	for <linux-btrfs@vger.kernel.org>; Sun, 24 Aug 2014 22:49:55 +1000 (EST)
From: Chris Samuel <chris@csamuel.org>
To: linux-btrfs@vger.kernel.org
Subject: Re: superblock checksum mismatch after crash, cannot mount
Date: Sun, 24 Aug 2014 22:49:51 +1000
Message-ID: <2850101.SbkCu8D9cB@quad>
In-Reply-To: <20140824110853.GB22693@apia.perrit.net>
References: <53F7BD8E.10308@floga.de> <pan$101a9$d6ff1fb7$ae6d9b70$9c335a80@cox.net> <20140824110853.GB22693@apia.perrit.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, 24 Aug 2014 01:08:53 PM Leen Besselink wrote:

> tip for basically any Linux filesystem, especially on Flash-based storage
> and also btrfs: - use noatime (if you aren't doing that already, don't know
> if that is the default in btrfs)

Since 2.6.30 (5 years old now) the kernel has defaulted to mounting filesystems
with relatime not atime so it's not as bad as it used to be.  This is from the mount
manual page.

       relatime
              Update inode access times relative to modify or change time.  Access time is  only
              updated  if the previous access time was earlier than the current modify or change
              time. (Similar to noatime, but doesn't break mutt or other applications that  need
              to know if a file has been read since the last time it was modified.)

              Since  Linux  2.6.30,  the kernel defaults to the behavior provided by this option
              (unless noatime was  specified), and the strictatime option is required to  obtain
              traditional  semantics.  In  addition,  since Linux 2.6.30, the file's last access
              time is always  updated  if  it  is more than 1 day old.

All the best,
Chris
-- 
 Chris Samuel  :  http://www.csamuel.org/  :  Melbourne, VIC


