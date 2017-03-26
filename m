Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from len.romanrm.net ([195.154.117.182]:58578 "EHLO len.romanrm.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751227AbdCZJOb (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 26 Mar 2017 05:14:31 -0400
Date: Sun, 26 Mar 2017 14:14:36 +0500
From: Roman Mamedov <rm@romanrm.net>
To: "J. Hart" <jfhart085@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: backing up a file server with many subvolumes
Message-ID: <20170326141436.4ffffca9@natsu>
In-Reply-To: <58D72EC4.9020101@gmail.com>
References: <58D72EC4.9020101@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, 25 Mar 2017 23:00:20 -0400
"J. Hart" <jfhart085@gmail.com> wrote:

> I have a Btrfs filesystem on a backup server.  This filesystem has a 
> directory to hold backups for filesystems from remote machines.  In this 
> directory is a subdirectory for each machine.  Under each machine 
> subdirectory is one directory for each filesystem (ex /boot, /home, etc) 
> on that machine.  In each filesystem subdirectory are incremental 
> snapshot subvolumes for that filesystem.  The scheme is something like 
> this:
> 
> <top>/backup/<machine>/<filesystem>/<many snapshot subvolumes>
> 
> I'd like to try to back up (duplicate) the file server filesystem 
> containing these snapshot subvolumes for each remote machine.  The 
> problem is that I don't think I can use send/receive to do this. "Btrfs 
> send" requires "read-only" snapshots, and snapshots are not recursive as 
> yet.  I think there are too many subvolumes which change too often to 
> make doing this without recursion practical.

You could have done time-based snapshots on the top level (for /backup/), say,
every 6 hours, and keep those for e.g. a month. Then don't bother with any
other kind of subvolumes/snapshots on the backup machine, and do backups from
remote machines into their respective subdirectories using simple 'rsync'.

That's what a sensible scheme looks like IMO, as opposed to a Btrfs-induced
exercise in futility that you have (there are subvolumes? must use them for
everything, even the frigging /boot/; there is send/receive? absolutely must
use it for backing up; etc.)

-- 
With respect,
Roman
