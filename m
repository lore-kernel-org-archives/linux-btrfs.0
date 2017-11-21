Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f54.google.com ([74.125.82.54]:42112 "EHLO
        mail-wm0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750772AbdKUP3D (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 21 Nov 2017 10:29:03 -0500
Received: by mail-wm0-f54.google.com with SMTP id l188so2438951wma.1
        for <linux-btrfs@vger.kernel.org>; Tue, 21 Nov 2017 07:29:03 -0800 (PST)
Message-ID: <1511278140.1680.41.camel@gmail.com>
Subject: Re: quotas: failure on removing a file via SFTP/SSH
From: ST <smntov@gmail.com>
To: Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: linux-btrfs@vger.kernel.org
Date: Tue, 21 Nov 2017 17:29:00 +0200
In-Reply-To: <09f4e574-8cab-26fd-d7ea-64a0cee2b20b@gmx.com>
References: <1511266131.1680.27.camel@gmail.com>
         <093ee7e4-91f1-7d23-1ef1-81230d07b405@gmx.com>
         <1511270292.1680.35.camel@gmail.com>
         <09f4e574-8cab-26fd-d7ea-64a0cee2b20b@gmx.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

> >>> I'm trying to use quotas for a simple chrooted sftp setup, limiting
> >>> space for each user's subvolume (now for testing to 1M).
> >>>
> >>> I tried to hit the limit by uploading files and once it comes to the
> >>> limit I face following problem: if I try to free space by removing a
> >>> file via Linux sftp client (or Filezilla) - I get error:
> >>> "Couldn't delete file: Failure"
> >>>
> >>> Sometimes, but not always, if I repeat it for 3-5 times it does removes
> >>> the file at the end.
> >>> If I login as root and try to remove the file via SSH I get the error:
> >>> "rm: cannot remove 'example.txt': Disk quota exceeded"
> >>>
> >>> What is the problem? And how can I solve it?
> >>
> >> Kernel version first.
> >>
> >> If it's possible, please use latest kernel, at least newer than v4.10,
> >> since we have a lot of qgroup reservation related fixes in newer kernel.
> >>
> >> Then, for small quota, due to the nature of btrfs metadata CoW and
> >> relative large default node size (16K), it's quite easy to hit disk
> >> quota for metadata.
> > 
> > Yes, but why I get the error specifically on REMOVING a file? Even if I
> > hit disk quota - if I free up space - it should be possible, isn't it?
> 
> It's only true for fs modifying its metadata in-place (and use journal
> to protect it).
> 
> For fs using metadata CoW, even freeing space needs extra space for new
> metadata.
> 

Wait, it doesn't sound like a bug, but rather like a flaw in design.
This means - each time a user hits his quota limit he will get stuck
without being able to free space?!!

Thank you.

