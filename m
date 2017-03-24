Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f66.google.com ([209.85.214.66]:34024 "EHLO
        mail-it0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751620AbdCXNdA (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 24 Mar 2017 09:33:00 -0400
Received: by mail-it0-f66.google.com with SMTP id z70so296671itb.1
        for <linux-btrfs@vger.kernel.org>; Fri, 24 Mar 2017 06:32:59 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170324115859.GN14605@twin.jikos.cz>
References: <871strcs56.wl-satoru.takeuchi@gmail.com> <20170324115859.GN14605@twin.jikos.cz>
From: Satoru Takeuchi <satoru.takeuchi@gmail.com>
Date: Fri, 24 Mar 2017 22:32:57 +0900
Message-ID: <CAMym5wuU8RswLij2=GMNnytHBqHOLDjevdA53WMA5H8fT=CYtg@mail.gmail.com>
Subject: Re: [PATCH] fix inconsistent device between /proc/pid/maps and stat
To: dsterba@suse.cz, Satoru Takeuchi <satoru.takeuchi@gmail.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>,
        Mark Fasheh <mfasheh@suse.de>, David Sterba <dsterba@suse.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

2017-03-24 20:58 GMT+09:00 David Sterba <dsterba@suse.cz>:
> On Tue, Mar 21, 2017 at 10:53:09AM +0900, Satoru Takeuchi wrote:
>> There have been some discussions about inconsistent device between /proc/pid/maps and stat(2).
>>
>> http://thr3ads.net/btrfs-devel/2011/05/2346176-RFC-PATCH-0-2-btrfs-vfs-Return-same-device-in-stat-2-and-proc-pid-maps
>> https://www.spinics.net/lists/linux-btrfs/msg09044.html
>> https://patchwork.kernel.org/patch/2825842/
>> https://patchwork.kernel.org/patch/2831525/
>>
>> It's important since it breaks user programs like lsof(8). There was a patche by Mark to fix this problem.
>> However, unfortunately, that patch is not merged so far.
>
> And no variant of the get_map_dev will ever be merged. Reworking this
> requires extensions to the superblock and subvolume structures, making
> it more generic and suitable for VFS.

Thank you for your comment. I'm going to reconsider how to fix this problem.

Thanks,
Satoru
