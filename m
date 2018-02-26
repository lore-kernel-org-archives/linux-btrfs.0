Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:40680 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753053AbeBZNBP (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 26 Feb 2018 08:01:15 -0500
Subject: Re: btrfs_clone_files and bind mounts
To: Hristo Venev <hristo@venev.name>, linux-btrfs@vger.kernel.org
References: <1519141810.8586.4.camel@venev.name>
 <2ce8eab1-8951-a1c7-d4fa-5f4f3201923d@suse.com>
 <1519646493.12248.7.camel@venev.name>
Cc: amir73il@gmail.com
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <4b9de5cb-1366-a95c-118c-7b57042bf32e@suse.com>
Date: Mon, 26 Feb 2018 15:01:13 +0200
MIME-Version: 1.0
In-Reply-To: <1519646493.12248.7.camel@venev.name>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

[CCing Amir since he touched precisely the code responsible for this
semantics]

On 26.02.2018 14:01, Hristo Venev wrote:
> On Tue, 2018-02-20 at 18:41 +0200, Nikolay Borisov wrote:
>>
>> On 20.02.2018 17:50, Hristo Venev wrote:
>>> What is the problem with cloning files between different
>>> (vfs)mounts of
>>> the same filesystem?
>>>
>>
>> The "problem" is not really a problem, but rather a well-imposed
>> restriction:
>>
>> From  http://man7.org/linux/man-pages/man2/ioctl_ficlonerange.2.html
>>
>> "Both files must reside within the same filesystem."
>>
>> And as a matter of fact this is enforced in the generic
>> vfs_clone_file_range. Of course if we were to do this across
>> filesystem
>> then we'd have all the problems associated with not being able to
>> ensure
>> atomicity of operations.
> 
> My question was about doing this within the same filesystem. In my case
> (and I think it's relatively common), subvolumes of the same filesystem
> are mounted separately, and I can't think of a good reason why
> FICLONERANGE can't be made to work (it works if the subvolumes are
> accessed within the same mount point).
> 

So Amir,

In 913b86e92e1f ("vfs: allow vfs_clone_file_range() across mount
points") you did relax the requirements of vfs_clone_file_range by
moving the mount point check into ioctl_file_clone. In btrfs we can have
a situation where multiple subvolumes, belonging to the same FS are at
different mountpoint I.e. :

mount /dev/vdc /media/scratch/
echo "test file" >> /media/scratch/foo

btrfs subvolume create /media/scratch/subvol1

btrfs subvolume list /media/scratch/
   ID 257 gen 7 top level 5 path subvol1

mount -osubvolid=257 /dev/vdc /media/subvol-mount/

cp --reflink=always /media/scratch/foo /media/subvol-mount/foo-reflink

cp: failed to clone '/media/subvol-mount/foo-reflink' from
'/media/scratch/foo': Invalid cross-device link


Shouldn't reflinking be allowed in this case? ftrace shows that we are
failing "if (src_file.file->f_path.mnt != dst_file->f_path.mnt)" in
ioctl_file_clone


In your commit you state:

FICLONE/FICLONERANGE ioctls enforce that src and dest files are on
 the same mount.

Whereas the man page says they should be on the same filesystem (not
necessarily on the same mount?)
