Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f46.google.com ([74.125.82.46]:32919 "EHLO
	mail-wm0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752164AbcCIUVq (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 9 Mar 2016 15:21:46 -0500
Received: by mail-wm0-f46.google.com with SMTP id l68so1946223wml.0
        for <linux-btrfs@vger.kernel.org>; Wed, 09 Mar 2016 12:21:46 -0800 (PST)
MIME-Version: 1.0
Date: Wed, 9 Mar 2016 15:21:45 -0500
Message-ID: <CAD=QJKi-3PJQViAaRmGoz3_w6RQbRehDL9vXs14+CSHsG3ipTg@mail.gmail.com>
Subject: dstat shows unexpected result for two disk RAID1
From: Nicholas D Steeves <nsteeves@gmail.com>
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello everyone,

I've run into an expected behaviour for a my two disk RAID1.  I mount
with UUIDs, because sometimes my USB disk gets /dev/sdc instead of
/dev/sdd.  The two elements of my RAID1 are currently sdb and sdd.

dstat -tdD total,sdb,sdc,sdd

It seems that per process, reads come from either sdb or sdd.  This
surprises me, because I understood that a btrfs RAID1
