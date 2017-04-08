Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from syrinx.knorrie.org ([82.94.188.77]:50612 "EHLO
        syrinx.knorrie.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751523AbdDHLQp (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Sat, 8 Apr 2017 07:16:45 -0400
Subject: Re: btrfs filesystem keeps allocating new chunks for no apparent
 reason
To: Qu Wenruo <quwenruo@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
References: <572D0C8B.8010404@mendix.com>
 <89a684c7-364e-f409-5348-bc0077fd438c@cn.fujitsu.com>
 <5b642448-951e-5b5e-1343-0299a950089c@mendix.com>
Cc: Josef Bacik <jbacik@fb.com>
From: Hans van Kranenburg <hans.van.kranenburg@mendix.com>
Message-ID: <51778c0f-2720-1c2d-aba2-e22e5f4d3a3a@mendix.com>
Date: Sat, 8 Apr 2017 13:16:42 +0200
MIME-Version: 1.0
In-Reply-To: <5b642448-951e-5b5e-1343-0299a950089c@mendix.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 04/07/2017 11:25 PM, Hans van Kranenburg wrote:
> Ok, I'm going to revive a year old mail thread here with interesting new
> info:
> 
> [...]
> 
> Now, another surprise:
> 
> From the exact moment I did mount -o remount,nossd on this filesystem,
> the problem vanished.
> 
> https://syrinx.knorrie.org/~knorrie/btrfs/keep/2017-04-07-ichiban-munin-nossd.png
> 
> I don't have a new video yet, but I'll set up a cron tonight and post it
> later.
> 
> I'm going to send another mail specifically about the nossd/ssd
> behaviour and other things I found out last week, but that'll probably
> be tomorrow.

Well, there it is:

https://syrinx.knorrie.org/~knorrie/btrfs/keep/2017-04-08-ichiban-walk-nossd.mp4

Amazing... :) I'll update the file later with extra frames.

-- 
Hans van Kranenburg
