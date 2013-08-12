Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:16390 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755398Ab3HLCdS (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 11 Aug 2013 22:33:18 -0400
Message-ID: <52084AD3.5020400@oracle.com>
Date: Mon, 12 Aug 2013 10:39:15 +0800
From: Anand Jain <Anand.Jain@oracle.com>
MIME-Version: 1.0
To: Eric Sandeen <sandeen@redhat.com>
CC: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 2/2] btrfs: btrfs_rm_device() should zero mirror SB as
 well
References: <1374773376-29853-1-git-send-email-anand.jain@oracle.com> <1374773376-29853-2-git-send-email-anand.jain@oracle.com> <5205556E.8030902@redhat.com> <52059FC2.3080203@oracle.com> <5206BA38.20903@redhat.com>
In-Reply-To: <5206BA38.20903@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



Hi Eric,

>>>> btrfs fi show
>>>> Label: none  uuid: e7aae9f0-1aa8-41f5-8fb6-d4d8f80cdb2c
>>>>           Total devices 1 FS bytes used 28.00KiB
>>>>           devid    2 size 2.00GiB used 0.00 path /dev/sdc   <-- WRONG
>>>>           devid    1 size 2.00GiB used 20.00MiB path /dev/sdb
>>>
>>> Ok, now it's findable.  Isn't that exactly how this should behave?
>>> What is wrong about this?
>>
>>   Total devices is still 1.
>
> Hm, so it is.  But that inconsistency indicates a bug
> somewhere else, doesn't it?

  Nope. to undo dev-delete admin has to use dev-add.

  Here the idea is to release the disk nicely when
  we know we don't need it anymore.

Thanks, Anand

