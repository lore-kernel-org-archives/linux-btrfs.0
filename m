Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:21991 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754679AbcKVIwA (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 22 Nov 2016 03:52:00 -0500
Subject: Re: [PATCH v2 0/5] Make btrfs-progs really compatible with any kernel
 version
To: dsterba@suse.cz, linux-btrfs@vger.kernel.org
References: <1448283378-10579-1-git-send-email-anand.jain@oracle.com>
 <824aa945-fd1f-45a2-9123-2bd810f464d6@oracle.com>
 <20161114121335.GJ12522@suse.cz>
From: Anand Jain <anand.jain@oracle.com>
Message-ID: <426cb2c7-b947-63d1-a8c4-8a575268377f@oracle.com>
Date: Tue, 22 Nov 2016 16:54:58 +0800
MIME-Version: 1.0
In-Reply-To: <20161114121335.GJ12522@suse.cz>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



(sorry for the delay due to my vacation).

On 11/14/16 20:13, David Sterba wrote:
> On Tue, Nov 08, 2016 at 09:14:39PM +0800, Anand Jain wrote:
>>   This patch isn't integrated, any idea why ?
>
> Because it does not cover all usecases.

  David,

    You have stated one of the use case here
     https://www.spinics.net/lists/linux-btrfs/msg49391.html

    which I have it implemented in these patches
      [PATCH 5/7] btrfs-progs: introduce framework version to features
      [PATCH 6/7] btrfs-progs: add -O comp= option for mkfs.btrfs
      [PATCH 7/7] btrfs-progs: add -O comp= option for btrfs-convert

    was their more ?

> I've committed the preparatory
> bits from branch where I've been working on that feature so we can
> actually get to the hard parts.

  these patch set is a year old as well. are you planning to drop
  these patches ? the clarity is missing. IMO.

Thanks, Anand
