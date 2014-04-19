Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:50905 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751270AbaDSWBO (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 19 Apr 2014 18:01:14 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1WbdJw-00031m-LA
	for linux-btrfs@vger.kernel.org; Sun, 20 Apr 2014 00:01:12 +0200
Received: from md5i.com ([75.151.244.229])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 20 Apr 2014 00:01:12 +0200
Received: from mwd by md5i.com with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 20 Apr 2014 00:01:12 +0200
To: linux-btrfs@vger.kernel.org
From: Michael Welsh Duggan <mwd@md5i.com>
Subject: snapshot send with parent question
Date: Sat, 19 Apr 2014 18:00:57 -0400
Message-ID: <87bnvxasiu.fsf@maru2.md5i.com>
Mime-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Assume the following scenario:
There exists a read-only snapshot called a.
A read-write snapshot called b is created from a, and is then modified.
A read-only snapshot of b is created, called c.
A btrfs send is done for c, with a marked as its parent.

Will the send data only contain the differences between a and c?  My
experiments seem to indicate no, but I have no confidence that I am not
doing something else correctly.

Also, when a btrfs receive gets a stream containing the differences
between a (parent) and c, does it only look at the relative pathname
differences between a and c in order to determine the matching parent on
the receiving side?

-- 
Michael Welsh Duggan
(md5i@md5i.com)

