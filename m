From: Leszek Ciesielski <skolima@gmail.com>
Subject: Reporting free space to userspace programs
Date: Fri, 30 Oct 2009 12:58:20 +0100
Message-ID: <23a15590910300458y677692bbua62d2b41e9141bc7@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

the results of running 'df' against a btrfs volume are somewhat
unintuitive from a user point of view. On a single drive btrfs volume,
created with 'mkfs.btrfs -m raid1 -d raid1 /dev/sda6', I am getting
the following result:

/dev/sda6             1.4T  594G  804G  43% /mnt

while 'btrfs-show' displays much more expected result:

Label: none  uuid: 46e2f2b6-e3a6-4b02-8fdc-f9d0fb0882e0
        Total devices 1 FS bytes used 593.15GB
        devid    1 size 1.36TB used 1.26TB path /dev/sda6

IMHO it would be more intuitive for df in this case to show 699GB
total capacity (based on the fact that data is mirrored, and users
probably are not concerned with metadata handling during normal
usage), the 'used space' probably should include the space taken up by
metadata in addition to data usage (after all, this space is not
available for user data) and free space should report only data space
available (because this is what the user is usually expecting). Or, in
other words: the result of 'df' should not concern the user with the
details of raid0/raid1/raid10 used either for data or metadata.

Anyone care to comment?

kudos :-)


Leszek 'skolima' Ciesielski
---
I am running kernel 2.6.31-gentoo and using btrfs-progs 0.19, please
excuse me if my comments are no longer relevant (however, I did check
commit messages from the version I use up until
linux/kernel/git/mason/btrfs-unstable.git master-HEAD and did not find
anything related to the topic).
