From: Gordan Bobic <gordan@bobich.net>
Subject: Linear (JBOD) Array Mode
Date: Fri, 12 Nov 2010 10:59:55 +0000
Message-ID: <4CDD1E2B.1000505@bobich.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Is there an option in btrfs for this mode of RAID? I know it supports
the equivalent of RAID10, but what I am after is JBOD of mirrors. The
reason I want this is for making a really low power home NAS, typically
for home theater/media use. I believe this would yield better power
savings in the average case.

Here is my reasoning. This sort of a setup would be idle most of the
time, and the disks can safely be spun down. When a request comes to
read a file (typically a multi-MB or multi-GB sequentially read file),
in RAID0 all the disks would wake up because each chunk would come off
as different disk. In JBOD, only the disk that has the file on it would
need to be awake to serve that file while the rest can go to sleep.

Of course JBOD yields relatively poor performance, but since an average
SATA disk will saturate a Gb ethernet link with a linear read (the sort
that I envisage my storage box doing most of the time), performance
isn't really an issue.

I know I can create two RAID0 stripes and create a BTRFS mirror on top
of that, but if I were to do that, then a disk failure would mean
re-mirroring the entire stripe instead of just one disk, which is not a
sane solution on a big multi-TB array.

Is there a way to do this with BTRFS?

Gordan

