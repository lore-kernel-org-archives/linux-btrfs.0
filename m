Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from syrinx.knorrie.org ([82.94.188.77]:54837 "EHLO
	syrinx.knorrie.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751964AbcFIKhM (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 9 Jun 2016 06:37:12 -0400
Subject: Re: btrfs filesystem keeps allocating new chunks for no apparent
 reason
To: Marc Haber <mh+linux-btrfs@zugschlus.de>, linux-btrfs@vger.kernel.org
References: <572D0C8B.8010404@mendix.com>
 <89a684c7-364e-f409-5348-bc0077fd438c@cn.fujitsu.com>
 <5758A5F6.4060400@mendix.com> <20160609085217.GL5171@torres.zugschlus.de>
From: Hans van Kranenburg <hans.van.kranenburg@mendix.com>
Message-ID: <575946D4.2060608@mendix.com>
Date: Thu, 9 Jun 2016 12:37:08 +0200
MIME-Version: 1.0
In-Reply-To: <20160609085217.GL5171@torres.zugschlus.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 06/09/2016 10:52 AM, Marc Haber wrote:
> On Thu, Jun 09, 2016 at 01:10:46AM +0200, Hans van Kranenburg wrote:
>> So, instead of being the cause, apt-get update causing a new chunk to be
>> allocated might as well be the result of existing ones already filled up
>> with too many fragments.
>>
>> The next question is what files these extents belong to. To find out, I need
>> to open up the extent items I get back and follow a backreference to an
>> inode object. Might do that tomorrow, fun.
>
> Does your apt use pdiffs to update the packages lists? If yes, I'd try
> turning it off just for the fun of it and to see whether this changes
> btrfs' allocation behavior. I have never looked at apt's pdiff stuff
> in detail, but I guess that it creates many tiny temporary files.

No, it does not:

Acquire::Pdiffs "false";

-- 
Hans van Kranenburg - System / Network Engineer
Mendix | Driving Digital Innovation | www.mendix.com
