Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aye.maple.relay.mailchannels.net ([23.83.214.6]:53084 "EHLO
	aye.maple.relay.mailchannels.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751546AbcATIkB (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 20 Jan 2016 03:40:01 -0500
Subject: Re: Why is dedup inline, not delayed (as opposed to offline)? Explain
 like I'm five pls.
To: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>,
        Duncan <1i5t5.duncan@cox.net>, linux-btrfs@vger.kernel.org
References: <loom.20160116T132316-196@post.gmane.org>
 <569C41B1.1090206@cn.fujitsu.com>
 <pan$9ea8b$cdf4a5be$a6b3ced0$e73fd4ce@cox.net>
 <569C58FB.70407@cn.fujitsu.com> <pan$9dd9b$58cdc4a$94401f0f$f97ce29e@cox.net>
 <569CDF0D.9030609@gmail.com> <pan$9821b$e84a8fc3$23a877ef$2b0858e0@cox.net>
 <pan$85c04$d9fd4f4d$1304efda$85c18be@cox.net> <569E2BFC.8080107@gmail.com>
From: Brendan Hide <brendan@swiftspirit.co.za>
Message-ID: <569F4620.30301@swiftspirit.co.za>
Date: Wed, 20 Jan 2016 10:32:32 +0200
MIME-Version: 1.0
In-Reply-To: <569E2BFC.8080107@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 1/19/2016 2:28 PM, Austin S. Hemmelgarn wrote:
> That aside, it's probably worth noting that updatedb used by 
> {,m,s}locate only indexes metadata, and it does so a lot more 
> efficiently than most of the desktop search-engine indexers out there, 
> so it's not quite as bad as baloo or tracker or some of the other 
> options.  Unlike those, updatedb pretty much just calls stat on 
> everything it's told to index, which takes time, but is not 
> particularly bad for your cache if you're just running it on your home 
> directory.
Related Project Idea:
Snapshot-aware updatedb/locate -> 
https://btrfs.wiki.kernel.org/index.php/Project_ideas#Snapshot-aware_updatedb.2Flocate

-- 
__________
Brendan Hide
http://swiftspirit.co.za/
http://www.webafrica.co.za/?AFF1E97

