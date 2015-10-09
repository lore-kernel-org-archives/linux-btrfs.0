Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:26686 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751270AbbJIRqj (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 9 Oct 2015 13:46:39 -0400
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz, clm@fb.com
Subject: [PATCH] Introduce device pool sysfs attributes
Date: Sat, 10 Oct 2015 01:46:22 +0800
Message-Id: <1444412783-7070-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This patch introduces sysfs layout for btrfs pool and devices. This
patch was previously submitted as prototype/RFC with the subject
   [PATCH RFC v2] btrfs: add sysfs layout to show volume info

And also I conducted a short survey to know if user would want the pool
attributes to be separated from the fs attributes. However it seems that
the preference is to have them merged.
   [survey] sysfs layout for btrfs

Goffredo provide nice review comment to create links like
btrfs/by_dev_uuid to point to the actual device within btrfs sysfs layout,
and I think this kind of grouping will help easy navigation, which can
be done on top of this patch.

It was quite challenging to maintain sysfs entries inline with volume
manager operations. This patch has been tested to pass my own scripts,
which exercisers btrfs volume manager and read sysfs contents, and
also has passed the usual xfstests.

Further on top of this patch, spare device and auto replace support are
being tested at my end, which I am going to send for the review soon.

This patch depends on a set of framework changes and fixes, which are
in the link below
  https://github.com/asj/btrfs-devel.git for-dave4

Anand Jain (1):
  btrfs: Introduce device pool sysfs attributes

 fs/btrfs/dev-replace.c |   6 +
 fs/btrfs/disk-io.c     |  12 --
 fs/btrfs/sysfs.c       | 533 ++++++++++++++++++++++++++++++++++++++++++++++---
 fs/btrfs/sysfs.h       |  12 +-
 fs/btrfs/volumes.c     |  45 ++++-
 fs/btrfs/volumes.h     |  10 +
 6 files changed, 575 insertions(+), 43 deletions(-)

-- 
2.4.1

