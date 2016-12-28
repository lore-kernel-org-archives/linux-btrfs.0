Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yw0-f182.google.com ([209.85.161.182]:34715 "EHLO
        mail-yw0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751285AbcL1Kkk (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 28 Dec 2016 05:40:40 -0500
Received: by mail-yw0-f182.google.com with SMTP id t125so185052566ywc.1
        for <linux-btrfs@vger.kernel.org>; Wed, 28 Dec 2016 02:40:39 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <9799c1aa-e365-f05d-2b96-017edc67ec90@oracle.com>
References: <20161206043938.3249-1-anand.jain@oracle.com> <20161212171927.GY12522@twin.jikos.cz>
 <9799c1aa-e365-f05d-2b96-017edc67ec90@oracle.com>
From: "Janos Toth F." <toth.f.janos@gmail.com>
Date: Wed, 28 Dec 2016 11:40:23 +0100
Message-ID: <CANznX5FsY==9svvhmRtAG=9_GE5PHYU34B3Hboq-A36GvTf+pg@mail.gmail.com>
Subject: Re: [PATCH] recursive defrag cleanup
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I still find the defrag tool a little bit confusing from a user perspective:
- Does the recursive defrag (-r) also defrag the specified directory's
extent tree or should one run two separate commands for completeness
(one with -r and one without -r)?
- What's the target scope of the extent tree defragmentation? Is it
recursive on the tree (regardless of the -r option) and thus
defragments all the extent trees in case one targets the root
subvolume?

In other words: What is the exact sequence of commands if one wishes
to defragment the whole filesystem as extensively as possible (all
files and extent trees included)?

There used to be a scrip floating around on various wikis (for
example, the Arch Linux wiki) which used the "find" tool to feed each
and every directory to the defrag command. I always thought that must
be overkill and now it's gone, but I don't see further explanations
and/or new scripts in place (other than a single command with the -r
option).


It's also a little mystery for me if balancing the metadata chunks is
supposed to be effectively defragmenting the metadata or not and what
the best practice regarding that issue is.
In my personal experience Btrfs filesystems tend to get slower over
time, up to the point where it takes several minutes to mount them or
to delete some big files (observed on HDDs, not on SSDs where the
sheer speed might masks the problem and filesystem tends to be smaller
anyway). When it gets really bad, Gentoo's localmount script starts to
time out on boot and Samba based network file deletions tend to freeze
the client Windows machine's file explorer.
It only takes 3-6 months and/or roughly 10-20 times of the total
disk(s) capacity's worth of write load to get there. Defrag doesn't
seem to help with that but running a balance on each and every
metadata blocks (data and system blocks can be skipped) seems to
"renew" it (no more timeouts or noticeable delays on mount, metadata
operation are as fast as expected, it works like a young
filesystem...).

One might expect that targeting the root subvolume with a recursive
defrag will take care of metadata fragmentation as well but it doesn't
seem to be the case and I don't see anybody recommending regular
matadata balancing.
