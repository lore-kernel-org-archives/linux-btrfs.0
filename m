Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp81.iad3a.emailsrvr.com ([173.203.187.81]:46325 "EHLO
        smtp81.iad3a.emailsrvr.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S933044AbdIYHmH (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 25 Sep 2017 03:42:07 -0400
Subject: Re: [PATCH] btrfs-progs: subvolume: outputs message only when
 operation succeeds
To: Nikolay Borisov <nborisov@suse.com>,
        "Misono, Tomohiro" <misono.tomohiro@jp.fujitsu.com>,
        linux-btrfs@vger.kernel.org
References: <cdca7f92-93c0-9906-f2ed-57c3d0a97fae@jp.fujitsu.com>
 <3b6d4951-dd71-989d-3287-12ffe643bfae@suse.com>
From: Marat Khalili <mkh@rqc.ru>
Message-ID: <b1b5a231-ffc3-700b-b59d-e82accf2f2e7@rqc.ru>
Date: Mon, 25 Sep 2017 10:42:06 +0300
MIME-Version: 1.0
In-Reply-To: <3b6d4951-dd71-989d-3287-12ffe643bfae@suse.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 25/09/17 10:30, Nikolay Borisov wrote:
> On 19.09.2017 10:41, Misono, Tomohiro wrote:
>> "btrfs subvolume create/delete" outputs the message of "Create/Delete
>> subvolume ..." even when an operation fails.
>> Since it is confusing, let's outputs the message only when an operation succeeds.
> Please change the verb to past tense, more strongly signaling success -
> i.e. "Created subvolume"
What about recalling some UNIX standards and returning to NOT outputting 
any message when operation succeeds? My scripts are full of grep -v 
calls after each btrfs command, and this sucks (and I don't think I'm 
alone in this situation). If you change the message a lot of scripts 
will have to be changed, at least make it worth it.

  --

With Best Regards,
Marat Khaliili

