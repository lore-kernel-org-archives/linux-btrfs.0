Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from fw5a-t3e-f1b.wadns.net ([41.185.62.27]:28146 "EHLO
	fw5a.wadns.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751155AbaHMM0Z (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 13 Aug 2014 08:26:25 -0400
Message-ID: <53EB5962.2050908@swiftspirit.co.za>
Date: Wed, 13 Aug 2014 14:26:10 +0200
From: Brendan Hide <brendan@swiftspirit.co.za>
MIME-Version: 1.0
To: David Pottage <david@chrestomanci.org>
CC: Austin S Hemmelgarn <ahferroin7@gmail.com>, Vimal A R <arvimal@yahoo.in>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: Ideas for a feature implementation
References: <1407698476.20187.YahooMailNeo@web192906.mail.sg3.yahoo.com> <53E83035.8010603@gmail.com> <53EA3852.2000607@chrestomanci.org>
In-Reply-To: <53EA3852.2000607@chrestomanci.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2014/08/12 17:52, David Pottage wrote:
>
> [snip] ... if it does not then the file-system has broken the contract 
> to secure delete a file when you asked it to.
This is a technicality - and it has not necessarily "broken the contract".

I think the correct thing to do would be to securely delete the metadata 
referring to that file. That would satisfy the concept that there is no 
evidence that the file ever existed in that location. The fact that it 
actually does still legitimately exist elsewhere is not a caveat - it is 
simply acting within standard behaviour.

-- 
__________
Brendan Hide
http://swiftspirit.co.za/
http://www.webafrica.co.za/?AFF1E97

