Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp89.ord1c.emailsrvr.com ([108.166.43.89]:45652 "EHLO
        smtp89.ord1c.emailsrvr.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S932107AbdIYPRG (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 25 Sep 2017 11:17:06 -0400
Subject: Re: [PATCH] btrfs-progs: subvolume: outputs message only when
 operation succeeds
To: Qu Wenruo <quwenruo.btrfs@gmx.com>, Hugo Mills <hugo@carfax.org.uk>,
        Nikolay Borisov <nborisov@suse.com>,
        "Misono, Tomohiro" <misono.tomohiro@jp.fujitsu.com>,
        linux-btrfs@vger.kernel.org
References: <cdca7f92-93c0-9906-f2ed-57c3d0a97fae@jp.fujitsu.com>
 <3b6d4951-dd71-989d-3287-12ffe643bfae@suse.com>
 <b1b5a231-ffc3-700b-b59d-e82accf2f2e7@rqc.ru>
 <095397b6-4865-1ea3-ae0d-6725b84c447c@gmx.com>
 <20170925075250.GC25529@carfax.org.uk>
 <7a345608-6c5d-bdc9-9b5f-74a8052ea228@gmx.com>
 <20170925141951.GD25529@carfax.org.uk>
 <d0e2c24a-c6c6-c154-c8ad-d37fdea669d5@gmx.com>
From: Marat Khalili <mkh@rqc.ru>
Message-ID: <345d459f-0d32-0ff9-19d3-86f86f165dfe@rqc.ru>
Date: Mon, 25 Sep 2017 18:17:03 +0300
MIME-Version: 1.0
In-Reply-To: <d0e2c24a-c6c6-c154-c8ad-d37fdea669d5@gmx.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 25/09/17 17:33, Qu Wenruo wrote:
> (Any in this case, anyone in the maillist can help review messages) 
If this is a question, I can help with assigning levels to messages. 
Although I think many levels are only required for complex daemons or 
network tools, while btrfs utils mostly perform atomic operations which 
either succeed or fail. But it's of course hard to be sure without 
seeing all actual messages, probably there's some use for 4 levels.

--

With Best Regards,
Marat Khalili
