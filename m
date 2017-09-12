Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qk0-f196.google.com ([209.85.220.196]:38169 "EHLO
        mail-qk0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751379AbdILMQH (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 12 Sep 2017 08:16:07 -0400
Received: by mail-qk0-f196.google.com with SMTP id c69so7053756qke.5
        for <linux-btrfs@vger.kernel.org>; Tue, 12 Sep 2017 05:16:07 -0700 (PDT)
Subject: Re: Storage and snapshots as historical yearly
To: Pete <pete@petezilla.co.uk>, linux-btrfs@vger.kernel.org
References: <9208764.SjP1vfhOIA@pcsenen>
 <07ff0aeb-d4a8-ffb9-3a13-695ab9b2e65f@gmail.com>
 <34d8d690-d999-0081-4a80-65a6de439639@petezilla.co.uk>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <3e3eae9d-f7d0-fafb-6faf-6eecdf724c8b@gmail.com>
Date: Tue, 12 Sep 2017 08:16:03 -0400
MIME-Version: 1.0
In-Reply-To: <34d8d690-d999-0081-4a80-65a6de439639@petezilla.co.uk>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2017-09-11 17:36, Pete wrote:
> On 09/11/2017 07:49 PM, Austin S. Hemmelgarn wrote:
> 
>> Unfortunately, I don't know of any overlay mount implementation that
>> works correctly and reliably with BTRFS.  I know for a fact that
>> OverlayFS (the upstream in-kernel implementation) does not work, and I
>> believe that AUFS3 and UnionFS (the third-party options that are used by
>> most LiveCD's) don't work either.  UnionFS-FUSE (a userspace
>> implementation completely unrelated to UnionFS) might work, but I've
>> never tested it and it will likely have performance issues because it's
>> implemented in userspace.  As far as I know, whiteout support is the
>> primary missing piece here, but I may be mistaken.
>>
> 
> Diverting away from the original topic, what issues with overlayfs and
> btrfs?
As mentioned, I thought whiteout support was missing, but if you're 
using it without issue, I might be wrong.
> 
> I'm using btrfs to create 'base' operating system containers (btrfs) and
> then using overlayfs for a few 'upper' containers for specific
> applications, so the upper parts of the overlays contain only the config
> and data files and I can apply OS updates only on the lower ones.
> 
> I do note that changes in the 'base' os can take time to propagate to
> the upper containers and I'm probably not being sensible in not stopping
> the upper containers when updating the lower ones.  This is also does
> not seem to be what overlaysfs is intended for.  However, for my light
> usage it generally works OK and is useful to me.
Actually, this is pretty well in-line with one of the intended use cases 
(it was mostly designed for efficient multiple instantiation of Docker 
or LXC containers).  The other big use case is 'live' systems that only 
retain state while powered on, like most install images.
