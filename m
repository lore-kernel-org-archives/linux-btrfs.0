From: Mitch Harder <mitch.harder@sabayonlinux.org>
Subject: Finding Fragmentation on a Btrfs Volume
Date: Thu, 4 Nov 2010 23:34:16 -0500
Message-ID: <AANLkTik9f5XsbVDCaOyYHLRHhWEUZz+kEmvVoM4cH-cg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

I was Googling around for ways to check fragmentation on Btrfs, and I
came across the 'filefrag' command.

Even though it is a ext2/3 command, it seems to work on Btrfs files
since it uses the FIEMAP ioctl to determine the number of extents.

>From a bash prompt, I found I could examine large sections with something like:

# for file in $(find <PATH/TO/BTRFS/VOL/> -type f); do filefrag
${file}; done | sort -n -k 2 | less

You may want to start with smaller, more discrete portions of a Btrfs
volume, since I ran into stalls running on more populated Btrfs
volumes.

Also, I haven't tested this on any RAID devices.

I was wondering if the people on the M/L could tell if the approach
was garbage, or should it work?

You can use the results to defrag targeted files.  However, I
discovered that defraging files on a Volume that has snapshots may be
counter-productive.  You end up duplicating the files you are
defragging, since Btrfs now needs to create different copies for the
snapshot and the original (or at least portions of the file).
