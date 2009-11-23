From: =?ISO-8859-1?Q?P=E1draig_Brady?= <P@draigBrady.com>
Subject: Re: A file cloned with "cp --reflink" different from the original
 one?
Date: Mon, 23 Nov 2009 15:47:22 +0000
Message-ID: <4B0AAE8A.2020900@draigBrady.com>
References: <119341710911230208j5e60734cvf09cfcacd86ba9f6@mail.gmail.com>	
	<4B0A8FC1.4050208@draigBrady.com>
	<119341710911230614h10d7071dq3700cdf39e0c28fb@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: bug-coreutils@gnu.org, linux-btrfs@vger.kernel.org
To: Jian Lin <lj@linjian.org>
Return-path: <bug-coreutils-bounces+gcgcb-bug-coreutils-616=gmane.org@gnu.org>
In-Reply-To: <119341710911230614h10d7071dq3700cdf39e0c28fb@mail.gmail.com>
List-Unsubscribe: <http://lists.gnu.org/mailman/listinfo/bug-coreutils>,
	<mailto:bug-coreutils-request@gnu.org?subject=unsubscribe>
List-Archive: <http://lists.gnu.org/pipermail/bug-coreutils>
List-Post: <mailto:bug-coreutils@gnu.org>
List-Help: <mailto:bug-coreutils-request@gnu.org?subject=help>
List-Subscribe: <http://lists.gnu.org/mailman/listinfo/bug-coreutils>,
	<mailto:bug-coreutils-request@gnu.org?subject=subscribe>
Errors-To: bug-coreutils-bounces+gcgcb-bug-coreutils-616=gmane.org@gnu.org
List-ID: <linux-btrfs.vger.kernel.org>

Jian Lin wrote:
> 2009/11/23 Pádraig Brady <P@draigbrady.com>:
>> Jian Lin wrote:
>>> I installed BtrFS 0.19 and GNU coreutils 8.1 on my Ubuntu 9.10.
>>> I tried to clone some files with "cp --reflink" to make them "copy-on-write".
>>> However, I found some of the files cloned have different MD5s to the
>>> original one.
>>>
>>> Is BtrFS (or cp with reflink) buggy?
>>> Or it is indeed a feature that I used incorrectly?
>>>
>>> Thanks!
>>>
>>> root@lj-laptop:/mnt# uname -a
>>> Linux lj-laptop 2.6.31-15-generic #50-Ubuntu SMP Tue Nov 10 14:54:29
>>> UTC 2009 i686 GNU/Linux
>>>
>>> root@lj-laptop:/mnt# mount | grep btrfs
>>> /dev/sda4 on /mnt type btrfs (rw)
>>>
>>> root@lj-laptop:/mnt# cp --version
>>> cp (GNU coreutils) 8.1
>>>
>>> root@lj-laptop:/mnt# cd WinXP_CHS/
>>> root@lj-laptop:/mnt/WinXP_CHS# cp WinXP_CHS.vmdk WinXP_CHS-ref.vmdk --reflink
>>>
>>> root@lj-laptop:/mnt/WinXP_CHS# ls -la WinXP_CHS.vmdk WinXP_CHS-ref.vmdk
>>> -rwxr-xr-x 1 root root 1713766400 Nov 23 15:11 WinXP_CHS-ref.vmdk
>>> -rwxr-xr-x 1 root root 1713766400 Nov 23 13:32 WinXP_CHS.vmdk
>>>
>>> root@lj-laptop:/mnt/WinXP_CHS# md5sum WinXP_CHS.vmdk WinXP_CHS-ref.vmdk
>>> f6da592d056167a44b089d70fa46f863  WinXP_CHS.vmdk
>>> e3ee0c2c17771811c80eed088c20987d  WinXP_CHS-ref.vmdk
>> Yikes. Are you 100% sure nothing is changing those vm files?
> 
> I think so. I run md5sum immediately after cloning the file.
> 
>> Note I wouldn't 100% trust the mtime, so an md5sum before
>> and after would be good to confirm.
>>
>> You could try this simple prog to do the clones to
>> implicate coreutils or otherwise:
>>
>> #include <sys/ioctl.h>
>> #include <sys/types.h>
>> #include <sys/stat.h>
>> #include <fcntl.h>
>> #include <stdio.h>
>> #define BTRFS_IOC_CLONE 1074041865
>>
>> int main(int argc, const char **argv)
>> {
>>  int in = open(argv[1], O_RDONLY);
>>  int out = open(argv[2], O_CREAT|O_TRUNC|O_WRONLY, 0644);
>>  if (ioctl(out, BTRFS_IOC_CLONE, in)==-1) {
>>      fprintf(stderr, "ioctl error = %m\n");
>>  }
>>  close(in);
>>  close(out);
>>  return 0;
>> }
> 
> I compiled and tried this program.
> ./clone WinXP_CHS.vmdk WinXP_CHS-clone.vmdk
> then I got md5 of WinXP_CHS-clone.vmdk, which is the same as that of
> WinXP_CHS-ref.vmdk (made by cp --reflink), and different from the md5
> of original WinXP_CHS.vmdk.
> 
> The cloned vm cannot run correctly, which said "hal.dll lost". The
> cloned Linux vm I mentioned before also reported "/bin/bash lost".
> Another tiny linux vm I cloned with the same md5 to its original vmdk
> can run correctly.

OK then it sounds like an issue with BTRFS (CC'd)
(which could already be fixed since it's in active development).

cheers,
Pádraig.
