Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f181.google.com ([209.85.223.181]:53395 "EHLO
        mail-io0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751620AbdJaN7K (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 31 Oct 2017 09:59:10 -0400
Received: by mail-io0-f181.google.com with SMTP id 189so35285091iow.10
        for <linux-btrfs@vger.kernel.org>; Tue, 31 Oct 2017 06:59:10 -0700 (PDT)
Subject: Re: btrfs-subv-backup v0.1b
To: "Lentes, Bernd" <bernd.lentes@helmholtz-muenchen.de>,
        Btrfs ML <linux-btrfs@vger.kernel.org>
References: <cc9e6302-125b-b120-cc45-35a2e12a3d6a@gmail.com>
 <973325765.400970.1509453637439.JavaMail.zimbra@helmholtz-muenchen.de>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <a9accdcd-9f0a-86a2-64a9-faaf19d882cd@gmail.com>
Date: Tue, 31 Oct 2017 09:59:05 -0400
MIME-Version: 1.0
In-Reply-To: <973325765.400970.1509453637439.JavaMail.zimbra@helmholtz-muenchen.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2017-10-31 08:40, Lentes, Bernd wrote:
> 
> 
> ----- Am 26. Okt 2017 um 15:32 schrieb Austin S. Hemmelgarn ahferroin7@gmail.com:
> 
>> As previously mentioned on the list, I've written up a script to back up
>> BTRFS subvolume structures in regular file-based backups.  As of right
>> now, it's still a bit rough around the edges, but it's cleaned up enough
>> that I consider it of at least beta quality, and therefore fit for more
>> general testing (and possibly usage).   Aside from the issues and
>> limitations listed below in the README, error checking is still somewhat
>> lacking, and I plan to remedy that in the near future.
>>
>> The script itself can be found here:
>> https://github.com/Ferroin/btrfs-subv-backup
>>
>> Here's the official README, as that already covers pretty much
>> everything else I would put in this e-mail:
>>
>> # btrfs-subv-backup v0.1b
>> btrfs-subv-backup is a tool for recording the layout of subvolumes on
>> a mounted BTRFS filesystem in a way that can be stored in a regular
>> file-based backup (for example, using tar).  It originated out of a lack
>> of such existing tools, and is intended to be as portable as reasonably
>> possible.  As a result, it depends on nothing beyond a working
>> installation of Python version 3.4 or higher.
>>
>> btrfs-subv-backup is licensed under a BSD-style license, check the
>> LICENSE file or the docstring for more information.
>>
>> ### Usage
>> Usage is extremely simple.  To generate a backup of a given mount
>> point, run:
>>
>> `btrfs-subv-backup.py /path`
>>
>> This will create a file called `.btrfs-subv-backup.json` in the root of
>> the mount point, make sure that gets included in any backups you run of
>> the mount point.
>>
>> To restore the subvolumes in a filesystem after you've extracted a backup
>> of the mount point, run:
>>
>> `btrfs-subv-backup.py --restore /path`
>>
>> This will recreate the subvolume structure.
>>
>> If you need to manually recreate the subvolumes, you can find a list
>> of them in the aforementioned JSON file under the 'subvolumes' key (the
>> other keys store info about the filesystem itself to make it easier to
>> figure out what it was).
>>
>> ### Limitations and Known Issues
>> * We don't store information about reflinks.  This means in particular
>> that snapshot relationships __ARE NOT__ saved.  There is currently no
>> way to store this data reliably short of a block-level backup, which
>> has it's own special issues.
>> * Subvolumes with spaces in their name are not supported.
>> * There is currently no indication of progress.
>> * The restoration process may take a long time, and may use a very large
>> amount of disk space.  Ideally this should be fixed, but I'm not sure
>> of any way to do so while keeping things on-line.
>> * The current restoration process is all-or-nothing, things are not
>> correctly handled if some of the subvolumes have already been restored
>> (although btrfs-subv-backup will clean up the temporary subvolumes it
>> creates during the restore if the restore fails).  This should be pretty
>> easy to fix, I just haven't gotten around to it yet.
>> * btrfs-subv-backup won't cross actual mount points, which means it
>> won't recurse into explicitly mounted subvolumes.  This makes usage a
>> bit more complicated on some distributions (such as SLES and OpenSUSE),
>> but greatly simplifies the code.
> 
> Hi Austin,
> 
> thanks for your effort. What are the minimum prerequesties for kernel and btrfsprogs for that script ?
> Do you think it will run on my old SLES 11 SP4 ?
Dependency-wise, it needs:

kernel: Should work with any kernel version that has BTRFS support, 
untested on kernels before 4.10, but I'm fairly confident that it should 
work on just about anything.  If there's going to be a failure due to 
kernel version, it should happen when saving the subvolume information, 
so you should be safe checking this (especially since the script doesn't 
write anything when saving the info until the very end, and doesn't use 
any write capable ioctls when fetching the info).

btrfs-progs: Only uses the subvolume list, create, and delete commands, 
and the only one which may have changed significantly in the past few 
years is the list command.  I've only tested it with btrfs-progs 4.10.2 
and newer, but I expect it should work with any of them at least since 
the change to matching kernel versions.  You can quickly check this by 
making sure the output of `btrfs subvolume list` looks like this:

     ID 257 gen 769304 top level 5 path root

What matters there is the number of words between each number, as the 
parsing code is pretty naive.

util-linux: We use blkid to get the filesystem label and UUID so that 
it's more evident in the file what filesystem it's for (in case you 
decide to stroe them separately), but as far as I know the relevant 
command-line options haven't changed in at least half a decade, so any 
reasonably recent version should work fine (tested with util-linux 
2.31).  As the script is currently, this will cause it to throw an 
exception if it doesn't work, but that will happen before it does almost 
anything else, so it should still fail safe.

Python: btrfs-subv-backup requires Python 3.  I've only tested it on 3.4 
and 3.6, but I'm pretty sure it should work on most versions back to at 
least 3.2.  Of the dependencies, this is the one I'd expect to be the 
most likely possible issue on older distros, but you likely have a new 
enough version already given the kernel build date shown below.  If this 
doesn't work, you will get syntax errors (specifically around the error 
handlers).

I've been slowly updating things to improve the script too, I'll make 
sure to get this info into the README before I post the most recent version.
> 
> ha-idg-1:~ # rpm -qa|grep -i btrfs
> btrfsprogs-3.18.2-0.40.48
> btrfsmaintenance-0.1-3.1
> libbtrfs0-3.18.2-0.40.48
> 
> ha-idg-1:~ # uname -a
> Linux ha-idg-1 3.0.101-100-default #1 SMP Tue Apr 18 22:46:01 UTC 2017 (ce95309) x86_64 x86_64 x86_64 GNU/Linux
>
