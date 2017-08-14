Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f41.google.com ([209.85.214.41]:37853 "EHLO
        mail-it0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751588AbdHNNTx (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 14 Aug 2017 09:19:53 -0400
Received: by mail-it0-f41.google.com with SMTP id 76so18118603ith.0
        for <linux-btrfs@vger.kernel.org>; Mon, 14 Aug 2017 06:19:53 -0700 (PDT)
Subject: =?UTF-8?Q?Re:_lazytime_mount_option=e2=80=94no_support_in_Btrfs?=
To: Adam Hunt <voxadam@gmail.com>, linux-btrfs@vger.kernel.org
References: <ompef3$sim$1@blaine.gmane.org>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <35823675-f27b-002b-4b46-cbd230d78e13@gmail.com>
Date: Mon, 14 Aug 2017 09:19:46 -0400
MIME-Version: 1.0
In-Reply-To: <ompef3$sim$1@blaine.gmane.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2017-08-13 07:50, Adam Hunt wrote:
> Back in 2014 Ted Tso introduced the lazytime mount option for ext4 and
> shortly thereafter a more generic VFS implementation which was then
> merged into mainline. His early patches included support for Btrfs but
> those changes were removed prior to the feature being merged. His
> changelog includes the following note about the removal:
> 
>    - Per Christoph's suggestion, drop support for btrfs and xfs for now,
>      issues with how btrfs and xfs handle dirty inode tracking.  We can add
>      btrfs and xfs support back later or at the end of this series if we
>      want to revisit this decision.
> 
> My reading of the current mainline shows that Btrfs still lacks any
> support for lazytime. Has any thought been given to adding support for
> lazytime to Btrfs?
It has bee at least lightly discussed (I forget the thread, but I did a 
reasonably specific explanation of the interaction of the *atime and 
lazytime options in a thread a while back when trying to explain to 
someone why I wanted to be able to run with noatime and lazytime), but I 
don't think the discussion got anywhere.

I would personally love to see support for it myself (or you know, at 
least have some warning that it isn't supported instead of just silently 
accepting and ignoring it like we do currently), but I unfortunately 
don't have the time or expertise to work on implementing it.  If someone 
does post a patch though, I'll be more than happy to throw a few dozen 
VM's at testing it.
