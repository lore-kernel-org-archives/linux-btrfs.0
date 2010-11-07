From: =?windows-1252?Q?Andreas_Bauer?= <ab@voltage.de>
Subject: RE: Kernel 2.6.36 btrfs csum bugreport
Date: Sun, 7 Nov 2010 16:37:09 +0100
Message-ID: <vmime.4cd6c7a5.d26.30bad7833a9ad975@mail.voltage.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Nov 01, 2010 at 12:02:10PM CET, cwillu wrote:

 Ahhhhhhh, and that makes this make sense:
 
 Andreas, have you checked which file(s) are giving the errors?  if
 not, you can use "find /whatever/mountpoint -xdev -inum 5098 -print"
 to get the filename.  And I would bet that it's small enough that it's
 being inlined into the metadata block group, and therefore covered
 under the default "dup" profile of that block group, which is why
 you're getting the actual file data back.

Sorry to disappoint, the files hit are from big (8 GB) to small. I took 
the  opportunity to compare the syslog from both machines I tested on,
and the csum ino and off counters are completely different in each case.

The filesystem which showed this behaviour has now been destoyed, and
in further testing I wasn't able to reproduce the bug.

To summarize:

- a btrfs about 400GB in size showed several csum errors
on reading while the data read was correct. The same thing happened
when the filesystem was mounted on another machine (same kernel).

- the errors could be consistently reproduced by reading enough data. 

- about 60 - 120 csum happened on reading about 250 GB of data.

- the csum error happened to different inodes each time (and each run)

As I don't have enough time at the moment to familiarize myself with
the btrfs code, I have to let go of this issue at this point. Thank 
you for your work.

-- A.B.
