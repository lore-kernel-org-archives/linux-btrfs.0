Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from atl4mhob09.myregisteredsite.com ([209.17.115.47]:48859 "EHLO
	atl4mhob09.myregisteredsite.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752526AbaAIXXs (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 9 Jan 2014 18:23:48 -0500
Received: from mailpod1.hostingplatform.com ([10.30.71.116])
	by atl4mhob09.myregisteredsite.com (8.14.4/8.14.4) with ESMTP id s09NNkCZ005262
	for <linux-btrfs@vger.kernel.org>; Thu, 9 Jan 2014 18:23:46 -0500
Message-ID: <52CF2F9D.4080504@chinilu.com>
Date: Thu, 09 Jan 2014 15:24:13 -0800
From: George Mitchell <george@chinilu.com>
Reply-To: george@chinilu.com
MIME-Version: 1.0
To: Chris Murphy <lists@colorremedies.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: How does btrfs handle bad blocks in raid1?
References: <CAFvQSYRWBqMdAm-9yWhv4SS1YW-LB71iOZvgkNPc9BG3Wh7erw@mail.gmail.com> <20140109104247.GH15634@carfax.org.uk>,<3A9CDBC9-ACFF-43E3-AFB9-33A6FFE7FB35@colorremedies.com> <BAY172-W37E3465B365B9EA9C2AA4FB0B00@phx.gbl> <75CB34F7-0BC3-47B7-8817-94F74BC5FD18@colorremedies.com>
In-Reply-To: <75CB34F7-0BC3-47B7-8817-94F74BC5FD18@colorremedies.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I really suspect a lot of bad block issues can be avoided by monitoring 
SMART data.  SMART is working very well for me with btrfs formatted 
drives.  SMART will detect when sectors silently fail and as those 
failures accumulate, SMART will warn in an obvious way that the drive in 
question is at end of life.  So I think the whole bad block issue should 
ideally be handled at a lower level than filesystem with modern hard drives.
