Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lb0-f174.google.com ([209.85.217.174]:41652 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754130Ab2GYAji (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 24 Jul 2012 20:39:38 -0400
Received: by lbbgm6 with SMTP id gm6so239682lbb.19
        for <linux-btrfs@vger.kernel.org>; Tue, 24 Jul 2012 17:39:37 -0700 (PDT)
MIME-Version: 1.0
Date: Tue, 24 Jul 2012 20:39:36 -0400
Message-ID: <CAAdM644Xs1Vq-Sw4ZacGz_gBrURHzEhhs4drXJC+dMtP0DhSiw@mail.gmail.com>
Subject: No/bad auto-detection of fs type for small volumes (related to mixed metadata/data?)
From: Marios Titas <redneb8888@gmail.com>
To: btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

When I create a btrfs volume of size strictly less than 256 MiB then if I do
    mount /dev/sdb1 /mnt/test
the kernel tries unsuccessfully to do the mount with many other file systems
before successfully trying with btrfs. For volumes of size larger than
or equal to
256 MiB it just mounts the volume without doing that. Why is this discrepancy?

Another possibly related symptom is that the volume does not appear in
/dev/disk/by-label and /dev/disk/by-uuid at all. This means that it is
impossible
to mount the volume by uuid or label.

To make sure that this isn't a udev bug, I booted my system with init=/bin/bash
in the kernel command line, and then I tried again to mount the
volume. This time
it would not mount it at all unless I explicitly specified the fs
type. On the other
hand, it could mount larger volumes without any issues.

All the experiments were done in an initially zeroed out disk. I am
using 3.4.6 kernel
with btrfs from 3.5 and the latest btrfs-progs from git.
