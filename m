Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from syrinx.knorrie.org ([82.94.188.77]:52334 "EHLO
        syrinx.knorrie.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752591AbdDIXXX (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Sun, 9 Apr 2017 19:23:23 -0400
Subject: Re: btrfs filesystem keeps allocating new chunks for no apparent
 reason
To: Qu Wenruo <quwenruo@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
References: <572D0C8B.8010404@mendix.com>
 <89a684c7-364e-f409-5348-bc0077fd438c@cn.fujitsu.com>
 <5b642448-951e-5b5e-1343-0299a950089c@mendix.com>
 <51778c0f-2720-1c2d-aba2-e22e5f4d3a3a@mendix.com>
Cc: Josef Bacik <jbacik@fb.com>
From: Hans van Kranenburg <hans.van.kranenburg@mendix.com>
Message-ID: <4532f6ee-2a6e-412a-7230-edb76735d55f@mendix.com>
Date: Mon, 10 Apr 2017 01:23:20 +0200
MIME-Version: 1.0
In-Reply-To: <51778c0f-2720-1c2d-aba2-e22e5f4d3a3a@mendix.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 04/08/2017 01:16 PM, Hans van Kranenburg wrote:
> On 04/07/2017 11:25 PM, Hans van Kranenburg wrote:
>> Ok, I'm going to revive a year old mail thread here with interesting new
>> info:
>>
>> [...]
>>
>> Now, another surprise:
>>
>> From the exact moment I did mount -o remount,nossd on this filesystem,
>> the problem vanished.
>>
>> https://syrinx.knorrie.org/~knorrie/btrfs/keep/2017-04-07-ichiban-munin-nossd.png
>>
>> I don't have a new video yet, but I'll set up a cron tonight and post it
>> later.
>>
>> I'm going to send another mail specifically about the nossd/ssd
>> behaviour and other things I found out last week, but that'll probably
>> be tomorrow.
> 
> Well, there it is:
> 
> https://syrinx.knorrie.org/~knorrie/btrfs/keep/2017-04-08-ichiban-walk-nossd.mp4
> 
> Amazing... :) I'll update the file later with extra frames.

Added all new pngs up until now to the video, same link to the mp4.

Looks great! It just keeps reusing the same spots of space all the time.

When looking at this, I can understand that this is an unwanted write
pattern on a low-end ssd that was available for sale in 2008.

But, how does this apply to an SSD you can buy in 2017?

-- 
Hans van Kranenburg
