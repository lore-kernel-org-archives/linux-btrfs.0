From: Li Zefan <lizf@cn.fujitsu.com>
Subject: Re: [GIT PULL][PATCH v2 0/6] btrfs: Add lzo compression support
Date: Tue, 30 Nov 2010 09:00:05 +0800
Message-ID: <4CF44C95.6020908@cn.fujitsu.com>
References: <4CE48ABB.5070302@cn.fujitsu.com> <AANLkTin4VPOXBOU9fM5CVqSSnwMMrUCoDqoYu5mKWXLL@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Chris Mason <chris.mason@oracle.com>,
	Mitch Harder <mitch.harder@sabayonlinux.org>,
	linux-btrfs@vger.kernel.org
To: C Anthony Risinger <anthony@extof.me>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <AANLkTin4VPOXBOU9fM5CVqSSnwMMrUCoDqoYu5mKWXLL@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

C Anthony Risinger wrote:
> On Wed, Nov 17, 2010 at 8:08 PM, Li Zefan <lizf@cn.fujitsu.com> wrote:
>> Hi Chris,
>>
>> Here's the updated patchset. As I still haven't got a kernel.org
>> account, I have set up a git tree in another public git repository,
>> and I'll use it for now.
>>
>> You can pull from:
>>
>>        git://repo.or.cz/linux-btrfs-devel.git lzo-support
>>
>>
>> Lzo is a much faster compression algorithm than gzib, so would allow
>> more users to enable transparent compression, and some users can
>> choose from compression ratio and compression speed.
>>
>> Usage:
>>
>> # mount -t btrfs -o compress[=<zlib,lzo>] dev /mnt
>> or
>> # mount -t btrfs -o compress-force[=<zlib,lzo>] dev /mnt
>>
>> "-o compress" without argument is still allowed for compatability.
>>
>> Compatibility:
>>
>> If we mount a filesystem with lzo compression, it will not be able be
>> mounted in old kernels. One reason is, otherwise btrfs will directly
>> dump compressed data, which sits in inline extent, to user.
>>
>> Performance:
>>
>> The test copied a linux source tarball (~400M) from an ext4 partition
>> to the btrfs partition, and then extracted the tarball.
>>
>> (time in second)
>>           lzo        zlib        nocompress
>> copy:      10.6       21.7        14.9
>> extract:   70.1       94.4        66.6
>>
>> (data size in MB)
>>           lzo        zlib        nocompress
>> copy:      185.87     108.69      394.49
>> extract:   193.80     132.36      381.21
>>
>> Test:
>>
>> Mitch has tested the patchset, and provided some positive feedback.
>> According to him, the patchset works as expected and nothing bad
>> has he experienced.
>>
>> Other:
>>
>> The defrag ioctl is also updated, so one can choose lzo or zlib when
>> turning on compression in defrag operation.
>>
>> Main change from v1:
>>
>> - Add incompat flag.
>> - Fix build issue by selecting kernel lzo module.
>> - Check compression type in defrag ioctl.
>>
>> ---------------->
>> Li Zefan (6):
>>      btrfs: Fix bugs in zlib workspace
>>      btrfs: Fix error handling in zlib
>>      btrfs: Allow to add new compression algorithm
>>      btrfs: Add lzo compression support
>>      btrfs: Allow to specify compress method when defrag
>>      btrfs: Extract duplicate decompress code
>>
>>  fs/btrfs/Makefile       |    2 +-
>>  fs/btrfs/btrfs_inode.h  |    2 +-
>>  fs/btrfs/compression.c  |  329 +++++++++++++++++++++++++++++++++++++-
>>  fs/btrfs/compression.h  |   72 ++++++--
>>  fs/btrfs/ctree.h        |   11 +-
>>  fs/btrfs/extent_io.c    |    5 +-
>>  fs/btrfs/extent_io.h    |   17 ++-
>>  fs/btrfs/extent_map.c   |    2 +
>>  fs/btrfs/extent_map.h   |    3 +-
>>  fs/btrfs/file.c         |    2 +
>>  fs/btrfs/inode.c        |   82 ++++++----
>>  fs/btrfs/ioctl.c        |   10 +-
>>  fs/btrfs/ioctl.h        |    9 +-
>>  fs/btrfs/lzo.c          |  409 +++++++++++++++++++++++++++++++++++++++++++++++
>>  fs/btrfs/ordered-data.c |   18 ++-
>>  fs/btrfs/ordered-data.h |    8 +-
>>  fs/btrfs/super.c        |   47 +++++-
>>  fs/btrfs/zlib.c         |  361 +++++++----------------------------------
>>  18 files changed, 1013 insertions(+), 376 deletions(-)
> 
> is this in a branch somewhere?  or for inclusion in .37/.38?  this is
> a very attractive feature.
> 
> what's the proper place (repo/branch) to see what is pending?
> 

As a new feature, it's too late for .37. Hope to see it merged in .38
merge window.

Chris' btrfs-unstable git tree is the "official" place to see what is
pending, but just he hasn't picked up those patches, so for now it
only sits in my own tree.
