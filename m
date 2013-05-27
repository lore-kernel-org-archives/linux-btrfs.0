Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ve0-f169.google.com ([209.85.128.169]:59954 "EHLO
	mail-ve0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755483Ab3E0AHH (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 26 May 2013 20:07:07 -0400
Received: by mail-ve0-f169.google.com with SMTP id jw11so4797706veb.0
        for <linux-btrfs@vger.kernel.org>; Sun, 26 May 2013 17:07:06 -0700 (PDT)
MIME-Version: 1.0
Date: Mon, 27 May 2013 02:07:06 +0200
Message-ID: <CAFvQSYShdQL_pZB12=Xt7dg+yLt0NNCW+WTyOXgic3SbFDy69w@mail.gmail.com>
Subject: Btrfsck errors (fs tree 565 refs 125 not found) - how serious
From: Clemens Eisserer <linuxhippy@gmail.com>
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

For about 3 weeks I've been using btrfs on my desktop machine, using
the snapshot-functionality quite a lot.

Today I ran btrfsck and got about ~10MB of output which looks like:

fs tree 565 refs 125 not found
	unresolved ref root 807 dir 813347 index 277 namelen 39 name
snapshot_1368273601_2013-05-11_14:00:01 error 600
	unresolved ref root 808 dir 813347 index 277 namelen 39 name
snapshot_1368273601_2013-05-11_14:00:01 error 600
.......

fs tree 566 refs 125 not found
	unresolved ref root 807 dir 813347 index 278 namelen 39 name
snapshot_1368274201_2013-05-11_14:10:01 error 600
	unresolved ref root 808 dir 813347 index 278 namelen 39 name
snapshot_1368274201_2013-05-11_14:10:01 error 600
......


while the log contained a lot of different values for "fs tree", the
refs which were not found stays fairly constant:

refs: 125, 397, 398, 406, 407, 420

How serious are those issues, should I be worried?
Would it help if I find ways to reproduce this behaviour on a fresh
btrfs filesystem?

Thank you in advance, Clemens
