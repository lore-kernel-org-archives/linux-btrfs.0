Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([217.72.192.75]:63881 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754570AbcHYWdy (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 25 Aug 2016 18:33:54 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Date: Fri, 26 Aug 2016 00:32:11 +0200
From: Gert Menke <gert@menke.ac>
To: Justin Kilpatrick <jkilpatr@redhat.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Switch raid mode without rebalance?
In-Reply-To: <CANhjow-uihWAQ-MREsT9oAHWoFSHgqi=bXJwV8FJOStyMpC6sw@mail.gmail.com>
References: <efe09b37f04cbc7754f6c6d84c9070f0@durkon.lan>
 <CANhjow-uihWAQ-MREsT9oAHWoFSHgqi=bXJwV8FJOStyMpC6sw@mail.gmail.com>
Message-ID: <0981faee57e9de5b29a7150dc89c4092@durkon.lan>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

On 2016-08-25 20:26, Justin Kilpatrick wrote:

> I'm not sure why you want to avoid a balance,
I didn't check, but I imagined it would slow down my rsync 
significantly.

> Once you start this command all the new data should follow the new 
> rules.
Ah, now that's interesting.
When the balance is running, df shows 4TB free space; when I cancel the 
balance, the free space goes back to a few 100GB.

But if the balancing only happens when the disk would otherwise be idle, 
and the mere fact that there is a balance process running will cause the 
new data to be written in single mode, I'm all set. I would not even 
have to wait for the balance to finish after the rsync is done; I could 
just cancel it and unmount the disks. A bit hacky, but in this case 
totally acceptable.

Thanks!
Gert
