Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp65.iad3a.emailsrvr.com ([173.203.187.65]:39490 "EHLO
        smtp65.iad3a.emailsrvr.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750744AbdLGHcU (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 7 Dec 2017 02:32:20 -0500
Subject: Re: [RFC] Improve subvolume usability for a normal user
To: Qu Wenruo <quwenruo.btrfs@gmx.com>
References: <5fc9b66b-0bcd-c2a9-7e8e-b4d4ff828200@jp.fujitsu.com>
 <3934c7d3-b601-bbba-5d16-5c3ef9bb527a@gmx.com>
 <e5bf11ce-fef2-6786-752d-4711751d284d@gmail.com>
 <43b6e90c-6461-d722-fb8c-8ad5069841fd@jp.fujitsu.com>
 <e1a297d8-28fb-980e-fd62-c261186b3a6a@gmail.com>
 <9aa28872-5a44-5a81-d954-656b2f956033@gmx.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
From: Marat Khalili <mkh@rqc.ru>
Message-ID: <47becabf-e362-c552-1b19-44d30e5c4e62@rqc.ru>
Date: Thu, 7 Dec 2017 10:32:21 +0300
MIME-Version: 1.0
In-Reply-To: <9aa28872-5a44-5a81-d954-656b2f956033@gmx.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 07/12/17 08:27, Qu Wenruo wrote:
> When doing snapshot, btrfs only needs to increase reference of 2nd
> highest level tree blocks of original snapshot, other than "walking the
> tree".
> (If tree root level is 2, then level 2 node is copied, while all
> reference of level 1 tree blocks get increased)

Out of curiosity, how does it interacts with nocow files? Does every 
write to these files involves backref walk?

--

With Best Regards,
Marat Khalili
