From: dima <dolenin@parallels.com>
Subject: Re: linux v3.1 with btrfs-work: oops when deleting files
Date: Thu, 27 Oct 2011 16:09:46 +0900
Message-ID: <4EA903BA.6090405@parallels.com>
References: <Bw$+jLhT1uB@helmut.hullen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"; format=flowed
Cc: Helmut Hullen <Hullen@t-online.de>, <linux-btrfs@vger.kernel.org>
To: <helmut@hullen.de>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <Bw$+jLhT1uB@helmut.hullen.de>
List-ID: <linux-btrfs.vger.kernel.org>

On 10/26/2011 07:25 PM, Helmut Hullen wrote:
> Hallo, dima,
>
> Du meintest am 26.10.11:
>
>>> I'm trying to rm some files, this is what I get in dmesg:
>>>
>>> [30975.249519] ------------[ cut here ]------------
>>> [30975.249529] WARNING: at fs/btrfs/extent-tree.c:4588
>>> __btrfs_free_extent+0x3b7/0x7ed()
>
> [...]
>
>>> [30975.249604] Pid: 12291, comm: rm Tainted: G       A C
>>> 3.1.0-00057- gc82b96b-dirty #6
>
>> Can you ls the directory where the problem files are located? What
>> would the the output? I had a very similar problem but on 3.0.x
>> kernel when several files suddenly got corrupted.
>
> This morning I've tried kernel 3.1; you remembder my problems with 1
> disk.
>
>     dd if=/dev/baddisk of=/dev/zero bs=8M conv=noerror
>
> showed some bad sectors.
>
>     hdparm ... --write-sector /dev/baddisk
>
> seems to repair them (I use a loop which not only tests the sector which
> is shown via "dd" but also some sectors around this one)
>
> Rebooting the machine with kernel 3.1: I could delete the old entries
> which seemed to contain bad sectors. Fine.
>
> Running btrfsck from the "Hugo Mills" git branch: still some errors -
> see attachment "btrfsck.txt", especially the last lines; there seems to
> be a bug.
>
> Copying some *.mpg files from another place to the btrfs cluster:
> suddenly the system hangs, "dmesg" shows similar messages as above (from
> Kai Krakow). See second attachment "dmesg-1.txt".
> "halt" doesn't work, "reboot" doesn't work, "ctrl alt delete" doesn't
> work.
>
> Reboot via power switch.
>
> Again copying: there was (within 1 file) a long pause, but then copying
> worked. There's still hope ...
> Maybe the pause caused kernel oops #3 and #4 - see attachment "dmesg-
> 2.txt".
>
> ------------
>
> Just to show the only big difference: now I've seen some problem(s) not
> related to "rm" but to "cp".
>
> Viele Gruesse!
> Helmut


Hi Helmut,

For me any command I tried to use on the corrupted files would give me 
the errors in dmesg, like in your case. And I could not get rid of the 
files in any way. So eventually I had to recreate the subvolume.
I checked my disk at that time, but it did not show any bad sector 
errors, so I concluded it is the FS problem.

In your case it may be just the errors caused by bad sectors on disk. 
But perhaps recreating subvolume would be a good step to find out what 
is wrong.

~d
