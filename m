Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lf0-f45.google.com ([209.85.215.45]:43792 "EHLO
        mail-lf0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753389AbdIRRhv (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 18 Sep 2017 13:37:51 -0400
Received: by mail-lf0-f45.google.com with SMTP id c80so1316116lfh.0
        for <linux-btrfs@vger.kernel.org>; Mon, 18 Sep 2017 10:37:50 -0700 (PDT)
Subject: Re: ERROR: parent determination failed (btrfs send-receive)
To: Graham Cobb <g.btrfs@cobb.uk.net>, Dave <davestechshop@gmail.com>
Cc: linux-btrfs@vger.kernel.org
References: <CAH=dxU7t=p8MVh1y2Tv7wPrP=1ntYcHCy7W6aBQGRtMp_gaaRA@mail.gmail.com>
 <1fa167f4-a8ba-84c7-8e06-9c7e9f3d30e7@gmail.com>
 <CAH=dxU4yTdKQwZX3L-oOMs2ZYiR82m1-F0GhbSU4SV_K2jrBGA@mail.gmail.com>
 <bf5202e0-d2f9-4383-fc1d-42a432eb1a8e@cobb.uk.net>
From: Andrei Borzenkov <arvidjaar@gmail.com>
Message-ID: <64e21116-b78b-ae02-dab1-127dc861d266@gmail.com>
Date: Mon, 18 Sep 2017 20:37:47 +0300
MIME-Version: 1.0
In-Reply-To: <bf5202e0-d2f9-4383-fc1d-42a432eb1a8e@cobb.uk.net>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

18.09.2017 11:45, Graham Cobb пишет:
> On 18/09/17 07:10, Dave wrote:
>> For my understanding, what are the restrictions on deleting snapshots?
>>
>> What scenarios can lead to "ERROR: parent determination failed"?
> 
> The man page for btrfs-send is reasonably clear on the requirements
> btrfs imposes. If you want to use incremental sends (i.e. the -c or -p
> options) then the specified snapshots must exist on both the source and
> destination. If you don't have a suitable existing snapshot then don't
> use -c or -p and just do a full send.
> 

Well, I do not immediately see why -c must imply incremental send. We
want to reduce amount of data that is transferred, so reuse data from
existing snapshots, but it is really orthogonal to whether we send full
subvolume or just changes since another snapshot.

>> I use snap-sync to create and send snapshots.
>>
>> GitHub - wesbarnett/snap-sync: Use snapper snapshots to backup to external drive
>> https://github.com/wesbarnett/snap-sync
> 
> I am not familiar with this tool. Your question should be sent to the
> author of the tool, if that is what is deciding what -p and -c options
> are being used.
> 

I am not sure how it could come to this error. I looked on more or less
default installation of openSUSE here and all snapper snapshots have as
parent UUID the subvolume that is mounted as root (by default only one
configuration for root subvolume exists). So it is not possible to
remove this subvolume, unless some rollback to another snapshot was
performed.
