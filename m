Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f170.google.com ([209.85.223.170]:54236 "EHLO
        mail-io0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755224AbdKBLH1 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 2 Nov 2017 07:07:27 -0400
Received: by mail-io0-f170.google.com with SMTP id 189so12985481iow.10
        for <linux-btrfs@vger.kernel.org>; Thu, 02 Nov 2017 04:07:27 -0700 (PDT)
Subject: Re: defragmenting best practice?
To: Dave <davestechshop@gmail.com>,
        Linux fs Btrfs <linux-btrfs@vger.kernel.org>
Cc: Peter Grandi <pg@btrfs.list.sabi.co.uk>
References: <20170831070558.GB5783@rus.uni-stuttgart.de>
 <20170914133824.5cf9b59c@jupiter.sol.kaishome.de>
 <CABB28CyM9wQuDgn1ONTw3hrXQrLHwk30dxPcF_qnvdCM+A0gxA@mail.gmail.com>
 <20170914172434.39eae89d@jupiter.sol.kaishome.de>
 <CABB28Cx13a4eP3nM7PVYknmug-jpyeKv1ai5DWT0jKt4Zi0Rgg@mail.gmail.com>
 <59BBB15E.8010002@sarach.com.pl>
 <CABB28CxYR35HQgvf5PvRpDkGvtBxMR1LBDQO60N6QZ1cBmZGjQ@mail.gmail.com>
 <59BBDFA6.4020500@sarach.com.pl>
 <20170915190826.1f0be8a9@jupiter.sol.kaishome.de>
 <CABB28Cw6A-xYnwkcaoc=1XJa=K8g-Bz6_KFT2Q33FUJhbXD8JQ@mail.gmail.com>
 <CAH=dxU7R2fZQY12mJnYigt2s4BqVrsALJjxgbpvo7hfEwMXt-Q@mail.gmail.com>
 <pan$a362c$5b92cac0$d2d78b7f$25ff3b3a@cox.net>
 <CAH=dxU6f_DunAsOqKQTXKp469bOaLCiqOMuSE0T3QYqc9CqFNQ@mail.gmail.com>
 <23033.512.820691.680916@tree.ty.sabi.co.uk>
 <CAH=dxU7aNg+VTeQFk-9Tk4yzPemsgL1E0iqSFXFQOxM8=ATDFQ@mail.gmail.com>
 <9e274506-9780-bb74-8ba0-e5fa6c9663c3@gmail.com>
 <CAH=dxU5Xx4naY9VR5ri92afHXm9-04DLvOG=E5QLRtKn7Q5s5w@mail.gmail.com>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <f621ce21-5984-2d68-4fb5-8f45e13cb760@gmail.com>
Date: Thu, 2 Nov 2017 07:07:23 -0400
MIME-Version: 1.0
In-Reply-To: <CAH=dxU5Xx4naY9VR5ri92afHXm9-04DLvOG=E5QLRtKn7Q5s5w@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2017-11-01 21:39, Dave wrote:
> On Wed, Nov 1, 2017 at 8:21 AM, Austin S. Hemmelgarn
> <ahferroin7@gmail.com> wrote:
> 
>>> The cache is in a separate location from the profiles, as I'm sure you
>>> know.  The reason I suggested a separate BTRFS subvolume for
>>> $HOME/.cache is that this will prevent the cache files for all
>>> applications (for that user) from being included in the snapshots. We
>>> take frequent snapshots and (afaik) it makes no sense to include cache
>>> in backups or snapshots. The easiest way I know to exclude cache from
>>> BTRFS snapshots is to put it on a separate subvolume. I assumed this
>>> would make several things related to snapshots more efficient too.
>>
>> Yes, it will, and it will save space long-term as well since $HOME/.cache is
>> usually the most frequently modified location in $HOME. In addition to not
>> including this in the snapshots, it may also improve performance.  Each
>> subvolume is it's own tree, with it's own locking, which means that you can
>> generally improve parallel access performance by splitting the workload
>> across multiple subvolumes.  Whether it will actually provide any real
>> benefit in that respect is heavily dependent on the exact workload however,
>> but it won't hurt performance.
> 
> I'm going to make this change now. What would be a good way to
> implement this so that the change applies to the $HOME/.cache of each
> user?
> 
> The simple way would be to create a new subvolume for each existing
> user and mount it at $HOME/.cache in /etc/fstab, hard coding that
> mount location for each user. I don't mind doing that as there are
> only 4 users to consider. One minor concern is that it adds an
> unexpected step to the process of creating a new user. Is there a
> better way?
> 
The easiest option is to just make sure nobody is logged in and run the 
following shell script fragment:

     for dir in /home/* ; do
         rm -rf $dir/.cache
         btrfs subvolume create $dir/.cache
     done

And then add something to the user creation scripts to create that 
subvolume.  This approach won't pollute /etc/fstab, will still exclude 
the directory from snapshots, and doesn't require any hugely creative 
work to integrate with user creation and deletion.

In general, the contents of the .cache directory are just that, cached 
data.  Provided nobody is actively accessing it, it's perfectly safe to 
just nuke the entire directory (I actually do this on a semi-regular 
basis on my systems just because it helps save space).  In fact, based 
on the FreeDesktop.org standards, if this does break anything, it's a 
bug in the software in question.
