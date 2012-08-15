Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from rcsinet15.oracle.com ([148.87.113.117]:32053 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751887Ab2HODCt (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 14 Aug 2012 23:02:49 -0400
Message-ID: <502B1147.5070901@oracle.com>
Date: Wed, 15 Aug 2012 11:02:31 +0800
From: Liu Bo <bo.li.liu@oracle.com>
MIME-Version: 1.0
To: Marc MERLIN <marc@merlins.org>
CC: linux-btrfs@vger.kernel.org
Subject: Re: linux 3.5.0: BTRFS error in compress_file_range:581 (failed to
 join transaction)
References: <20120814182314.GF12659@merlins.org> <20120815024856.GL12659@merlins.org>
In-Reply-To: <20120815024856.GL12659@merlins.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 08/15/2012 10:48 AM, Marc MERLIN wrote:
> On Tue, Aug 14, 2012 at 11:23:14AM -0700, Marc MERLIN wrote:
>> My laptop oopsed due to a wireless bug
>>
>> When I rebooted, the system came back ok, and seemed to work, but soon went
>> to read only with the error in the subject line.
>>
>> I have hourly snapshots for each of the 5 subvolumes in that btrfs
>> filesystem.
>>
>> How do I recover from this? Revert all the snapshots one hour, find/guess
>> which one caused the problem somehow and revert just that one? (the error
>> message didn't give a subvolume or directory).
>>
>> Also, before I do this, is there debug info I can get off my system?
> 
> I'm likely to have to do this tonight to get back to a working system.
> 
> If someone wants debug info before I lose it potentially, please ask soon ;)
> 
> Marc
> 

What does the 'ret' shows?  Is it -ENOSPC?

thanks,
liubo
