Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:41528 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752471AbcDCVqd (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 3 Apr 2016 17:46:33 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1ampqn-0004Ma-3m
	for linux-btrfs@vger.kernel.org; Sun, 03 Apr 2016 23:46:29 +0200
Received: from 227.87.66.148.dsl.dyn.mana.pf ([148.66.87.227])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 03 Apr 2016 23:46:29 +0200
Received: from jd.girard by 227.87.66.148.dsl.dyn.mana.pf with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 03 Apr 2016 23:46:29 +0200
To: linux-btrfs@vger.kernel.org
From: Jean-Denis Girard <jd.girard@sysnux.pf>
Subject: Snapshots diff
Date: Sun, 3 Apr 2016 11:46:15 -1000
Message-ID: <nds2v8$72d$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi list,

I've written a little Python script that displays differences between
two snapshots. It relies on btrfs send to compute the differences. You
can get it here: https://github.com/sysnux/btrfs-snapshots-diff

There are no dependencies besides Python2.

The stream is decoded in the Python code, and there is something wrong
with symlinks : the action in the stream does not correspond to what is
written in btrfs-progs/send-stream.c (BTRFS_SEND_A_INO vs
BTRFS_SEND_A_PATH_LINK). I probably made a mistake, but can't find it:
can someone explain that difference?

I hope someone will find this useful.


Thanks,
-- 
Jean-Denis Girard

SysNux                 Systèmes   Linux   en   Polynésie   française
http://www.sysnux.pf/  Tél: +689 40.50.10.40 / GSM: +689 87.79.75.27

