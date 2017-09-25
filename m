Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp97.ord1c.emailsrvr.com ([108.166.43.97]:41685 "EHLO
        smtp97.ord1c.emailsrvr.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S932404AbdIYJ1i (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 25 Sep 2017 05:27:38 -0400
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
 <5f24c41c-bc22-0821-b807-e73869116b84@gmx.com>
From: Marat Khalili <mkh@rqc.ru>
Message-ID: <cc21a341-05f5-4926-5ba8-9ca9af0fd66b@rqc.ru>
Date: Mon, 25 Sep 2017 12:27:36 +0300
MIME-Version: 1.0
In-Reply-To: <5f24c41c-bc22-0821-b807-e73869116b84@gmx.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 25/09/17 11:08, Qu Wenruo wrote:
>> What about redirecting stdout to /dev/null and redirecting stderr to 
>> mail if return value is not 0?
> s/if return value is not 0/if return value is 0/.
>
> The main point is, if btrfs returns 0, then nothing to worry about.
> (Unless there is a bug, even in that case keep an eye on stderr should 
> be enough to catch that)

Redirection to /dev/null will work. However,

1) It will always looks suspicious. grep -v with expected message is at 
least clear about its intent and consequences.

2) Although shorter than grep -v, it will still take space in shell 
scripts and force one to remember btrfs commands one has to add it 
after. This is already inconvenient enough to want a fix.

--

With Best Regards,
Marat Khalili
