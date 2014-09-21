Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:59044 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751210AbaIURMM convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 21 Sep 2014 13:12:12 -0400
Received: from c-75-70-18-61.hsd1.co.comcast.net ([75.70.18.61]:52099 helo=[192.168.1.145])
	by slmp-550-94.slc.westdc.net with esmtpsa (TLSv1:AES128-SHA:128)
	(Exim 4.82)
	(envelope-from <lists@colorremedies.com>)
	id 1XVkgF-001K6F-Kp
	for linux-btrfs@vger.kernel.org; Sun, 21 Sep 2014 11:12:12 -0600
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: device delete progress
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <201409211209.11875.russell@coker.com.au>
Date: Sun, 21 Sep 2014 11:12:09 -0600
Message-Id: <A26E7106-F3F9-41A0-B25C-D071FD94CD3D@colorremedies.com>
References: <201409211209.11875.russell@coker.com.au>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Sep 20, 2014, at 8:09 PM, Russell Coker <russell@coker.com.au> wrote:

> We need to have a way to determine the progress of a device delete operation.  
> Also for a balance of a RAID-1 that has more than 2 devices it would be good 
> to know how much space is used on each device.

btrfs replace does do this; but in the use case where the user wants to permanently shrink a filesystem by only removing a device, then it might be nice to have a status for that too considering it might be an 8TB helium drive and take a while.

Chris Murphy