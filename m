Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from resqmta-po-06v.sys.comcast.net ([96.114.154.165]:37573 "EHLO
        resqmta-po-06v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751970AbcIQPI2 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 17 Sep 2016 11:08:28 -0400
Date: Sat, 17 Sep 2016 10:08:25 -0500
From: Tim Walberg <twalberg@comcast.net>
To: Chris Murphy <lists@colorremedies.com>
Cc: Stefan Malte Schumacher <stefan.m.schumacher@gmail.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: Size of scrubbed Data
Message-ID: <20160917150825.GG2290@comcast.net>
Reply-To: Tim Walberg <twalberg@comcast.net>
References: <CAA3ktqmQ+kGddhuw6gC9Hoct+eayxjZFrDjigffCgmDa09=PBA@mail.gmail.com>
 <CAJCQCtR6bcBjK+Npd1+8KOYFOp5GWUBQ8hxvjwNU7vEaLHH9Hg@mail.gmail.com>
 <20160917143404.GF2290@comcast.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20160917143404.GF2290@comcast.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 09/17/2016 09:34 -0500, Walberg, Tim wrote:
>>	On 09/15/2016 15:18 -0600, Chris Murphy wrote:
>>	>>	> System, single: total=4.00MiB, used=0.00B
>>	>>	> Metadata, RAID1: total=10.00GiB, used=8.14GiB
>>	>>	> GlobalReserve, single: total=512.00MiB, used=0.00B
>>	>>	
>>	>>	btrfs balance start -mconvert=raid1,soft <mp>
>>	
>>	


Gaaa... I meant "since the single profile data is system, ..."

>>	Since the single profile data is single, that should probably be
>>	"-s" instead of "-m"... I.e.
>>	
>>		btrfs balance start -sconvert=raid1,soft <mp>
>>	
>>	It may also need "-f", since btrfs balance is a bit more paranoid
>>	about reprofiling system data.
>>	
>>	
>>	
>>	-- 
>>	twalberg@gmail.com
>>	--
>>	To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>>	the body of a message to majordomo@vger.kernel.org
>>	More majordomo info at  http://vger.kernel.org/majordomo-info.html
End of included message



-- 
twalberg@gmail.com
