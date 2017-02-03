Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from zaphod.cobb.me.uk ([213.138.97.131]:39775 "EHLO
        zaphod.cobb.me.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751120AbdBCTRH (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 3 Feb 2017 14:17:07 -0500
Subject: Re: btrfs receive leaves new subvolume modifiable during operation
To: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>, linux-btrfs@vger.kernel.org
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
 <836de840-491f-e7e5-0fac-de82ad1c031e@gmail.com>
From: Graham Cobb <g.btrfs@cobb.uk.net>
Message-ID: <3fac134f-608a-1eb5-785f-347f65c98b5f@cobb.uk.net>
Date: Fri, 3 Feb 2017 19:17:01 +0000
MIME-Version: 1.0
In-Reply-To: <836de840-491f-e7e5-0fac-de82ad1c031e@gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 03/02/17 16:01, Austin S. Hemmelgarn wrote:
> Ironically, I ended up having time sooner than I thought.  The message
> doesn't appear to be in any of the archives yet, but the message ID is:
> <20170203134858.75210-1-ahferroin7@gmail.com>

Ah. I didn't notice it until after I had sent my message.

> I actually like how you explained things a bit better though, so if you
> are OK with it I'll update the patch I sent using your description (and
> credit you in the commit message too of course).

You are welcome to use any of my phrasing or approach, of course!


