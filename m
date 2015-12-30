Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f181.google.com ([209.85.223.181]:34614 "EHLO
	mail-io0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753247AbbL3EWe (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 29 Dec 2015 23:22:34 -0500
Received: by mail-io0-f181.google.com with SMTP id 1so17347660ion.1
        for <linux-btrfs@vger.kernel.org>; Tue, 29 Dec 2015 20:22:34 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <5682EABB.8040408@online.no>
References: <567FEEB6.3080701@online.no>
	<CAJCQCtSHWTqn7zzCtUtGjpr5=dMqfC1aGWaeNpZyVVhjrCvDHg@mail.gmail.com>
	<56806F06.50309@online.no>
	<pan$c7935$46be3379$4afc60bd$677c85c5@cox.net>
	<568098B1.2040908@online.no>
	<CAJCQCtRGbKJ6RJ++1rUSuVByC_=mJq4afNV-3CCt_s4gCft92A@mail.gmail.com>
	<5681A4D5.4060203@online.no>
	<CAJCQCtSAm2i0QuXPK5xDWNXvcrg3uo_DU5WYOnOD8Fkgn+c4eQ@mail.gmail.com>
	<5681BDD0.1060407@online.no>
	<CAJCQCtQX6x4Fx_f_RyLmNS3q611Zb_Q+hw025--Fx-zmH1wRvw@mail.gmail.com>
	<5682EABB.8040408@online.no>
Date: Tue, 29 Dec 2015 21:22:33 -0700
Message-ID: <CAJCQCtSZHpdLhkbSMfJi0RmV9Sa1_h4ea8yJzJMc3CxoLGhK+A@mail.gmail.com>
Subject: Re: Btrfs scrub failure for raid 6 kernel 4.3
From: Chris Murphy <lists@colorremedies.com>
To: Waxhead <waxhead@online.no>
Cc: Chris Murphy <lists@colorremedies.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Well all the generations on all devices are now the same, and so are
the chunk trees. I haven't looked at them in detail to see if there
are any discrepancies among them.

If you don't care much for this file system, then you could try btrfs
check --repair, using btrfs-progs 4.3.1 or integration branch. I have
no idea where btrfsck repair is at with raid56.

On the one hand, corruption should be fixed by scrub. But scrub fails
with a kernel trace. Maybe btrfs check --repair can fix the tree block
corruption since scrub can't, and then if that corruption is fixed,
possibly scrub will work.


Chris Murphy
