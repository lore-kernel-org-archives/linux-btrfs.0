Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from nmsh1.e.nsc.no ([193.213.121.72]:46245 "EHLO nmsh1.e.nsc.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751077AbbL3ScE (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 30 Dec 2015 13:32:04 -0500
Subject: Re: Btrfs scrub failure for raid 6 kernel 4.3
To: Chris Murphy <lists@colorremedies.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
References: <567FEEB6.3080701@online.no>
 <CAJCQCtSHWTqn7zzCtUtGjpr5=dMqfC1aGWaeNpZyVVhjrCvDHg@mail.gmail.com>
 <56806F06.50309@online.no> <pan$c7935$46be3379$4afc60bd$677c85c5@cox.net>
 <568098B1.2040908@online.no>
 <CAJCQCtRGbKJ6RJ++1rUSuVByC_=mJq4afNV-3CCt_s4gCft92A@mail.gmail.com>
 <5681A4D5.4060203@online.no>
 <CAJCQCtSAm2i0QuXPK5xDWNXvcrg3uo_DU5WYOnOD8Fkgn+c4eQ@mail.gmail.com>
 <5681BDD0.1060407@online.no>
 <CAJCQCtQX6x4Fx_f_RyLmNS3q611Zb_Q+hw025--Fx-zmH1wRvw@mail.gmail.com>
 <5682EABB.8040408@online.no>
 <CAJCQCtSZHpdLhkbSMfJi0RmV9Sa1_h4ea8yJzJMc3CxoLGhK+A@mail.gmail.com>
From: Waxhead <waxhead@online.no>
Message-ID: <5684231F.7040700@online.no>
Date: Wed, 30 Dec 2015 19:31:59 +0100
MIME-Version: 1.0
In-Reply-To: <CAJCQCtSZHpdLhkbSMfJi0RmV9Sa1_h4ea8yJzJMc3CxoLGhK+A@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Chris Murphy wrote:
> Well all the generations on all devices are now the same, and so are
> the chunk trees. I haven't looked at them in detail to see if there
> are any discrepancies among them.
>
> If you don't care much for this file system, then you could try btrfs
> check --repair, using btrfs-progs 4.3.1 or integration branch. I have
> no idea where btrfsck repair is at with raid56.
>
> On the one hand, corruption should be fixed by scrub. But scrub fails
> with a kernel trace. Maybe btrfs check --repair can fix the tree block
> corruption since scrub can't, and then if that corruption is fixed,
> possibly scrub will work.
>
I could not care less about this particular filesystem as I wrote in the 
original post. It's just for having some fun with btrfs. What I find 
troublesome is that corrupting one (or even two) drives in a Raid6 
config fails. Granted the filesystem "works" e.g. I can mount it and 
access files, but I get a input/output error on a file on this 
filesystem and btrfs only shows warning (not errors) on device sdg1 
where the csum failed.
A raid6 setup should work fine even if two missing disks (or in this 
case chunks of data) is missing and even if I don't care about this 
filesystem I care about btrfs getting stable ;) so if I can help I'll 
keep this filesystem around for a little longer!

