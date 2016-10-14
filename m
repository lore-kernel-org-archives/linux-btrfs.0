Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:16447 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1757246AbcJNAus (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 13 Oct 2016 20:50:48 -0400
Subject: Re: [PATCH v2 0/4] Btrfs-convert: Add support to copy common inode
 flags
To: <dsterba@suse.cz>, <linux-btrfs@vger.kernel.org>
References: <20161011024446.16546-1-quwenruo@cn.fujitsu.com>
 <20161013141558.GW11398@twin.jikos.cz>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <41c42235-ef89-1f5c-28cc-bf3275045737@cn.fujitsu.com>
Date: Fri, 14 Oct 2016 08:50:31 +0800
MIME-Version: 1.0
In-Reply-To: <20161013141558.GW11398@twin.jikos.cz>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



At 10/13/2016 10:15 PM, David Sterba wrote:
> Hi,
>
> patches merged to devel, thanks. I made a few minor adjustments, not
> bothering you with them.

Thanks for all your work.
Now I can just rebase my scrub work to devel branch.

>
> On Tue, Oct 11, 2016 at 10:44:42AM +0800, Qu Wenruo wrote:
>> Branch can be fetched from:
>> https://github.com/adam900710/btrfs-progs/tree/convert_inode_flags
>
> I can pull the branches from you, either to devel or integration. Please
> base them on the last release point (ie. master) if there are no other
> dependencies. Otherwise, I'll publish a branch that contains the desired
> patches and will promise not to change it with rebases.
>

Sorry I'm not very familiar with when to send a pull request and when to 
send normal patches, and to which branch it should be rebased to.

 From my understanding, for large patchset pull request is preferred(and 
patchse should still be sent out for review) and for small changes, 
normal mail should be good enough.

And normally I rebase all my branches/patches to your devel branch.
Or should I rebase them to the master branch?

Thanks,
Qu


