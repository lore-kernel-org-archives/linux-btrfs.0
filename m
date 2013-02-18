Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from static-206-126-220-193.bertramwireless.com ([206.126.220.193]:48819
	"EHLO static-206-126-220-193.bertramwireless.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754975Ab3BRXab convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 18 Feb 2013 18:30:31 -0500
Received: from localhost (localhost.localdomain [127.0.0.1])
	by static-206-126-220-193.bertramwireless.com (Postfix) with ESMTP id 5D22B5401B9
	for <linux-btrfs@vger.kernel.org>; Mon, 18 Feb 2013 17:21:00 -0600 (CST)
Received: from static-206-126-220-193.bertramwireless.com ([127.0.0.1])
	by localhost (static-206-126-220-193.bertramwireless.com [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id AnbyfBv2ntEq for <linux-btrfs@vger.kernel.org>;
	Mon, 18 Feb 2013 17:20:58 -0600 (CST)
Received: from [192.168.168.57] (unknown [192.168.168.57])
	by static-206-126-220-193.bertramwireless.com (Postfix) with ESMTPSA id 57FD95401B0
	for <linux-btrfs@vger.kernel.org>; Mon, 18 Feb 2013 17:20:58 -0600 (CST)
From: Tony Plack <tony@plack.net>
Content-Type: text/plain; charset=us-ascii
Subject: RAID5/6 Implementation - Understanding first
Date: Mon, 18 Feb 2013 17:20:58 -0600
Message-Id: <FB38335C-3CF7-4D82-B7E2-79264D54F0C8@plack.net>
To: linux-btrfs@vger.kernel.org
Mime-Version: 1.0 (Apple Message framework v1283)
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Chris and team, hats off on the RAID5/6 being at least experimental.  I have been following your work for a year now, and waiting for these days.

I am trying to get my head rapped around the architecture for BTRFS before I jump in and start recommending code changes to the branch.

What I am trying to understand is the comments in the GIT commit which state:

	Read/modify/write is done after the higher levels of the filesystem have
	prepared a given bio.  This means the higher layers are not responsible
	for building full stripes, and they don't need to query for the topology
	of the extents that may get allocated during delayed allocation runs.
	It also means different files can easily share the same stripe.

As I understand it, what we are doing is trying to hide the underlying extents architecture to gain some advantages in the higher level code.  I have been digging in the code, and believe I know the answer to this question.  So by "higher levels" does this mean that RMW, snapshots, checksums and duplicate detection are all unaware of RAID architecture?

If so, I might have some points to consider in this space.  If not, I will need to dig deeper in the code to understand how some of my concerns can be realized and how I missed the answer to my question.

Thank you for this awesome work you all are doing and thank you for the time to answer.

Anthony Plack