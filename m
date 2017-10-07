Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lf0-f41.google.com ([209.85.215.41]:52160 "EHLO
        mail-lf0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750972AbdJGH43 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Sat, 7 Oct 2017 03:56:29 -0400
Received: by mail-lf0-f41.google.com with SMTP id r129so3390844lff.8
        for <linux-btrfs@vger.kernel.org>; Sat, 07 Oct 2017 00:56:28 -0700 (PDT)
Subject: Re: [PATCH v4] btrfs: Remove received_uuid during received snapshot
 ro->rw switch
To: Hans van Kranenburg <hans.van.kranenburg@mendix.com>, dsterba@suse.cz,
        Anand Jain <anand.jain@oracle.com>,
        Nikolay Borisov <nborisov@suse.com>, linux-btrfs@vger.kernel.org
References: <20171004150039.GE3521@twin.jikos.cz>
 <1507191773-23039-1-git-send-email-nborisov@suse.com>
 <f80cdc51-a077-60fa-01b3-3521c0adfdfb@oracle.com>
 <20171006172415.GW3521@twin.jikos.cz>
 <52a7046b-1ef8-e452-4ca4-d9eda2d8d1a2@mendix.com>
 <e118b4e4-fd52-6ac3-0446-1dd5a7976544@gmail.com>
 <ec221e1c-3cac-d35b-2bb9-fe66675b106e@mendix.com>
From: Andrei Borzenkov <arvidjaar@gmail.com>
Message-ID: <6ff10fe2-118e-6b82-33b1-4dfbb0d68749@gmail.com>
Date: Sat, 7 Oct 2017 10:56:25 +0300
MIME-Version: 1.0
In-Reply-To: <ec221e1c-3cac-d35b-2bb9-fe66675b106e@mendix.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

07.10.2017 00:27, Hans van Kranenburg пишет:
> On 10/06/2017 10:07 PM, Andrei Borzenkov wrote:
>>
>> What is reason behind allowing change from ro to rw in the first place?
>> What is the use case?
> 
> I think this is a case of "well, nobody actually has been thinking of
> the use cases ever, we just did something yolo"
> 
> Btrfs does not make a difference between snapshots and clones. Other
> systems like netapp and zfs do. Btrfs cloud also do that, and just not
> expose the ro/rw flag to the outside.
> 

Current pure user-level implementation of btrfs receive requires
possibility to switch from rw to ro. So it is not possible to completely
hide it. This is different from both NetApp and ZFS. On NetApp
destination volume/qtree are always read-only for client access. ZFS
explicitly disallows any access to destination until transfer is complete.

It was already mentioned that in btrfs destination may be changed before
subvolume is changed to ro without anyone noticing it. Ideally btrfs
receive needs exclusive access to subvolume with some sort of automatic
cleanup if receive fails for any reason. This will ensure atomic (from
end user PoV) transfer.

> Personally, I would like btrfs to go into that direction, because it
> just makes things more clear. This is a snapshot, you cannot touch it.
> If you want to make changes, you have to make a rw clone of the snapshot.
>
> The nice thing for btrfs is that you can remove the snapshot after you
> made the rw clone, which you cannot do on a NetApp filer. :o)
> 
>>> Even if it wouldn't make sense for some reason, it's a nice thought
>>> experiment. :)
> 
> There we go :)
> 
