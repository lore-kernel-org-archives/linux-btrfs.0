Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:37297 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751190AbaCFRIA (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 6 Mar 2014 12:08:00 -0500
Received: from c-50-183-15-223.hsd1.co.comcast.net ([50.183.15.223]:58957 helo=[192.168.1.145])
	by slmp-550-94.slc.westdc.net with esmtpsa (TLSv1:AES128-SHA:128)
	(Exim 4.82)
	(envelope-from <lists@colorremedies.com>)
	id 1WLblx-001H5w-7s
	for linux-btrfs@vger.kernel.org; Thu, 06 Mar 2014 10:07:53 -0700
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: ENOSPC errors during raid1 rebalance
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <loom.20140305T231334-952@post.gmane.org>
Date: Thu, 6 Mar 2014 10:07:52 -0700
Message-Id: <997DFF14-447E-4037-9D7E-60E0C2B68650@colorremedies.com>
References: <DF16C10AFF7F394A8C8A09C9405478890BCBE534@EXHOST.stardatecomputer.com>,<20140303183911.GL13899@carfax.org.uk> <DF16C10AFF7F394A8C8A09C9405478890BCC2C99@EXHOST.stardatecomputer.com> <87D857EF-FB03-468E-A0FD-4F5898B9581B@colorremedies.com> <loom.20140305T231334-952@post.gmane.org>
To: Btrfs <linux-btrfs@vger.kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Mar 5, 2014, at 3:13 PM, Michael Russo <mike@papersolve.com> wrote:

> Chris Murphy <lists <at> colorremedies.com> writes:
> 
>> Did you do a defrag and balance after ext4>btrfs conversion, 
>> but before data/metadata profile conversion?
> 
> No I didn't, as I thought it was only optional and didn't realize 
> it might later affect my ability to change profiles. 


It's possible it's more necessary in certain situations than others.


Chris Murphy

