Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f181.google.com ([209.85.213.181]:32878 "EHLO
	mail-ig0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752708AbbIZLn4 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 26 Sep 2015 07:43:56 -0400
Received: by igbkq10 with SMTP id kq10so28130905igb.0
        for <linux-btrfs@vger.kernel.org>; Sat, 26 Sep 2015 04:43:56 -0700 (PDT)
MIME-Version: 1.0
Reply-To: fdmanana@gmail.com
In-Reply-To: <56053C21.8060809@urbackup.org>
References: <56053C21.8060809@urbackup.org>
Date: Sat, 26 Sep 2015 12:43:55 +0100
Message-ID: <CAL3q7H5aBmv5Ya6epBMef_VDpqpV4A2Gwua4A7GvJERfHAo6bQ@mail.gmail.com>
Subject: Re: Incremental btrfs send/receive fails if file is unlinked and
 cloned afterwards
From: Filipe Manana <fdmanana@gmail.com>
To: Martin Raiber <martin@urbackup.org>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Sep 25, 2015 at 1:20 PM, Martin Raiber <martin@urbackup.org> wrote:
> Hi,
>
> the commit "Btrfs: incremental send, check if orphanized dir inode needs
> delayed rename" causes incremental send/receive to fail if a file is
> unlinked and then reflinked to the same location from the parent
> snapshot. An xfstest reproducing the issue is attached.

Thanks for the report and test.
The problem is not related at all to reflinked files (or extent
cloning/dedup). You run into this problem by just creating a file with
the same name and at the same location, and it needs to be the file
with highest inode number in the snapshot.

I've sent a fix and modified your test too, as it didn't conform to
the xfstests coding style, had unnecessary requirements (cloner
program, cp with reflink support) and added a description of the
problem.

thanks

>
> Regards,
> Martin



-- 
Filipe David Manana,

"Reasonable men adapt themselves to the world.
 Unreasonable men adapt the world to themselves.
 That's why all progress depends on unreasonable men."
