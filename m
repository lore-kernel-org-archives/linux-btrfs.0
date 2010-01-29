From: jim owens <jowens@hp.com>
Subject: Re: RAID-10 arrays built with btrfs & md report 2x difference in
 	available size?
Date: Fri, 29 Jan 2010 18:46:38 -0500
Message-ID: <4B63735E.1060609@hp.com>
References: <048D5581-1D1D-4F82-9FE3-0DBC1106EDB4@kupper.org> <c67eed301001291413p51f248d6y7f3b2ac9ba02c447@mail.gmail.com> <4B63634F.6090600@computer.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
To: RK <rkasl@computer.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4B63634F.6090600@computer.org>
List-ID: <linux-btrfs.vger.kernel.org>

RK wrote:
> I think so too -- I have six 1TB drives on RAID-10 btrfs and it shows
> that I have 5.5TB free space .. how that can be ?
> 
> # df -h
> Filesystem            Size  Used Avail Use% Mounted on
> /dev/sde1              66G  3.8G   59G   7% /
> /dev/sda              5.5T   28K  5.5T   1% /mnt/btrfs

As has been discussed multiple times on the list, btrfs reports
RAW storage so 6 x 1TB is 6 TB.  And the use rate will be double
for each block written (i.e. 2 blocks used) for raid10 (or raid1).

And yes, it is "not what you expect", but it is the only method
that can remain accurate under the mixed raid modes possible
on a per-file-basis in btrfs.

jim
