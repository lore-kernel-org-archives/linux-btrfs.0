Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:57052 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751792AbdCUHXm (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 21 Mar 2017 03:23:42 -0400
Date: Tue, 21 Mar 2017 15:23:40 +0800
From: Eryu Guan <eguan@redhat.com>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH 0/3] Btrfs in-band de-duplication test cases
Message-ID: <20170321072340.GT14226@eguan.usersys.redhat.com>
References: <20170316015028.20020-1-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170316015028.20020-1-quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Mar 16, 2017 at 09:50:24AM +0800, Qu Wenruo wrote:
> Btrfs in-band de-duplication test cases for in-memory backend, which covers
> the bugs exposed during the development.

Sorry, I'm having trouble enabling inband dedupe in tests, I always get
ioctl failure, $seqres.full shows:

btrfs-progs v4.10-5-g23d4fd5
See http://btrfs.wiki.kernel.org for more information.

Label:              (null)
UUID:               3d2cedd0-64ae-4667-ba09-9c12e28ecadd
Node size:          16384
Sector size:        4096
Filesystem size:    15.00GiB
Block group profiles:
  Data:             single            8.00MiB
  Metadata:         DUP               1.00GiB
  System:           DUP               8.00MiB
SSD detected:       no
Incompat features:  extref, skinny-metadata
Number of devices:  1
Devices:
   ID        SIZE  PATH
    1    15.00GiB  /dev/mapper/systemvg-testlv2

# /usr/local/bin/btrfs dedupe enable -f -s inmemory -b 64K /scratch
ERROR: failed to (enable) inband deduplication: Inappropriate ioctl for device
ERROR: unsupported dedupe limit combination: nr: 0, mem: 0
failed: '/usr/local/bin/btrfs dedupe enable -f -s inmemory -b 64K /scratch'

I have no special MKFS_OPTIONS or MOUNT_OPTIONS specified, all defaults.
kernel is built from your test tree. Did I miss anything?

Thanks,
Eryu
