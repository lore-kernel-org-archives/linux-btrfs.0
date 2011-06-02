From: "Fajar A. Nugraha" <list@fajar.net>
Subject: Re: btrfs error after using kernel 3.0-rc1
Date: Thu, 2 Jun 2011 08:14:39 +0700
Message-ID: <BANLkTikc2215UFZjer0NaU6XzPw1m_bOEA@mail.gmail.com>
References: <BANLkTimGPgn9CERxCNQPqJLTiRkFUc03OA@mail.gmail.com>
	<BANLkTinP-Rit3tc2HRDx4d2WArkxqUBuug@mail.gmail.com>
	<1306964572-sup-4244@shiny>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1306964572-sup-4244@shiny>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jun 2, 2011 at 4:48 AM, Chris Mason <chris.mason@oracle.com> wr=
ote:
> Excerpts from Fajar A. Nugraha's message of 2011-06-01 08:22:40 -0400=
:
>> On Wed, Jun 1, 2011 at 6:06 AM, Fajar A. Nugraha <list@fajar.net> wr=
ote:
>> > While using btrfs as root on kernel 3.0-rc1, there was some errors=
 (I
>> > wasn't able to capture the error) that forced me to do hard reset.
>> >
>> > Now during startup system drops to busybox shell because it's unab=
le
>> > to mount root partition.

>> For anyone who got the same problem,
>>
>> I was finally able to mount the fs using Ubuntu Natty's
>> 2.6.38-8-generic (the one on live CD).

> The tools have a command to zero out the btrfs log tree, that would h=
ave
> allowed you to mount.

Do you mean btrfs-zero-log?
It's not compiled by default, is it? I didn't know about that until I
read another thread that mentions it, and by that time I was already
able to mount it.

> =A0Do you still have the busted FS?

Yup. Made an image, put it in an external disk (which also use btrfs),
and created a snapshot.

Here's what I get using btrfs-progs-unstable tmp branch:

$ btrfsck sda2.img
parent transid verify failed on 44040192 wanted 38240 found 32526
parent transid verify failed on 44040192 wanted 38240 found 32526
parent transid verify failed on 44052480 wanted 38240 found 31547
parent transid verify failed on 44052480 wanted 38240 found 31547
parent transid verify failed on 44064768 wanted 38240 found 34145
parent transid verify failed on 44064768 wanted 38240 found 34145
parent transid verify failed on 44068864 wanted 38240 found 34476
parent transid verify failed on 44068864 wanted 38240 found 34476
leaf parent key incorrect 44032000
bad block 44032000
warning, start mismatch 10833383424 10833408000
Aborted


$ btrfs-zero-log sda2.img
parent transid verify failed on 44040192 wanted 38240 found 32526
parent transid verify failed on 44040192 wanted 38240 found 32526
parent transid verify failed on 44052480 wanted 38240 found 31547
parent transid verify failed on 44052480 wanted 38240 found 31547
parent transid verify failed on 44064768 wanted 38240 found 34145
parent transid verify failed on 44064768 wanted 38240 found 34145
parent transid verify failed on 44068864 wanted 38240 found 34476
parent transid verify failed on 44068864 wanted 38240 found 34476


After that the filesystem is mountable again, although syslog still
shows this entry:
Jun  2 07:50:26 HP kernel: [ 2095.290057] parent transid verify failed
on 44032000 wanted 38240 found 24586


When copying some of the files, these logs appear on syslog (the same
logs appear whether I use the image mounted on kernel
2.6.38-9-generic, or the one fixed with btrfs-zero-log):
Jun  2 07:50:26 HP kernel: [ 2095.756842] btrfs no csum found for
inode 61485 start 743616512
Jun  2 07:50:26 HP kernel: [ 2095.756950] btrfs csum failed ino 61485
extent 23713038336 csum 1645309641 wanted 0 mirror 1

What does "wanted 0" mean here?

During the copy of that particular file, the system would consistently
lockup at some point (there was no call trace availabe). I was able to
copy it with the help of "mount -o nodatasum,ro" and "rsync --append".
This particular file also appears undamaged (it's a Virtualbox disk
image, and the OS & application on it ran fine).


It'd be great if we can find out what's causing these errors, but for
the time being I'm happy enough to get my data back :D

Thanks,

=46ajar
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
