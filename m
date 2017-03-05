Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.19]:52386 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752398AbdCEWuf (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 5 Mar 2017 17:50:35 -0500
Subject: Re: BTRFS critical: corrupt leaf, slot offset bad; then read-only
To: Hans van Kranenburg <hans.van.kranenburg@mendix.com>,
        linux-btrfs@vger.kernel.org
References: <7d3cccae-4761-4799-9ceb-2735519bee8f@gmx.net>
 <0d721199-9407-ff6b-7a31-4dc5dae08e7b@gmx.net>
 <1774ecd3-a28c-908a-ec3b-bc98db36f34e@mendix.com>
 <f805f57f-eecb-03da-e480-5aed4474cdf5@gmx.net>
 <c08d6121-6cb7-ad9a-5d71-cd93d2f49196@mendix.com>
From: Lukas Tribus <lukyt@gmx.net>
Message-ID: <03805d15-11d4-090b-f81a-c7368eddd752@gmx.net>
Date: Sun, 5 Mar 2017 23:50:29 +0100
MIME-Version: 1.0
In-Reply-To: <c08d6121-6cb7-ad9a-5d71-cd93d2f49196@mendix.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello Hans,


Am 24.02.2017 um 01:26 schrieb Hans van Kranenburg:
>
>> Once that is done, I would like to go over the "btrfs recovery" thread
>> and see if it can
>> be applied for my case as well. I will certainly need your help when
>> that time comes...
> We can take a stab at it.
>

I upgraded btrfs-tools to 4.8.1 as 4.4 didn't have btrfs 
inspect-internal dump-tree.
But I cannot find anything about 5242107641856 in the dump-tree output.

What does that mean?




Thanks,
Lukas

