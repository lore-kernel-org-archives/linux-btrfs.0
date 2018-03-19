Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from know-smtprelay-omc-5.server.virginmedia.net ([80.0.253.69]:32907
        "EHLO know-smtprelay-omc-5.server.virginmedia.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932472AbeCSIaM (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 19 Mar 2018 04:30:12 -0400
To: linux-btrfs@vger.kernel.org
From: Peter Chant <pete@petezilla.co.uk>
Subject: Kernel warning - not sure if this is important
Message-ID: <398a50db-8ae0-b933-7268-4231e08d615d@petezilla.co.uk>
Date: Mon, 19 Mar 2018 08:21:59 +0000
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I got this kernel warning overnight.  Possibly during or after a dedup
using duperemove.  I'm not sure if that is relevent.  Seems to relate to
fs/btrfs/backref.c line 1266.

Don't know if it is important.  Thought I'd post it just in case.

I'm afraid this is a screen-shot in the old fashioned sense:
https://drive.google.com/file/d/1NelZV2ld9Yqqt8b2y2sg6aAwgevgMy4X/view?usp=sharing

Pete
