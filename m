From: Jason White <jason@jasonjgw.net>
Subject: Re: cp --reflink with Btrfs
Date: Tue, 15 Dec 2009 23:37:42 +0000 (UTC)
Message-ID: <hg96k6$q17$1@ger.gmane.org>
References: <hg1cge$74i$1@ger.gmane.org> <20091214162323.GA2165@localhost.localdomain>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Josef Bacik  <josef@redhat.com> wrote:
>On Sun, Dec 13, 2009 at 12:29:03AM +0000, Jason White wrote:
>> I am testing a Btrfs root file system with Debian (kernel 2.6.32) under KVM.
>> 
>> jason@vrtl:~$ touch testfile
>> jason@vrtl:~$ cp --reflink testfile /tmp
>> cp: failed to clone `/tmp/testfile': Invalid argument
>> 
>> This is with GNU Coreutils 8.0 taken from debian Sid.
>> 
>> Is this a Coreutils issue, a Btrfs problem or something in my local
>> configuration?
>>
>
>Try using bcp, if that works then its likely a problem with coreutils.

After reporting this to Debian and engaging on follow-up discussion, it turns
out that bcp copies the data if the ioctl() call to clone the file fails, as
can be seen from the Python code (which I should have read, but didn't...).

Unfortunately the ioctl() call is failing both in bcp and in cp --reflink.

Here's partial strace output from the latter.

cp --reflink testfile testfile2

open("testfile", O_RDONLY)              = 3
fstat(3, {st_mode=S_IFREG|0644, st_size=0, ...}) = 0
open("testfile2", O_WRONLY|O_CREAT|O_EXCL, 0644) = 4
fstat(4, {st_mode=S_IFREG|0644, st_size=0, ...}) = 0
ioctl(4, 0x40049409, 0x3)               = -1 EINVAL (Invalid argument)

Kernel 2.6.32 (debian Sid), x86-64 architecture.

Suggestions welcome.

Debian bug report:
http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=561225


