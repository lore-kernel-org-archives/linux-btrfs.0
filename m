Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from atl4mhob08.myregisteredsite.com ([209.17.115.46]:39826 "EHLO
	atl4mhob08.myregisteredsite.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752443AbaANWNj (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 14 Jan 2014 17:13:39 -0500
Received: from mailpod1.hostingplatform.com ([10.30.71.114])
	by atl4mhob08.myregisteredsite.com (8.14.4/8.14.4) with ESMTP id s0EMDcAa013972
	for <linux-btrfs@vger.kernel.org>; Tue, 14 Jan 2014 17:13:38 -0500
Message-ID: <52D5B6AE.5030508@chinilu.com>
Date: Tue, 14 Jan 2014 14:14:06 -0800
From: George Mitchell <george@chinilu.com>
Reply-To: george@chinilu.com
MIME-Version: 1.0
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: How does btrfs handle bad blocks in raid1?
References: <201401100106.s0A16CNd016476@atl4mhib27.myregisteredsite.com> <52CF4D5D.2010709@chinilu.com> <486C0640-409D-4636-858C-84A679C0AF4E@colorremedies.com> <52D59E28.7010200@chinilu.com> <B24DFFC0-3B9D-41CA-ADC4-B0C4429C294A@colorremedies.com>
In-Reply-To: <B24DFFC0-3B9D-41CA-ADC4-B0C4429C294A@colorremedies.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 01/14/2014 01:14 PM, Chris Murphy wrote:
>
>> And the key to monitoring hard drive health, in my opinion, is SMART and what we are lacking at this point is a SMART capability to provide visual notifications to the user when any hard drive starts to seriously degrade or suddenly fails.
> Gnome does this:
> https://mail.gnome.org/archives/commits-list/2012-November/msg03124.html
>
> The problem is that something around 40% of failures come with absolutely no advance warning by SMART. So yes it's better than nothing but we're still rather likely to not get sufficient warning.
>
>
>
Well, I *think* I found the answer to this one.

http://forum.kde.org/viewtopic.php?f=66&t=99555

And note the response to the poll question.
