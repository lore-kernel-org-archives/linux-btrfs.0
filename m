Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:52038 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750719AbbJNE2h convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 14 Oct 2015 00:28:37 -0400
From: Zhao Lei <zhaolei@cn.fujitsu.com>
To: <dsterba@suse.cz>
CC: <linux-btrfs@vger.kernel.org>
References: <cover.1444740703.git.zhaolei@cn.fujitsu.com> <20151013161913.GL27761@twin.jikos.cz>
In-Reply-To: <20151013161913.GL27761@twin.jikos.cz>
Subject: RE: [PATCH 0/3] btrfs-progs: mkfs: Fix different mixed type by argument sequence
Date: Wed, 14 Oct 2015 12:28:03 +0800
Message-ID: <00a101d10638$b763c7c0$262b5740$@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi, David Sterba

> -----Original Message-----
> From: David Sterba [mailto:dsterba@suse.cz]
> Sent: Wednesday, October 14, 2015 12:19 AM
> To: Zhao Lei <zhaolei@cn.fujitsu.com>
> Cc: linux-btrfs@vger.kernel.org
> Subject: Re: [PATCH 0/3] btrfs-progs: mkfs: Fix different mixed type by
> argument sequence
> 
> On Tue, Oct 13, 2015 at 08:52:16PM +0800, Zhao Lei wrote:
> > Given a 200G vdd1 and 1G vdd2:
> >
> > In current code:
> >  mkfs.btrfs -f /dev/vdd1 /dev/vdd2
> >  and
> >  mkfs.btrfs -f /dev/vdd2 /dev/vdd1
> >  will create different "mixed" type.
> 
> I think combining large and small devices was not intended use for the
> mixed-bg, nevertheless current behaviour is not right.
> 
> Chandan is working on dropping the forced mixed-bg completely. We've
> discussed that on IRC, I'm ok with it but this needs more testing. So far it looks
> fine, small filesystems get created and usable, though some tuning might be
> needed.
> 
> My intentions for 4.3 is to take Chandan's work provided that we test it enough.
> There are like 3 weeks left. In case of problems, I'll take this patchset so at
> least we get the inconsisten behaviour fixed.

Thanks for explanation.

If 4.3 released with dropping mixed-bg, the PATCH 1/3 maybe still
necessary, I'll rebase after 4.3.

And another problem:
This time the vdh1 is changed to 100M:

[root@kerneldev progs]# ./mkfs.btrfs -f /dev/vdh1 /dev/vdh2
btrfs-progs v4.2.2-25-gc6b29b6-dirty
See http://btrfs.wiki.kernel.org for more information.

Label:              (null)
UUID:               4465aed7-d33c-4b76-9723-a76df74547fb
Node size:          16384
Sector size:        4096
Filesystem size:    1.20GiB
Block group profiles:
  Data+Metadata:    RAID0            72.00MiB
  System:           RAID1            12.00MiB
SSD detected:       no
Incompat features:  mixed-bg, extref, skinny-metadata
Number of devices:  2
Devices:
   ID        SIZE  PATH
    1   120.55MiB  /dev/vdh1
    2     1.08GiB  /dev/vdh2

[root@kerneldev progs]# ./mkfs.btrfs -f /dev/vdh2 /dev/vdh1
btrfs-progs v4.2.2-25-gc6b29b6-dirty
See http://btrfs.wiki.kernel.org for more information.

not enough free space
[root@kerneldev progs]#

Can be fixed by checking raid support only based on "large disk count".

This fix maybe conflict with Chandan's work, so I'll begin work after
he finished.

Thanks
Zhaolei

