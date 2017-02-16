Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f50.google.com ([209.85.214.50]:35822 "EHLO
        mail-it0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933086AbdBPUsE (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 16 Feb 2017 15:48:04 -0500
Received: by mail-it0-f50.google.com with SMTP id 203so115108211ith.0
        for <linux-btrfs@vger.kernel.org>; Thu, 16 Feb 2017 12:48:04 -0800 (PST)
Subject: Re: man filesystems(5) doesn't contain Btrfs
To: Chris Murphy <lists@colorremedies.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
References: <CAJCQCtSo7nrgU4jkr85vm+4S9iwyoLF_USjZ4DTbd__-a62qGg@mail.gmail.com>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <46520c5e-1c83-efaf-fc3f-a4af4810eb88@gmail.com>
Date: Thu, 16 Feb 2017 15:47:58 -0500
MIME-Version: 1.0
In-Reply-To: <CAJCQCtSo7nrgU4jkr85vm+4S9iwyoLF_USjZ4DTbd__-a62qGg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2017-02-16 15:36, Chris Murphy wrote:
> Hi,
>
> This man page contains a list for pretty much every other file system,
> with a oneliner description: ext4, XFS is in there, and even NTFS, but
> not Btrfs.
>
> Also, /etc/filesystems doesn't contain Btrfs. Anyone know if either,
> or both, ought to contain an entry for Btrfs?
>
The man-page absolutely should.  Ideally, that should be kept in sync 
with with the mount manpages, but I think they're in separate projects 
(mount is util-linux IIRC, while filesystems(5) is part of the Linux 
man-pages project).

As far as /etc/filesystems, that should be irrelevant.  Of the big 
distros, only SUSE, Fedora/CentOS/OEL, and Gentoo use it (I checked 
Arch, Gentoo, openSUSE, Fedora, Debian, and Ubuntu, which should cover 
at least 80% of users since this is low enough level derivatives won't 
be likely to change it), and all it does is dictate what order 'mount -t 
auto' will try filesystem types in.  All the distros that have it have a 
'*' on the last line, which means to check /proc/filesystems, and 
therefore will automatically try BTRFS if there's a kernel module for it 
(unless the module is blacklisted or prevented from being loaded on boot 
automatically).
