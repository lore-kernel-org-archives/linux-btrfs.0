Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp73.iad3a.emailsrvr.com ([173.203.187.73]:46041 "EHLO
	smtp73.iad3a.emailsrvr.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753718AbbK0DDo convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 26 Nov 2015 22:03:44 -0500
Received: from smtp10.relay.iad3a.emailsrvr.com (localhost.localdomain [127.0.0.1])
	by smtp10.relay.iad3a.emailsrvr.com (SMTP Server) with ESMTP id 436B3280291
	for <linux-btrfs@vger.kernel.org>; Thu, 26 Nov 2015 22:03:43 -0500 (EST)
Received: from smtp10.relay.iad3a.emailsrvr.com (localhost.localdomain [127.0.0.1])
	by smtp10.relay.iad3a.emailsrvr.com (SMTP Server) with ESMTP id 3FD722802C9
	for <linux-btrfs@vger.kernel.org>; Thu, 26 Nov 2015 22:03:43 -0500 (EST)
Received: by smtp10.relay.iad3a.emailsrvr.com (Authenticated sender: vincent-AT-up4.tv) with ESMTPSA id 07E52280291
	for <linux-btrfs@vger.kernel.org>; Thu, 26 Nov 2015 22:03:42 -0500 (EST)
Content-Type: text/plain; charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 8.2 \(2104\))
Subject: Re: btrfs check help
From: Vincent Olivier <vincent@up4.com>
In-Reply-To: <56566416.5000405@cn.fujitsu.com>
Date: Thu, 26 Nov 2015 22:03:42 -0500
Message-Id: <4EF3E931-9089-40FB-8E8E-1928539D39D4@up4.com>
References: <AF79907D-A36B-4806-B31A-3E327F2E5642@up4.com> <5654C86C.9080800@gmail.com> <20151124203210.GR24333@carfax.org.uk> <B369C8E5-3E5E-4008-BD99-C174D7ABFB36@up4.com> <56566416.5000405@cn.fujitsu.com>
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


> On Nov 25, 2015, at 8:44 PM, Qu Wenruo <quwenruo@cn.fujitsu.com> wrote:
> 
> 
> 
> Vincent Olivier wrote on 2015/11/25 11:51 -0500:
>> I should probably point out that there is 64GB of RAM on this machine and it’s a dual Xeon processor (LGA2011-3) system. Also, there is only Btrfs served via Samba and the kernel panic was caused Btrfs (as per what I remember from the log on the screen just before I rebooted) and happened in the middle of the night when zero (0) client was connected.
>> 
>> You will find below the full “btrfs check” log for each device in the order it is listed by “btrfs fi show”.
> 
> There is really no need to do such thing, as btrfs is able to manage multiple device, calling btrfsck on any of them is enough as long as it's not hugely damaged.
> 
>> 
>> Ca I get a strong confirmation that I should run with the “—repair” option on each device? Thanks.
> 
> YES.
> 
> Inode nbytes fix is *VERY* safe as long as it's the only error.
> 
> Although it's not that convincing since the inode nbytes fix code is written by myself and authors always tend to believe their codes are good....
> But at least, some other users with more complicated problem(with inode nbytes error) fixed it.
> 
> The last decision is still on you anyway.

I will do it on the first device from the “fi show” output and report.

Thanks,

Vincent

