Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx.ewheeler.net ([66.155.3.69]:40995 "EHLO mail.ewheeler.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751388AbcGOXMy (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 15 Jul 2016 19:12:54 -0400
Received: from localhost (localhost [127.0.0.1])
	by mail.ewheeler.net (Postfix) with ESMTP id E34BBA0C3F
	for <linux-btrfs@vger.kernel.org>; Fri, 15 Jul 2016 16:12:53 -0700 (PDT)
Received: from mail.ewheeler.net ([127.0.0.1])
	by localhost (mail.ewheeler.net [127.0.0.1]) (amavisd-new, port 10024)
	with LMTP id gqLPWxo9yPj7 for <linux-btrfs@vger.kernel.org>;
	Fri, 15 Jul 2016 16:12:53 -0700 (PDT)
Received: from 23-95-35-21-host.colocrossing.com (unknown [23.95.35.21])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mail.ewheeler.net (Postfix) with ESMTPSA id 81677A0C3E
	for <linux-btrfs@vger.kernel.org>; Fri, 15 Jul 2016 16:12:53 -0700 (PDT)
Date: Fri, 15 Jul 2016 16:12:51 -0700 (PDT)
From: Eric Wheeler <btrfs@lists.ewheeler.net>
To: linux-btrfs@vger.kernel.org
Subject: Btrfs uuid snapshots: orphaned parent_uuid after deleting intermediate
 subvol
Message-ID: <alpine.LRH.2.11.1607151611410.16154@mail.ewheeler.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello all,

If I create three subvolumes like so:

# btrfs subvolume create a
# btrfs subvolume snapshot a b
# btrfs subvolume snapshot b c

I get a parent-child relationship which can be determined like so:

# btrfs subvolume list -uq /home/ |grep [abc]$
parent_uuid - uuid 0e5f473a-d9e5-144a-8f49-1899af7320ad path a
parent_uuid 0e5f473a-d9e5-144a-8f49-1899af7320ad uuid cb4768eb-98e3-5e4c-935d-14f1b97b0de2 path b
parent_uuid cb4768eb-98e3-5e4c-935d-14f1b97b0de2 uuid 5ee8de35-2bab-d642-b5c2-f619e46f65c2 path c

Now if I delete 'b', the parent_uuid of 'c' doesn't change to point at 'a':

# btrfs subvolume delete b
# btrfs subvolume list -uq /home/ |grep [abc]$
parent_uuid - uuid 0e5f473a-d9e5-144a-8f49-1899af7320ad path a
parent_uuid cb4768eb-98e3-5e4c-935d-14f1b97b0de2 uuid 5ee8de35-2bab-d642-b5c2-f619e46f65c2 path c

Notice that 'c' still points at b's UUID, but 'b' is missing and the 
parent_uuid for 'c' wasn't set to '-' as if it were a root node (like 'a').

Is this an inconsistency?  Child parent_uuid's it be updated on delete?

It would be nice to know that 'c' is actually a descendent of 'a', even 
after having deleted 'b'.  Is a way to look that up somehow?


This is running 4.1.15, so its a bit behind.  If this is fixed in a later 
version then please let me know that too.  Thanks!


--
Eric Wheeler
