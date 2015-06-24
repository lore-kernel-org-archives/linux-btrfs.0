Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:24017 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753826AbbFXDjU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 23 Jun 2015 23:39:20 -0400
Message-ID: <558A26A5.4050105@cn.fujitsu.com>
Date: Wed, 24 Jun 2015 11:40:21 +0800
From: Cao jin <caoj.fnst@cn.fujitsu.com>
MIME-Version: 1.0
To: Marc MERLIN <marc@merlins.org>
CC: <linux-btrfs@vger.kernel.org>
Subject: Re: Question about "btrfs send/receive"
References: <5589078B.2090806@cn.fujitsu.com> <20150624032423.GH20517@merlins.org>
In-Reply-To: <20150624032423.GH20517@merlins.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Marc,
     I can`t access /perso/btrfs/2014-03.html on that server. But I 
guess it has similar content as 
https://btrfs.wiki.kernel.org/index.php/Incremental_Backup ?
     If so, I am afraid incremental backup not suitable for a API 
implementation in libguestfs.
     Is the simplest form a usual condition people will use for 
subvolume backup? Is the simplest form make sense in daily life?

在 2015年06月24日 11:24, Marc MERLIN 写道:
> On Tue, Jun 23, 2015 at 03:15:23PM +0800, Cao jin wrote:
>> Hi all,
>>      I am considering implement the btrfs send/receive command in
>> libguestfs(http://libguestfs.org/), and found that incremental send
>> seems pretty complicated. So my questions is:
>> 1. What is the most usually usage of btrfs send/receive?
>> 2. Does it make sense to implement the simplest form?
>>       $ btrfs send -f sent_file subvol
>
> Sure, have a look at this:
> http://marc.merlins.org/perso/btrfs/2014-03.html#Btrfs-Tips_-Doing-Fast-Incremental-Backups-With-Btrfs-Send-and-Receive
>
> Cheers,
> Marc
>

-- 
Yours Sincerely,

Cao Jin
