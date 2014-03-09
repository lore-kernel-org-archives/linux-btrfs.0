Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from csamuel.org ([74.50.50.137]:48575 "EHLO csamuel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752395AbaCIENq (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 8 Mar 2014 23:13:46 -0500
Received: from localhost (localhost [127.0.0.1])
	by csamuel.org (Postfix) with ESMTP id E2588417CF
	for <linux-btrfs@vger.kernel.org>; Sun,  9 Mar 2014 15:13:45 +1100 (EST)
Received: from csamuel.org ([127.0.0.1])
 by localhost (csamuel.org [127.0.0.1]) (amavisd-maia, port 10024) with LMTP
 id 27696-04 for <linux-btrfs@vger.kernel.org>;
 Sun,  9 Mar 2014 15:13:45 +1100 (EST)
Received: from quad.localnet (ppp59-167-127-196.static.internode.on.net [59.167.127.196])
	by csamuel.org (Postfix) with ESMTPSA id 8E11A417CD
	for <linux-btrfs@vger.kernel.org>; Sun,  9 Mar 2014 15:13:45 +1100 (EST)
From: Chris Samuel <chris@csamuel.org>
To: linux-btrfs@vger.kernel.org
Subject: Re: Understanding btrfs and backups
Date: Sun, 09 Mar 2014 15:13:42 +1100
Message-ID: <1959641.msLoxygPan@quad>
In-Reply-To: <20140307151416.GA29687@panda>
References: <loom.20140306T191655-366@post.gmane.org> <loom.20140307T144540-512@post.gmane.org> <20140307151416.GA29687@panda>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, 7 Mar 2014 04:14:16 PM Sander wrote:

> But if the filesystem or underlaying disk goes up in flames, the
> snapshots are toast as well. So you need additional backups,
> preferably not on the same hardware, for real protection against
> data loss.

..and don't forget to think about off-site backups too.

http://www.flickr.com/photos/94482242@N00/7746409996/

cheers,
Chris
-- 
 Chris Samuel  :  http://www.csamuel.org/  :  Melbourne, VIC


