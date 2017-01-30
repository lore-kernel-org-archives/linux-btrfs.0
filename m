Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from umail2.aei.mpg.de ([194.94.224.8]:42095 "EHLO umail2.aei.mpg.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754386AbdA3VtJ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 30 Jan 2017 16:49:09 -0500
Received: from mailgate.aei.mpg.de (mailgate.aei.mpg.de [194.94.224.5])
        by umail2.aei.mpg.de (Postfix) with ESMTP id 5E34B1BA66FD
        for <linux-btrfs@vger.kernel.org>; Mon, 30 Jan 2017 22:40:03 +0100 (CET)
Received: from mailgate.aei.mpg.de (localhost [127.0.0.1])
        by localhost (Postfix) with SMTP id 5195F406ADE
        for <linux-btrfs@vger.kernel.org>; Mon, 30 Jan 2017 22:40:03 +0100 (CET)
Received: from intranet.aei.uni-hannover.de (ahin1.aei.uni-hannover.de [130.75.117.40])
        by mailgate.aei.mpg.de (Postfix) with ESMTP id 14006406ADB
        for <linux-btrfs@vger.kernel.org>; Mon, 30 Jan 2017 22:40:01 +0100 (CET)
Subject: Re: btrfs recovery
References: <5e29c839-6519-acb2-c094-54600a6c0102@aei.mpg.de>
 <CAJCQCtTqBaG5AhtbokOkfREStK8XC+ZAsQ-aNOtYe2Y2Nv-4jA@mail.gmail.com>
 <5742ef43-0400-e0c9-c0b7-c8d3c8299f9f@aei.mpg.de>
 <CAJCQCtSO+vUxOL6FHOdgLqOLSm6C6U4YfUga=K-h7fhBDCaXng@mail.gmail.com>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
From: Michael Born <Michael.Born@aei.mpg.de>
Message-ID: <c8a7f4a3-f758-c78c-2525-fd36f4347fc5@aei.mpg.de>
Date: Mon, 30 Jan 2017 22:40:00 +0100
MIME-Version: 1.0
In-Reply-To: <CAJCQCtSO+vUxOL6FHOdgLqOLSm6C6U4YfUga=K-h7fhBDCaXng@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am 30.01.2017 um 22:20 schrieb Chris Murphy:
> On Mon, Jan 30, 2017 at 2:07 PM, Michael Born <Michael.Born@aei.mpg.de> wrote:
>> The files I'm interested in (fstab, NetworkManager.conf, ...) didn't
>> change for months. Why would they change in the moment I copy their
>> blocks with dd?
> 
> They didn't change. The file system changed. While dd is reading, it
> might be minutes between capturing different parts of the file system,
> and each superblock is in different locations on the disk,
> guaranteeing that if the dd takes more than 30 seconds, your dd image
> has different generation super blocks. Btrfs notices this at mount
> time and will refuse to mount because the file system is inconsistent.
> 
> It is certainly possible to fix this, but it's likely to be really,
> really tedious. The existing tools don't take this use case into
> account.
> 
> Maybe btfs-find-root can come up with some suggestions and you can use
> btrfs restore -t with the bytenr from find root, to see if you can get
> this old data, ignoring the changes that don't affect the old data.
> 
> What you do with this is btrfs-find-root and see what it comes up
> with. And work with the most recent (highest) generation going
> backward, plugging in the bytenr into btrfs restore with -t option.
> You'll also want to use the dry run to see if you're getting what you
> want. It's best to use the exact path if you know it, this takes much
> less time for it to search all files in a given tree. If you don't
> know the exact path, but you know part of a file name, then you'll
> need to use the regex option; or just let it dump everything it can
> from the image and go dumpster diving...

I really want to try the "btrfs-find-root / btrfs restore -t" method.
But, btrfs-find-root gives me just the 3 lines output and then nothing
for 16 hours.
I think, I saw a similar report that the tool just doesn't report back
in the mailing list archive (btrfs-find-root duration? Markus Binsteiner
Sat, 10 Dec 2016 16:12:25 -0800)

./btrfs-find-root /dev/loop0
Couldn't read tree root
Superblock thinks the generation is 550114
Superblock thinks the level is 1

Hans, also thank you for the explanation even though I'm not sure, I
understand.
I would be happy with older parts of the tree which then have lower
numbers than the 550112.

Michael


