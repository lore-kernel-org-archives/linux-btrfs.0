Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from atl4mhob15.myregisteredsite.com ([209.17.115.53]:34147 "EHLO
	atl4mhob15.myregisteredsite.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753838Ab3EJODe (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 10 May 2013 10:03:34 -0400
Received: from mailpod1.hostingplatform.com ([10.30.71.116])
	by atl4mhob15.myregisteredsite.com (8.14.4/8.14.4) with ESMTP id r4AE3Xbv010448
	for <linux-btrfs@vger.kernel.org>; Fri, 10 May 2013 10:03:33 -0400
Message-ID: <518CFE3A.3080900@chinilu.com>
Date: Fri, 10 May 2013 07:03:38 -0700
From: George Mitchell <george@chinilu.com>
Reply-To: george@chinilu.com
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: Virtual Device Support
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

One the things that is frustrating me the most at this point from a user 
perspective regarding btrfs is the current lack of virtual devices to 
describe volumes and subvolumes.  The current method of simply using a 
random member device or a LABEL or a UUID is just not working well for 
me.  Having a well thought out virtual device infrastructure would 
greatly simplify use and also relieve problems with util-linux tools.  I 
REALLY DO understand that most if not all btrfs devs at this point are 
working overtime on things much more serious than this issue and I 
REALLY DO have the patience to wait on this one.  But I also REALLY DO 
hope there is some plan for this in the future.  Certainly a lot of 
design for it should already exist within software RAID md code and LVM 
code.
