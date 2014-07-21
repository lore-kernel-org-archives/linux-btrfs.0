Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from fw6a-t3e-f34.wadns.net ([41.185.62.52]:25376 "EHLO
	fw6a.wadns.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754350AbaGULB4 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 21 Jul 2014 07:01:56 -0400
Message-ID: <53CCF307.3060704@swiftspirit.co.za>
Date: Mon, 21 Jul 2014 13:01:27 +0200
From: Brendan Hide <brendan@swiftspirit.co.za>
MIME-Version: 1.0
To: Duncan <1i5t5.duncan@cox.net>,
        linux-btrfs Mailing list <linux-btrfs@vger.kernel.org>
CC: Marc Joliet <marcec@gmx.de>
Subject: Re: ENOSPC errors during balance
References: <20140719172605.445e8445@marcec>	<39E33553-3073-483E-9A2A-088212B40D0B@colorremedies.com>	<pan$c685d$4bb40507$f2be4604$15619074@cox.net>	<20140720122233.4ef06751@marcec> <pan$5b352$6e6542cd$e89d31d4$5e60498b@cox.net>
In-Reply-To: <pan$5b352$6e6542cd$e89d31d4$5e60498b@cox.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 20/07/14 14:59, Duncan wrote:
> Marc Joliet posted on Sun, 20 Jul 2014 12:22:33 +0200 as excerpted:
>
>> On the other hand, the wiki [0] says that defragmentation (and
>> balancing) is optional, and the only reason stated for doing either is
>> because they "will have impact on performance".
> Yes.  That's what threw off the other guy as well.  He decided to skip it
> for the same reason.
>
> If I had a wiki account I'd change it, but for whatever reason I tend to
> be far more comfortable writing list replies, sometimes repeatedly, than
> writing anything on the web, which I tend to treat as read-only.  So I've
> never gotten a wiki account and thus haven't changed it, and apparently
> the other guy with the problem and anyone else that knows hasn't changed
> it either, so the conversion page still continues to underemphasize the
> importance of completing the conversion steps, including the defrag, in
> proper order.
>
I've inserted information specific to this in the wiki. Others with wiki 
accounts, feel free to review:
https://btrfs.wiki.kernel.org/index.php/Conversion_from_Ext3#Before_first_use

-- 
__________
Brendan Hide
http://swiftspirit.co.za/
http://www.webafrica.co.za/?AFF1E97

