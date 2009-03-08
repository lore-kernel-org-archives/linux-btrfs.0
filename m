From: Yien Zheng <esprout@gmail.com>
Subject: Re: Entirely unexpected ENOSPC?
Date: Sun, 8 Mar 2009 01:32:08 -0600
Message-ID: <2c259a8f0903072332n31d9d20dscad1801b4b468520@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-2
Cc: Josef Bacik <josef@redhat.com>, linux-btrfs@vger.kernel.org
To: Hugo Mills <hugo-lkml@carfax.org.uk>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, 04 Mar 2009 14:48:43 -0600, Hugo Mills <hugo-lkml@carfax.org.uk=
> wrote:

> On Wed, Mar 04, 2009 at 01:50:53PM -0500, Josef Bacik wrote:
>> On Wed, Mar 04, 2009 at 06:06:19PM +0000, Hugo Mills wrote:
>> >    Last night, this event jammed up a good chunk of my server:
>> >
>> > Mar  4 01:51:36 vlad kernel: btrfs searching for 1716224 bytes,
>> num_bytes 1716224, loop 2, allowed_alloc 1
>> > Mar  4 01:51:36 vlad kernel: btrfs searching for 860160 bytes,
>> num_bytes 860160, loop 2, allowed_alloc 1
>> > [lots of this...]
>> > Mar  4 01:55:52 vlad kernel: btrfs searching for 4096 bytes,
>> num_bytes 4096, loop 2, allowed_alloc 1
>> > Mar  4 01:55:52 vlad kernel: btrfs allocation failed flags 1, want=
ed
>> 4096
>> > Mar  4 01:55:52 vlad kernel: space_info has 0 free, is full
>> > Mar  4 01:55:52 vlad kernel: block group 12582912 has 8388608 byte=
s,
>> 8388608 used 0 pinned 0 reserved
>> > Mar  4 01:55:52 vlad kernel: 0 blocks of free space at or bigger t=
han
>> bytes is
>> > Mar  4 01:55:52 vlad kernel: block group 1103101952 has 1073741824
>> bytes, 1073741824 used 0 pinned 0 reserved
>> > Mar  4 01:55:52 vlad kernel: 0 blocks of free space at or bigger t=
han
>> bytes is
>> > [30 more lines of this]
>>
>> So yeah thats expected, you ran out of space.  The key thing is this
>>
>> Mar  4 01:55:52 vlad kernel: space_info has 0 free, is full
>>
>> If space_info has 0 free and is full, then there is no space to
>> allocate for it
>> and its completely used.  I'd recommend switching to the -rc7 kernel
>> since that
>> has things in place to keep this from happening as often.  Thanks,
>
>    I'll do that.
>
>    However, what's confusing me is that the filesystem was reported a=
s
> less than half full (17/41GiB used) at the time that it decided it ha=
d
> no space. Is there any likely explanation for that behaviour?
>
>    I've used btrfsctl to resize it online several times: shrink by
> 1GiB, then enlarge by 12, 10, 10GiB. Might that have been a factor?
>
>    Hugo.
>

I just started playing with btrfs on my SSD drive last week and
encountered the out of space problem using VirtualBox .vdi disks on
the btrfs partition.  I initially used the backport to ubuntu posted
by Filip Br=E8i=E6 with my 2.6.27-7-generic kernel (from Linux Mint 6 K=
DE
CE RC1).

I downloaded and compiled the latest git version ( 2.6.29-rc7) with
the ENOSPC patches, but still run out of disk space quite prematurely.
 With 2.6.27-7 based on btrfs 0.17, I was running out of disk space at
with 1.9G free.  Now with the patched git in 2.6.29-rc7, it's running
out with 1.7G free:

df -h /mnt/btrfs/
=46ilesystem            Size  Used Avail Use% Mounted on
/dev/sdc1              13G   11G  1.7G  87% /mnt/btrfs

This is the same result as from the btrfs unstable repository based on
2.6.29-rc3 which I also tried from git clone
git://git.kernel.org/pub/scm/linux/kernel/git/mason/btrfs-unstable.git.
 It looks like the btrfs code from this repository is identical to
rc7, but I was hoping some other kernel changes in rc7 made the
situation better as Josef implied.

I supposed this is not really an ENOSPC, but it's running out of space
much earlier than I would expect.

Here's my dmesg output:

[  884.445441] no space left, need 8192, 2760704 delalloc bytes,
10717552640 bytes_used, 0 bytes_reserved, 0 bytes_pinned, 0
bytes_readonly, 0 may use10720313344 total
[  912.026372] btrfs searching for 524288 bytes, num_bytes 524288,
loop 2, allowed_alloc 1
[  912.026389] btrfs searching for 262144 bytes, num_bytes 262144,
loop 2, allowed_alloc 1
[  912.026403] btrfs searching for 131072 bytes, num_bytes 131072,
loop 2, allowed_alloc 1
[  912.026426] btrfs searching for 458752 bytes, num_bytes 458752,
loop 2, allowed_alloc 1
[  912.026439] btrfs searching for 229376 bytes, num_bytes 229376,
loop 2, allowed_alloc 1
[...more lines like this]
[ 1363.318175] no space left, need 8192, 81920 delalloc bytes,
10720231424 bytes_used, 0 bytes_reserved, 0 bytes_pinned, 0
bytes_readonly, 0 may use10720313344 total
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
