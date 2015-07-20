Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from d.mail.sonic.net ([64.142.111.50]:42830 "EHLO d.mail.sonic.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753947AbbGTCHn (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 19 Jul 2015 22:07:43 -0400
Received: from mail-vn0-f41.google.com (mail-vn0-f41.google.com [209.85.216.41])
	(authenticated bits=0)
	by d.mail.sonic.net (8.15.1/8.15.1) with ESMTPSA id t6K27e8S018480
	(version=TLSv1.2 cipher=DHE-RSA-AES128-SHA bits=128 verify=NOT)
	for <linux-btrfs@vger.kernel.org>; Sun, 19 Jul 2015 19:07:41 -0700
Received: by vnav141 with SMTP id v141so18366185vna.0
        for <linux-btrfs@vger.kernel.org>; Sun, 19 Jul 2015 19:07:40 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20150714120603.GH15535@twin.jikos.cz>
References: <20150714120603.GH15535@twin.jikos.cz>
Date: Sun, 19 Jul 2015 19:07:40 -0700
Message-ID: <CAPF83mvVws5EK16ooozog7rzgciXVQ5TtvtTb2Sq5NdEnas=jw@mail.gmail.com>
Subject: Re: Btrfs progs release 4.1.2 (urgent fix, do not use 4.1.1)
From: Suman Chakravartula <suman@rockstor.com>
To: dsterba@suse.com, linux-btrfs <linux-btrfs@vger.kernel.org>, clm@fb.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi David,

We are using 4.1 progs and 4.1 kernel on Rockstor currently and what I
see is that btrfs check says device is not currently mounted. Is 4.1
effected? Do you recommend we update to 4.1.2 anyway?

[root@RockStor ~]# btrfs fi show testpool; mount | grep testpool;
btrfs check /dev/sdaa; btrfs check /dev/sdab
Label: 'testpool'  uuid: ed600942-f300-4a01-aa49-6b0ab6c0b8f9
Total devices 2 FS bytes used 3.69GiB
devid    1 size 2.00GiB used 2.00GiB path /dev/sdaa
devid    2 size 2.00GiB used 2.00GiB path /dev/sdab

btrfs-progs v4.1
/dev/sdaa on /mnt2/testpool type btrfs (rw,relatime,space_cache)
/dev/sdac on /mnt2/testpool2 type btrfs (rw,relatime,space_cache)
/dev/sdaa is currently mounted. Aborting.
/dev/sdab is currently mounted. Aborting.



On Tue, Jul 14, 2015 at 5:06 AM, David Sterba <dsterba@suse.com> wrote:
> Hi,
>
> due to a buggy bugfix to mkfs, filesystems created with version 4.1.1 are not
> entirely correct.
>
> To check if the filesystem is affected run 'btrfs check' and look for
>
> Chunk[256, 228, 0]: length(4194304), offset(0), type(2) mismatch with block group[0, 192, 4194304]: offset(4194304), objectid(0), flags(34)
> Chunk[256, 228, 4194304]: length(8388608), offset(4194304), type(4) mismatch with block group[4194304, 192, 8388608]: offset(8388608), objectid(4194304), flags(36)
>
> at the beginning of the output. Such filesystems must not be used and
> must be recreated. Read-only mount should be safe to retrieve the data,
> but at the moment this hasn't been verified.
>
> Thanks to Qu Wenruo for identifying the problem, I'm sorry for the trouble.
>
> Tarballs: https://www.kernel.org/pub/linux/kernel/people/kdave/btrfs-progs/
> Git: git://git.kernel.org/pub/scm/linux/kernel/git/kdave/btrfs-progs.git
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
