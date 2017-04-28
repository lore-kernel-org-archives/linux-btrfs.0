Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yb0-f179.google.com ([209.85.213.179]:36767 "EHLO
        mail-yb0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S642167AbdD1T7r (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 28 Apr 2017 15:59:47 -0400
Received: by mail-yb0-f179.google.com with SMTP id s22so18012856ybe.3
        for <linux-btrfs@vger.kernel.org>; Fri, 28 Apr 2017 12:59:47 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <22787.39530.223012.644477@tree.ty.sabi.co.uk>
References: <CAJCQCtQk1p6rzUYaO19ei51YC+w1uj1qJ77OdLmL5JN3w1zNfw@mail.gmail.com>
 <5fd31e68-0199-8935-0873-78b4e7c6eb69@inwind.it> <CAJCQCtQCV2DmpsEFtRVdJDMkT54bzbU66+5W873mpJAyXf5k9A@mail.gmail.com>
 <2bfe32ee-4db6-f3ca-ce87-ec72ce300bd0@inwind.it> <22787.39530.223012.644477@tree.ty.sabi.co.uk>
From: Chris Murphy <lists@colorremedies.com>
Date: Fri, 28 Apr 2017 13:59:45 -0600
Message-ID: <CAJCQCtRZZcydwnGiZqSDnGrmK=Yn4q1oJK3UR+Kz1HC9KsZfRQ@mail.gmail.com>
Subject: Re: btrfs, journald logs, fragmentation, and fallocate
To: Peter Grandi <pg@btrfs.list.sabi.co.uk>
Cc: Linux fs Btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Apr 28, 2017 at 1:39 PM, Peter Grandi <pg@btrfs.list.sabi.co.uk> wrote:


> In a particularly demented setup I had to decastrophize with
> great pain a Zimbra QCOW2 disk image (XFS on NFS on XFS on
> RAID6) containining an ever growing number Maildir email archive
> ended up with over a million widely scattered microextents:
>
>   http://www.sabi.co.uk/blog/1101Jan.html?110116#110116

Related Btrfs thread "File system corruption, btrfsck abort" involves
5 concurrent use VM's with guests using ext4, NTFS, HFS+, Btrfs, LVM,
pointing to qcow2 files on Btrfs for backing. And it's resulting in
problems...


-- 
Chris Murphy
