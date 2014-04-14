Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:42260 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750720AbaDNBPr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 13 Apr 2014 21:15:47 -0400
Message-ID: <534B36FC.3060300@cn.fujitsu.com>
Date: Mon, 14 Apr 2014 09:16:44 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
To: Marc MERLIN <marc@merlins.org>, <dsterba@suse.cz>,
        <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH 1/2] btrfs-progs: Add device management related paragraph.
References: <1397184233-18535-1-git-send-email-quwenruo@cn.fujitsu.com> <20140411061048.GD7322@merlins.org> <20140411173628.GG29256@twin.jikos.cz> <20140411175226.GL7322@merlins.org>
In-Reply-To: <20140411175226.GL7322@merlins.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


-------- Original Message --------
Subject: Re: [PATCH 1/2] btrfs-progs: Add device management related 
paragraph.
From: Marc MERLIN <marc@merlins.org>
To: dsterba@suse.cz, Qu Wenruo <quwenruo@cn.fujitsu.com>, 
linux-btrfs@vger.kernel.org
Date: 2014年04月12日 01:52
> On Fri, Apr 11, 2014 at 07:36:28PM +0200, David Sterba wrote:
>> On Thu, Apr 10, 2014 at 11:10:48PM -0700, Marc MERLIN wrote:
>>>> --- a/Documentation/btrfs-replace.txt
>>>> +++ b/Documentation/btrfs-replace.txt
>>>> @@ -13,6 +13,9 @@ DESCRIPTION
>>>>   -----------
>>>>   'btrfs replace' is used to replace btrfs managed devices with other device.
>>> I would add a quick line here saying that it's not currently supported for
>>> RAID5/6, and to see btrfs-device for add/delete to get around the replace
>>> missing problem.
>> I've added the quick note when committing the patch.
> Thanks both.
>
> Generally, would you agree to putting more links to the wiki in man pages
> since man pages are not forever but sure take a long time to update on the
> installed based and the wiki can be up to date for everyone right away?
> (I'm not saying to remove info from the man pages, but more something like
> "btrfs is changing quickly, more up to date information can be found on the
> wiki page for
> raid56: https://btrfs.wiki.kernel.org/index.php/RAID56
> or
> btrfsck: https://btrfs.wiki.kernel.org/index.php/Btrfsck
> btrfs restore: https://btrfs.wiki.kernel.org/index.php/Restore
>
> Thanks,
> Marc
That's pretty nice and helpful.
But one of my concern is that wiki changes are not shown as patches in 
mail list and somewhat
independent from btrfs-progs,
so if some developers changed the behavior of RAID56/btrfsck/restore, he 
or she may only modify the man page
but not wiki page.

Any good idea to synchronise wiki pages and man pages?

Thanks,
Qu
