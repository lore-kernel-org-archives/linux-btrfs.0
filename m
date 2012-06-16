Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.187]:58869 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756540Ab2FPLqu (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 16 Jun 2012 07:46:50 -0400
Message-ID: <4FDC71FD.2080002@brockmann-consult.de>
Date: Sat, 16 Jun 2012 13:46:05 +0200
From: Peter Maloney <peter.maloney@brockmann-consult.de>
MIME-Version: 1.0
To: Hugo Mills <hugo@carfax.org.uk>, Andrei Popa <ierdnah@gmail.com>,
        rupert THURNER <rupert.thurner@gmail.com>, linux-btrfs@vger.kernel.org
Subject: Re: cannot remove files: "rm" gives "no space left on device", 3.2.0-24,
 ubuntu
References: <CAJs9aZ9gsM-hcH-YJpgN6f_YEHrcdJfm808TuCLRKWd1qEGXwg@mail.gmail.com> <1339845495.1544.12.camel@ierdnac-hp> <20120616112657.GH28932@carfax.org.uk>
In-Reply-To: <20120616112657.GH28932@carfax.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

You most likely need to run the "rm" commands as root, so it can use the
reserved space instead of "no space left". When you use "rm" it needs to
COW some metadata, but root should have space for that.


On 06/16/2012 01:26 PM, Hugo Mills wrote:
> On Sat, Jun 16, 2012 at 02:18:15PM +0300, Andrei Popa wrote:
>> https://btrfs.wiki.kernel.org/index.php/FAQ#Help.21_I_ran_out_of_disk_space.21
>    Also, please note the top box on
>
> https://btrfs.wiki.kernel.org/index.php/Getting_started
>
>    It may help, or it may not, but it's worth doing anyway.
>
>    Hugo.
>
>> On Sat, 2012-06-16 at 13:16 +0200, rupert THURNER wrote:
>>> how would i be able to delete something off this btrfs partition
>>> again? i saw the following messages in the archives which seem to be a
>>> little similar ... except a reboot and therfor a remount did not help:
>>> * http://article.gmane.org/gmane.linux.kernel/1265666/match=enospc
>>>
>>> rt@tv:~$ rm -rf /media/388gb-data/.Trash-1000/info/foto.trashinfo
>>> rm: cannot remove `/media/388gb-data/.Trash-1000/info/foto.trashinfo':
>>> No space left on device
>>>
>>> rt@tv:~$ btrfs filesystem df /media/388gb-data/
>>> Data: total=260.59GB, used=254.56GB
>>> System: total=32.00MB, used=24.00KB
>>> Metadata: total=128.00GB, used=120.01GB
>>>
>>> rt@tv:~$ sudo btrfs filesystem show /dev/sda6
>>> failed to read /dev/sr0
>>> Label: '388gb-data'  uuid: 19223a9e-7840-4798-8ee4-02b5bf9c2899
>>> 	Total devices 1 FS bytes used 374.56GB
>>> 	devid    1 size 388.62GB used 388.62GB path /dev/sda6
>>>
>>> rt@tv:~$ uname -a
>>> Linux tv 3.2.0-24-generic #39-Ubuntu SMP Mon May 21 16:51:22 UTC 2012
>>> i686 i686 i386 GNU/Linux
>>>
>>> the only snapshot is the one created during converting from ext4:
>>> $ sudo btrfs subvolume list /media/388gb-data/
>>> ID 256 top level 5 path ext2_saved
>>>
>>>
>>> open("/usr/lib/locale/locale-archive", O_RDONLY|O_LARGEFILE|O_CLOEXEC) = 3
>>> fstat64(3, {st_mode=S_IFREG|0644, st_size=4480528, ...}) = 0
>>> mmap2(NULL, 262144, PROT_READ, MAP_PRIVATE, 3, 0x2bd) = 0xb7553000
>>> mmap2(NULL, 4096, PROT_READ, MAP_PRIVATE, 3, 0x43a) = 0xb7552000
>>> close(3)                                = 0
>>> ioctl(0, SNDCTL_TMR_TIMEBASE or TCGETS, {B38400 opost isig icanon echo ...}) = 0
>>> lstat64("/", {st_mode=S_IFDIR|0755, st_size=4096, ...}) = 0
>>> fstatat64(AT_FDCWD,
>>> "/media/388gb-data/.Trash-1000/info/foto.trashinfo",
>>> {st_mode=S_IFREG|0644, st_size=56, ...}, AT_SYMLINK_NOFOLLOW) = 0
>>> unlinkat(AT_FDCWD,
>>> "/media/388gb-data/.Trash-1000/info/foto.trashinfo", 0) = -1 ENOSPC
>>> (No space left on device)
>>> open("/usr/share/locale/locale.alias", O_RDONLY|O_CLOEXEC) = 3
>>> fstat64(3, {st_mode=S_IFREG|0644, st_size=2570, ...}) = 0
>>> mmap2(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1,
>>> 0) = 0xb7551000
>>> read(3, "# Locale name alias data base.\n#"..., 4096) = 2570
>>> read(3, "", 4096)                       = 0
>>> close(3)                                = 0
>>> munmap(0xb7551000, 4096)                = 0
>>> open("/usr/share/locale/en/LC_MESSAGES/coreutils.mo", O_RDONLY) = -1
>>> ENOENT (No such file or directory)
>>> open("/usr/share/locale-langpack/en/LC_MESSAGES/coreutils.mo", O_RDONLY) = 3
>>> fstat64(3, {st_mode=S_IFREG|0644, st_size=619, ...}) = 0
>>> mmap2(NULL, 619, PROT_READ, MAP_PRIVATE, 3, 0) = 0xb7551000
>>> close(3)                                = 0
>>> write(2, "rm: ", 4rm: )                     = 4
>>> write(2, "cannot remove `/media/388gb-data"..., 65cannot remove
>>> `/media/388gb-data/.Trash-1000/info/foto.trashinfo') = 65
>>> open("/usr/share/locale/en/LC_MESSAGES/libc.mo", O_RDONLY) = -1 ENOENT
>>> (No such file or directory)
>>> open("/usr/share/locale-langpack/en/LC_MESSAGES/libc.mo", O_RDONLY) =
>>> -1 ENOENT (No such file or directory)
>>> write(2, ": No space left on device", 25: No space left on device) = 25
>>> write(2, "\n", 1
>>> )                       = 1
>>> _llseek(0, 0, 0xbfe0d210, SEEK_CUR)     = -1 ESPIPE (Illegal seek)
>>> close(0)                                = 0
>>>
>>>
>>> rupert

