From: Christian Brunner <chb@muc.de>
Subject: Re: WARNING: at fs/btrfs/inode.c:2198 btrfs_orphan_commit_root+0xa8/0xc0
Date: Wed, 9 Nov 2011 15:01:14 +0100
Message-ID: <CAO47_-_7PH=NXqW8EGPR4nEk347N+tqJPsgYgFjhr2tVVX8arw@mail.gmail.com>
References: <4EBA54F2.3030801@unilogicnetworks.net>
Reply-To: chb@muc.de
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs@vger.kernel.org
To: Stefan Kleijkers <stefan@unilogicnetworks.net>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4EBA54F2.3030801@unilogicnetworks.net>
List-ID: <linux-btrfs.vger.kernel.org>

2011/11/9 Stefan Kleijkers <stefan@unilogicnetworks.net>:
> Hello,
>
> I'm seeing a lot of warnings in dmesg with a BTRFS filesystem. I'm using the
> 3.1 kernel, I found a patch for these warnings (
> http://marc.info/?l=linux-btrfs&m=131547325515336&w=2)
> <http://marc.info/?l=linux-btrfs&m=131547325515336&w=2>, but that patch has
> already been included in 3.1. Are there any other patches I can try?
>
> I'm using BTRFS in combination with Ceph and it looks like after a while
> with a high rsync workload that the IO stalls for some time, could the
> warnings result in IO stall?

This seem to be the same issue, I've seen in our ceph cluster. We had
a lengthy discussion on the btrfs list about this:

http://marc.info/?l=linux-btrfs&m=132007001119383&w=2

As far as I know josef is still working on it. Some of the latest
patches he sent seem to related to this, but I don't know if these fix
the problem.

Regards,
Christian
