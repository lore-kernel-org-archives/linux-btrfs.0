Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qk0-f179.google.com ([209.85.220.179]:33025 "EHLO
	mail-qk0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756944AbcCURvu (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 21 Mar 2016 13:51:50 -0400
Subject: Re: confusing mountinfo output when bind-mounting files
To: Tycho Andersen <tycho.andersen@canonical.com>,
        Chris Murphy <lists@colorremedies.com>
References: <20160321152144.GL8544@smitten>
 <CAJCQCtTxMqZ_RGbXko0CLiYNJJ8U88i8F3UAs1h2X8nQNXHGRQ@mail.gmail.com>
 <20160321172936.GO8544@smitten>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <56F034A0.9070901@gmail.com>
Date: Mon, 21 Mar 2016 13:51:28 -0400
MIME-Version: 1.0
In-Reply-To: <20160321172936.GO8544@smitten>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2016-03-21 13:29, Tycho Andersen wrote:
> On Mon, Mar 21, 2016 at 11:22:06AM -0600, Chris Murphy wrote:
>> On Mon, Mar 21, 2016 at 9:21 AM, Tycho Andersen
>> <tycho.andersen@canonical.com> wrote:
>>> Hi all,
>>>
>>> I'm seeing some strange behavior when bind mounting files from a btrfs
>>> subvolume. Consider the output below:
>>>
>>> root@criu2:/tmp# mount -o loop /tmp/tester.btrfs /tmp/dir1
>>> root@criu2:/tmp# touch dir1/file
>>> root@criu2:/tmp# sudo mount --bind dir1/file dir2/file
>>> root@criu2:/tmp# grep "/tmp/dir" /proc/self/mountinfo
>>> 128 24 0:45 / /tmp/dir1 rw,relatime shared:107 - btrfs /dev/loop0 rw,space_cache,subvolid=5,subvol=/
>>> 129 24 0:45 /file /tmp/dir2/file rw,relatime shared:107 - btrfs /dev/loop0 rw,space_cache,subvolid=5,subvol=/file
>>> root@criu2:/tmp# btrfs --version
>>> btrfs-progs v4.4
>>> root@criu2:/tmp# uname -a
>>> Linux criu2 4.4.0-8-generic #23-Ubuntu SMP Wed Feb 24 20:45:30 UTC 2016 x86_64 x86_64 x86_64 GNU/Linux
>>>
>>> The issue here is that the "subvol=" mount option for the target of the bind
>>> mount is "/file" when no such subvolume actually exists. Is this
>>> intended? It's confusing to say the least, but seems like a bug to me.
>>
>> Since btrfs mount subvol=<name> is a bind mount behind the scene, I'm
>> not sure the mount info code distinguishes between bind mounts.
>>
>> At the moment, this is something of a secret decoder ring where if you
>> see subvolid=5 first, then anything after that other than / is just
>> not true (can't be). Hence probably why both subvolid and subvol are
>> listed for now; you kinda have to parse them both.
>
> Ok, so if I'm trying to compare superblocks from userspace, I should
> look for subvolid and see if those match, and if that isn't present
> then look for subvol?
That depends on what you mean by 'compare superblocks'.

Internal to the kernel, there is exactly one super-block structure 
shared between all mounts of a given BTRFS filesystem, regardless of 
subvolume or bind-mount (the same is actually also true if you mount a 
XFS or ext4 filesystem more than once on the same system), so if you're 
trying to differentiate filesystems, you need to match on something like 
the block device or label.

If however, you're trying to differentiate where something is mounted 
from, you should be matching on both subvolid and subvol (I think, but I 
may be wrong), but that may not always work (I don't use bind mounts of 
BTRFS filesystems often outside of subvolume mounts, so I don't have 
much experience with this particular case).
