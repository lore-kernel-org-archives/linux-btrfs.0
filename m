Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:50882 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030758AbbJ3KSA (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 30 Oct 2015 06:18:00 -0400
Date: Fri, 30 Oct 2015 11:17:58 +0100
From: Karel Zak <kzak@redhat.com>
To: Tom Yan <tom.ty89@gmail.com>
Cc: util-linux@vger.kernel.org, linux-btrfs@vger.kernel.org, elliott@hpe.com,
        ahferroin7@gmail.com
Subject: Re: bad handling of unpartitioned device in
 sysfs_devno_to_wholedisk() (which breaks mkfs.btrfs)
Message-ID: <20151030101758.GE19508@ws.net.home>
References: <CAGnHSEm4UND4aUuFMDesXQYiTGWFzv+tk1OEvMOj+6KRHC-MPw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAGnHSEm4UND4aUuFMDesXQYiTGWFzv+tk1OEvMOj+6KRHC-MPw@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Oct 30, 2015 at 09:43:28AM +0800, Tom Yan wrote:
> So I noticed that SSD detection does work on unpartitioned devices in
> mkfs.btrfs somehow:
> https://bugzilla.kernel.org/show_bug.cgi?id=102921
> 
> Later I found out that it breaks at blkid_devno_to_wholedisk() in is_ssd():
> http://git.kernel.org/cgit/linux/kernel/git/kdave/btrfs-progs.git/tree/mkfs.c?h=v4.2.3#n1103
> 
> which Elliot had shown an example with strace:
> https://lists.01.org/pipermail/linux-nvdimm/2015-September/002109.html
> 
> And I think the problem occurs in the sysfs_get_devname() here:
> https://git.kernel.org/cgit/utils/util-linux/util-linux.git/tree/lib/sysfs.c?h=v2.27#n785
> 
> Since sysfs_get_devname() has to call sysfs_readlink() later, which
> output a long full device path in /sys, I don't think we should call
> it directly with the buffer "diskname", which people won't expect that
> it has to be large enough to carry the path in the middle of the
> process. For example in is_sdd(), a char array of size 32 is used
> ("wholedisk").

You're right. The function sysfs_get_devname() is not too elegant as
it uses devname buffer for readlink. Fixed, the bugfix will be in
v2.27.1.

Thanks!

    Karel

-- 
 Karel Zak  <kzak@redhat.com>
 http://karelzak.blogspot.com
