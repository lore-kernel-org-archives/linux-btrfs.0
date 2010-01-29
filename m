From: RK <rkasl@computer.org>
Subject: Re: RAID-10 arrays built with btrfs & md report 2x difference in
 	available size?
Date: Fri, 29 Jan 2010 17:38:07 -0500
Message-ID: <4B63634F.6090600@computer.org>
References: <048D5581-1D1D-4F82-9FE3-0DBC1106EDB4@kupper.org> <c67eed301001291413p51f248d6y7f3b2ac9ba02c447@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <c67eed301001291413p51f248d6y7f3b2ac9ba02c447@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>


> it is, and reading -> "df is lying.  The total bytes in the FS include all 4 drives.  I need to fix up the math for the total available
> space.", it looks like its under control.  thx!

I think so too -- I have six 1TB drives on RAID-10 btrfs and it shows
that I have 5.5TB free space .. how that can be ?

# df -h
Filesystem            Size  Used Avail Use% Mounted on
/dev/sde1              66G  3.8G   59G   7% /
/dev/sda              5.5T   28K  5.5T   1% /mnt/btrfs


