Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f68.google.com ([209.85.214.68]:35924 "EHLO
	mail-it0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752698AbcFCMzW (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 3 Jun 2016 08:55:22 -0400
Received: by mail-it0-f68.google.com with SMTP id i127so6377357ita.3
        for <linux-btrfs@vger.kernel.org>; Fri, 03 Jun 2016 05:55:21 -0700 (PDT)
Subject: Re: Recommended why to use btrfs for production?
To: Martin <rc6encrypted@gmail.com>, linux-btrfs@vger.kernel.org
References: <CAGQ70Yc=HHxJspMCKFBpEURRu=53pZW3k3rVDVO3QPGP_b9Tkw@mail.gmail.com>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <aeade1fe-825c-6fc2-7f6d-85f4c5400b38@gmail.com>
Date: Fri, 3 Jun 2016 08:55:18 -0400
MIME-Version: 1.0
In-Reply-To: <CAGQ70Yc=HHxJspMCKFBpEURRu=53pZW3k3rVDVO3QPGP_b9Tkw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2016-06-03 05:49, Martin wrote:
> Hello,
>
> We would like to use urBackup to make laptop backups, and they mention
> btrfs as an option.
>
> https://www.urbackup.org/administration_manual.html#x1-8400010.6
>
> So if we go with btrfs and we need 100TB usable space in raid6, and to
> have it replicated each night to another btrfs server for "backup" of
> the backup, how should we then install btrfs?
>
> E.g. Should we use the latest Fedora, CentOS, Ubuntu, Ubuntu LTS, or
> should we compile the kernel our self?
In general, avoid Ubuntu LTS versions when dealing with BTRFS, as well 
as most enterprise distros, they all tend to back-port patches instead 
of using newer kernels, which means it's functionally impossible to 
provide good support for them here (because we can't know for sure what 
exactly they've back-ported).  I'd suggest building your own kernel if 
possible, with Arch Linux being a close second (they follow upstream 
very closely), followed by Fedora and non-LTS Ubuntu.
>
> And a bonus question: How stable is raid6 and detecting and replacing
> failed drives?
Do not use BTRFS raid6 mode in production, it has at least 2 known 
serious bugs that may cause complete loss of the array due to a disk 
failure.  Both of these issues have as of yet unknown trigger 
conditions, although they do seem to occur more frequently with larger 
arrays.

That said, there are other options.  If you have enough disks, you can 
run BTRFS raid1 on top of LVM or MD RAID5 or RAID6, which provides you 
with the benefits of both.

Alternatively, you could use BTRFS raid1 on top of LVM or MD RAID1, 
which actually gets relatively decent performance and can provide even 
better guarantees than RAID6 would (depending on how you set it up, you 
can lose a lot more disks safely).  If you go this way, I'd suggest 
setting up disks in pairs at the lower level, and then just let BTRFS 
handle spanning the data across disks (BTRFS raid1 mode keeps exactly 
two copies of each block).  While this is not quite as efficient as just 
doing LVM based RAID6 with a traditional FS on top, it's also a lot 
easier to handle reshaping the array on-line because of the device 
management in BTRFS itself.
