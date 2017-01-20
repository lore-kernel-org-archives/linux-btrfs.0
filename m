Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yw0-f176.google.com ([209.85.161.176]:33016 "EHLO
        mail-yw0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752633AbdATPT4 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 20 Jan 2017 10:19:56 -0500
Received: by mail-yw0-f176.google.com with SMTP id u68so51524579ywg.0
        for <linux-btrfs@vger.kernel.org>; Fri, 20 Jan 2017 07:19:46 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <6ee63ff7-6a0c-7828-0751-5769d59bb85f@cn.fujitsu.com>
References: <CAJCQCtQ-WkNShYNGi9hk8s7M_RdLGHV3Jw0zArt_W-uzYQ9BAg@mail.gmail.com>
 <6ee63ff7-6a0c-7828-0751-5769d59bb85f@cn.fujitsu.com>
From: Chris Murphy <chris@colorremedies.com>
Date: Fri, 20 Jan 2017 08:10:58 -0700
Message-ID: <CAJCQCtTdfD6=xWttk5D4JqLpzG9ZMxb-c=GopZPPNsLP6eHHpw@mail.gmail.com>
Subject: Re: btrfs check lowmem vs original
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jan 19, 2017 at 10:45 PM, Qu Wenruo <quwenruo@cn.fujitsu.com> wrote:

>> Another file system, 15 minutes old with two mounts in its whole
>> lifetime, and only written with kernel 4.10-rc3 has over 30 lines of
>> varying numbers:
>>
>> ERROR: root 257 EXTENT DATA[150134 11317248] prealloc shouln't have
>> datasum
>>
>> That file system should have no preallocated extents (It's a clean
>> installation of Fedora Rawhide, using only rsync)
>
>
> btrfs-debug-tree will help to make sure what is wrong.

6b187fa6.logs.tar.gz 20M
https://drive.google.com/open?id=0B_2Asp8DGjJ9SlRvZ2plNXVmTUU


That's the small recent one, generic content. The others are bigger,
and I should probably sanitize the filenames from debug-tree but can't
find in the archives how to do that. Is btrfs-image useful for this?




> That's why lowmem mode is still not the default option.
>
> The problem os original mode is, if you're checking a TB level fs and only 2
> or 4G ram, then it's quite possible you ran out of memory and won't be able
> to check the fs forever, more several than annoying.

Fair enough.



-- 
Chris Murphy
