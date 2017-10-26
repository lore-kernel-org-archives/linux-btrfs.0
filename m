Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f178.google.com ([209.85.223.178]:56690 "EHLO
        mail-io0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932198AbdJZNcT (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 26 Oct 2017 09:32:19 -0400
Received: by mail-io0-f178.google.com with SMTP id m81so5336638ioi.13
        for <linux-btrfs@vger.kernel.org>; Thu, 26 Oct 2017 06:32:19 -0700 (PDT)
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Cc: "Lentes, Bernd" <bernd.lentes@helmholtz-muenchen.de>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Subject: btrfs-subv-backup v0.1b
Message-ID: <cc9e6302-125b-b120-cc45-35a2e12a3d6a@gmail.com>
Date: Thu, 26 Oct 2017 09:32:13 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

As previously mentioned on the list, I've written up a script to back up 
BTRFS subvolume structures in regular file-based backups.  As of right 
now, it's still a bit rough around the edges, but it's cleaned up enough 
that I consider it of at least beta quality, and therefore fit for more 
general testing (and possibly usage).   Aside from the issues and 
limitations listed below in the README, error checking is still somewhat 
lacking, and I plan to remedy that in the near future.

The script itself can be found here:
https://github.com/Ferroin/btrfs-subv-backup

Here's the official README, as that already covers pretty much 
everything else I would put in this e-mail:

# btrfs-subv-backup v0.1b
btrfs-subv-backup is a tool for recording the layout of subvolumes on
a mounted BTRFS filesystem in a way that can be stored in a regular
file-based backup (for example, using tar).  It originated out of a lack
of such existing tools, and is intended to be as portable as reasonably
possible.  As a result, it depends on nothing beyond a working
installation of Python version 3.4 or higher.

btrfs-subv-backup is licensed under a BSD-style license, check the
LICENSE file or the docstring for more information.

### Usage
Usage is extremely simple.  To generate a backup of a given mount
point, run:

`btrfs-subv-backup.py /path`

This will create a file called `.btrfs-subv-backup.json` in the root of
the mount point, make sure that gets included in any backups you run of
the mount point.

To restore the subvolumes in a filesystem after you've extracted a backup
of the mount point, run:

`btrfs-subv-backup.py --restore /path`

This will recreate the subvolume structure.

If you need to manually recreate the subvolumes, you can find a list
of them in the aforementioned JSON file under the 'subvolumes' key (the
other keys store info about the filesystem itself to make it easier to
figure out what it was).

### Limitations and Known Issues
* We don't store information about reflinks.  This means in particular
that snapshot relationships __ARE NOT__ saved.  There is currently no
way to store this data reliably short of a block-level backup, which
has it's own special issues.
* Subvolumes with spaces in their name are not supported.
* There is currently no indication of progress.
* The restoration process may take a long time, and may use a very large
amount of disk space.  Ideally this should be fixed, but I'm not sure
of any way to do so while keeping things on-line.
* The current restoration process is all-or-nothing, things are not
correctly handled if some of the subvolumes have already been restored
(although btrfs-subv-backup will clean up the temporary subvolumes it
creates during the restore if the restore fails).  This should be pretty
easy to fix, I just haven't gotten around to it yet.
* btrfs-subv-backup won't cross actual mount points, which means it
won't recurse into explicitly mounted subvolumes.  This makes usage a
bit more complicated on some distributions (such as SLES and OpenSUSE),
but greatly simplifies the code.
