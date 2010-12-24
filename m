From: Li Zefan <lizf@cn.fujitsu.com>
Subject: Re: [GIT PULL][PATCH v2 0/6] btrfs: Add lzo compression support
Date: Fri, 24 Dec 2010 14:55:53 +0800
Message-ID: <4D1443F9.4040001@cn.fujitsu.com>
References: <4CE48ABB.5070302@cn.fujitsu.com> <AANLkTi=jGNaV-Sm+GsCHtwGx1UkG8bUyvGgz+2KLPgUT@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Chris Mason <chris.mason@oracle.com>,
	Mitch Harder <mitch.harder@sabayonlinux.org>,
	linux-btrfs@vger.kernel.org
To: cwillu <cwillu@cwillu.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <AANLkTi=jGNaV-Sm+GsCHtwGx1UkG8bUyvGgz+2KLPgUT@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

cwillu wrote:
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
> 
> This doesn't seem to work with -o remount.  "mount / -o
> remount,compress=lzo" fails with "[90192.345382] btrfs: unrecognized
> mount option 'compress=lzo'".  The -clzo option to defrag works fine.
> 

It works for me:

# mount -t btrfs -o compress=zlib /dev/loop1 /mnt
# mount -o remount,compress=lzo /dev/loop1 /mnt
# dmesg
...
device fsid c142fef10429f78f-540f99158993f7a2 devid 1 transid 31 /dev/loop1
btrfs: use zlib compression
btrfs: use lzo compression
