Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f47.google.com ([209.85.214.47]:37486 "EHLO
        mail-it0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750863AbdBCQBn (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 3 Feb 2017 11:01:43 -0500
Received: by mail-it0-f47.google.com with SMTP id r185so14957635ita.0
        for <linux-btrfs@vger.kernel.org>; Fri, 03 Feb 2017 08:01:25 -0800 (PST)
Subject: Re: btrfs receive leaves new subvolume modifiable during operation
To: Graham Cobb <g.btrfs@cobb.uk.net>, linux-btrfs@vger.kernel.org
References: <1485905578.6441.20.camel@gmail.com>
 <pan$4ecd$16bc5e8e$14657c4$261368ad@cox.net>
 <4edfd08e-8d7f-d8d7-bdea-0589b46e4d2b@gmail.com>
 <7ead5d42-9c00-b2df-3fbf-5b8f287760f6@cobb.uk.net>
 <pan$16525$cf7fe24b$7c044b9$74b32f27@cox.net>
 <5c503d69-aaed-680f-de30-75a7323bc753@cobb.uk.net>
 <pan$5f1de$80937cf$9c306858$cafb9e40@cox.net>
 <1b69d1a8-c08b-c9f3-c95b-1d7d71c7d642@cobb.uk.net>
 <pan$e2f8a$ba778439$cd53e97c$382283f9@cox.net>
 <092c2028-f132-83b1-5f10-d84d374a8bb3@gmail.com>
 <a85af6d8-fdcd-1039-3c0e-a4486ff0bb0a@cobb.uk.net>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <836de840-491f-e7e5-0fac-de82ad1c031e@gmail.com>
Date: Fri, 3 Feb 2017 11:01:18 -0500
MIME-Version: 1.0
In-Reply-To: <a85af6d8-fdcd-1039-3c0e-a4486ff0bb0a@cobb.uk.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2017-02-03 10:44, Graham Cobb wrote:
> On 03/02/17 12:44, Austin S. Hemmelgarn wrote:
>> I can look at making a patch for this, but it may be next week before I
>> have time (I'm not great at multi-tasking when it comes to software
>> development, and I'm in the middle of helping to fix a bug in Ansible
>> right now).
>
> That would be great, Austin! It is about 15 years since I last submitted
> a patch under kernel development patch rules and things have changed a
> fair bit in that time. So if you are set up to do it that sounds good.
>
> As a starting point, I have created a suggested text (patch attached).
Ironically, I ended up having time sooner than I thought.  The message 
doesn't appear to be in any of the archives yet, but the message ID is:
<20170203134858.75210-1-ahferroin7@gmail.com>

I actually like how you explained things a bit better though, so if you 
are OK with it I'll update the patch I sent using your description (and 
credit you in the commit message too of course).

