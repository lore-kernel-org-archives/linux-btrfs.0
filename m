Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f45.google.com ([209.85.214.45]:35727 "EHLO
        mail-it0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752711AbdC0Lxg (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 27 Mar 2017 07:53:36 -0400
Received: by mail-it0-f45.google.com with SMTP id y18so69678377itc.0
        for <linux-btrfs@vger.kernel.org>; Mon, 27 Mar 2017 04:53:35 -0700 (PDT)
Subject: Re: backing up a file server with many subvolumes
To: jfhart085@gmail.com, linux-btrfs@vger.kernel.org
References: <58D72EC4.9020101@gmail.com>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <f9290eee-b091-b25c-c10a-74ba18b9f6f4@gmail.com>
Date: Mon, 27 Mar 2017 07:53:17 -0400
MIME-Version: 1.0
In-Reply-To: <58D72EC4.9020101@gmail.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2017-03-25 23:00, J. Hart wrote:
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
>
> Any thoughts would be most appreciated.
In general, I would tend to agree with everyone else so far if you have 
to keep your current setup.  Use rsync with the --inplace option to send 
data to a staging location, then snapshot that staging location to do 
the actual backup.

Now, that said, I could probably give some more specific advice if I had 
a bit more info on how you're actually storing the backups.  There are 
three general ways you can do this with BTRFS and subvolumes:
1. Send/receive of snapshots from the system being backed up.
2. Use some other software to transfer the data into a staging location 
on the backup server, then snapshot that.
3. Use some other software to transfer the data, and have it handle 
snapshots instead of using BTRFS, possibly having it create subvolumes 
instead of directories at the top level for each system.

Of the three, I would generally recommend method 2, as it doesn't 
require the remote system to be using BTRFS, and generally scales pretty 
well, and it also amounts to essentially what people are recommending 
you do to backup your backup server.

On the note of needing read-only snapshots, in both cases 1 and 2, your 
snapshots should be read-only on the server (method 1 mandates it, 
method 2 makes it easy).  In case 3, the snapshots should ideally be 
getting marked read-only some other way.  Having backups be writable is 
a bad idea, it leads to too many opportunities for software to screw 
things up, and makes it impossible to tell if you just accidentally 
messed things up, or something went wrong in your backup system or hardware.
