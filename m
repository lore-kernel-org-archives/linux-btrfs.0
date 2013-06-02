Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from atl4mhob08.myregisteredsite.com ([209.17.115.46]:33681 "EHLO
	atl4mhob08.myregisteredsite.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751930Ab3FBOks (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 2 Jun 2013 10:40:48 -0400
Received: from mailpod1.hostingplatform.com ([10.30.71.116])
	by atl4mhob08.myregisteredsite.com (8.14.4/8.14.4) with ESMTP id r52EekXC004951
	for <linux-btrfs@vger.kernel.org>; Sun, 2 Jun 2013 10:40:46 -0400
Message-ID: <51AB5974.3080803@chinilu.com>
Date: Sun, 02 Jun 2013 07:40:52 -0700
From: George Mitchell <george@chinilu.com>
Reply-To: george@chinilu.com
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: Is there a way to flag specific directories "nodatacow"?
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I am seeing massive journal corruptions that seem to be unique to btrfs 
and I am suspecting that cow might be causing them.  My bandaid fix for 
this will be to mark the /var filesystem "nodatacow" at boot.  But I am 
wondering if their is any way to flag a particular directory as 
"nodatacow" outside of the mount process.  I would like to be able to 
mark /var/log/journal as "nodatacow" for example, without having to 
declare it a subvolume and mount it separately.
