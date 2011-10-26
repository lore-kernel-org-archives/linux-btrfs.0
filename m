From: Kai Krakow <hurikhan77+btrfs@gmail.com>
Subject: Re: linux v3.1 with btrfs-work: oops when deleting files
Date: Wed, 26 Oct 2011 19:40:22 +0200
Message-ID: <CAMthOuNq2E+sQxmkTBHUbiPyPCthVKsSaZTo1hVV1rgOb9NJqQ@mail.gmail.com>
References: <6mrhn8-b6u.ln1@hurikhan.ath.cx>
	<4EA7D478.8030106@parallels.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4EA7D478.8030106@parallels.com>
List-ID: <linux-btrfs.vger.kernel.org>

Hello!

2011/10/26 dima <dolenin@parallels.com>:
>> I'm trying to rm some files, this is what I get in dmesg:
[snip]
>
> Can you ls the directory where the problem files are located? What would the
> the output? I had a very similar problem but on 3.0.x kernel when several
> files suddenly got corrupted.

I can run "find -type f" for directories I suspect corrupted files in,
and I see errors in dmesg if it happens to contain bad files. But no
oopses and the system remains stable. If I mount the filesystem
read-only I can even read these files without oopses, this way I
produced an rsync backup to my original partition I created the btrfs
subvolume from.

But since I do not have enough capacity to hold both my original
backup (home files only, the system is already outdated) and the
complete btrfs system (combined multiple partitions from an lvm setup
into one btrfs volume with subvolumes) I cannot just recreate the same
file system from scratch. Looks like I have to buy another hard disk
(going to become expensive soon anyway) and rsync over to a fresh
btrfs. This includes a added bonus of trying out btrfs striping.
Awful, that's going to take about 30 hours again... :-(

I'd like to contribute fixing these bugs but I'm starting to need a
fully running system again with all my data.

All I can say: My files got suddenly corrupted after trying to "cp
--reflink" a VMware player disk image (several gigabytes). I wanted to
do this to easily go back to the original state of the VM but instead
my system started thrashing the hard disk and after some minutes the
cp command returned with an out-of-memory error. From then on, more
and more programs just froze (Chromium being the first) and I could no
longer open terminals ("failed to start bash" after a couple of
seconds). I was able to see oops traces in dmesg in one terminal but
wasn't able to capture it somewhere because I could not log in with
ssh, neither I could create files (all processes froze in disk state,
not killable). So I did a hard reboot with REISUB.

Regards,
Kai
