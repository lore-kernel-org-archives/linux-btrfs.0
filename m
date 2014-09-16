Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qc0-f180.google.com ([209.85.216.180]:63914 "EHLO
	mail-qc0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752512AbaIPWdf (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 16 Sep 2014 18:33:35 -0400
Received: by mail-qc0-f180.google.com with SMTP id m20so849998qcx.25
        for <linux-btrfs@vger.kernel.org>; Tue, 16 Sep 2014 15:33:34 -0700 (PDT)
MIME-Version: 1.0
Date: Tue, 16 Sep 2014 15:33:34 -0700
Message-ID: <CA+4uBUYffJ6+6_LtxjL2mkcbeN_p9-HUYaWv+MAJgGFrVyiitA@mail.gmail.com>
Subject: EEXIST on writev to ceph journal file on btrfs 3.17-rc4 (not
 reproducible in 3.16)
From: Samuel Just <sam.just@inktank.com>
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The journal file is opened with O_DIRECT | O_DSYNC.  I can reproduce
it somewhat readily with a ceph-osd process on some of our hardware.
I'm trying to create a non-ceph reproducer, but I figured that this
might be enough to go on in the mean time.  What additional
information would be useful?
-Sam
