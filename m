Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.22]:51216 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751974AbdGLOLb (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 12 Jul 2017 10:11:31 -0400
Subject: Re: [PATCH] btrfs: qgroups: Fix BUG_ON condition
To: dsterba@suse.cz, Nikolay Borisov <nborisov@suse.com>,
        linux-btrfs@vger.kernel.org, rgoldwyn@suse.de
References: <1499841739-18549-1-git-send-email-nborisov@suse.com>
 <9f2efc65-1972-e200-72ff-2ccf29da06d1@gmx.com>
 <20170712134242.GA2866@suse.cz>
 <04a1f309-28ac-33e9-cf8f-fb0b991c0b06@suse.com>
 <20170712135144.GB2866@suse.cz>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <539cb2ac-9298-3353-8cb7-349e6c686101@gmx.com>
Date: Wed, 12 Jul 2017 22:11:15 +0800
MIME-Version: 1.0
In-Reply-To: <20170712135144.GB2866@suse.cz>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 2017年07月12日 21:51, David Sterba wrote:
> On Wed, Jul 12, 2017 at 04:50:20PM +0300, Nikolay Borisov wrote:
>>> As you wrote, it was not obvious that there was no change on the line,
>>> this just slowed down reading the patch.
>>
>> I didn't intentionally fix this, I've configured vi so as to
>> automatically do this. There is also whitespace damage on a particular
>> line in extent-tree.c and every time I submit a patch that touches this
>> file I explicitly have to omit that particular hunk.
>>
>> How would you feel about me sending a patch fixing those 2 whitespace
>> damages?
> 
> Can't you fix your editor not to auto-correct? :)

At least for tailing white space, there are only 4  in v4.12, including 
this one.

Why not fixing it in one patch so we don't need to bother them any longer?

Thanks,
Qu
