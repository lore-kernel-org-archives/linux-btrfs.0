Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f173.google.com ([209.85.213.173]:33938 "EHLO
	mail-ig0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755732AbcCURWI (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 21 Mar 2016 13:22:08 -0400
Received: by mail-ig0-f173.google.com with SMTP id av4so88906526igc.1
        for <linux-btrfs@vger.kernel.org>; Mon, 21 Mar 2016 10:22:07 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20160321152144.GL8544@smitten>
References: <20160321152144.GL8544@smitten>
Date: Mon, 21 Mar 2016 11:22:06 -0600
Message-ID: <CAJCQCtTxMqZ_RGbXko0CLiYNJJ8U88i8F3UAs1h2X8nQNXHGRQ@mail.gmail.com>
Subject: Re: confusing mountinfo output when bind-mounting files
From: Chris Murphy <lists@colorremedies.com>
To: Tycho Andersen <tycho.andersen@canonical.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Mar 21, 2016 at 9:21 AM, Tycho Andersen
<tycho.andersen@canonical.com> wrote:
> Hi all,
>
> I'm seeing some strange behavior when bind mounting files from a btrfs
> subvolume. Consider the output below:
>
> root@criu2:/tmp# mount -o loop /tmp/tester.btrfs /tmp/dir1
> root@criu2:/tmp# touch dir1/file
> root@criu2:/tmp# sudo mount --bind dir1/file dir2/file
> root@criu2:/tmp# grep "/tmp/dir" /proc/self/mountinfo
> 128 24 0:45 / /tmp/dir1 rw,relatime shared:107 - btrfs /dev/loop0 rw,space_cache,subvolid=5,subvol=/
> 129 24 0:45 /file /tmp/dir2/file rw,relatime shared:107 - btrfs /dev/loop0 rw,space_cache,subvolid=5,subvol=/file
> root@criu2:/tmp# btrfs --version
> btrfs-progs v4.4
> root@criu2:/tmp# uname -a
> Linux criu2 4.4.0-8-generic #23-Ubuntu SMP Wed Feb 24 20:45:30 UTC 2016 x86_64 x86_64 x86_64 GNU/Linux
>
> The issue here is that the "subvol=" mount option for the target of the bind
> mount is "/file" when no such subvolume actually exists. Is this
> intended? It's confusing to say the least, but seems like a bug to me.

Since btrfs mount subvol=<name> is a bind mount behind the scene, I'm
not sure the mount info code distinguishes between bind mounts.

At the moment, this is something of a secret decoder ring where if you
see subvolid=5 first, then anything after that other than / is just
not true (can't be). Hence probably why both subvolid and subvol are
listed for now; you kinda have to parse them both.



-- 
Chris Murphy
