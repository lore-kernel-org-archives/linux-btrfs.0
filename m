Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from ns.bouton.name ([109.74.195.142]:45749 "EHLO mail.bouton.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752573AbcCaXNl (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 31 Mar 2016 19:13:41 -0400
Subject: Re: "/tmp/mnt.", and not honouring compression
To: Chris Murray <chrismurray84@gmail.com>, linux-btrfs@vger.kernel.org
References: <E30C9D57EC226049B1226989BABB2728418CE4@elephant.myhome.local>
From: Lionel Bouton <lionel-subscription@bouton.name>
Message-ID: <56FDAF22.7060103@bouton.name>
Date: Fri, 1 Apr 2016 01:13:38 +0200
MIME-Version: 1.0
In-Reply-To: <E30C9D57EC226049B1226989BABB2728418CE4@elephant.myhome.local>
Content-Type: text/plain; charset=windows-1252
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Le 31/03/2016 22:49, Chris Murray a écrit :
> Hi,
>
> I'm trying to troubleshoot a ceph cluster which doesn't seem to be
> honouring BTRFS compression on some OSDs. Can anyone offer some help? Is
> it likely to be a ceph issue or a BTRFS one? Or something else? I've
> asked on ceph-users already, but not received a response yet.
>
> Config is set to mount with "noatime,nodiratime,compress-force=lzo"
>
> Some OSDs have been getting much more full than others though, which I
> think is something to do with these 'tmp' mounts e.g. below:

Note that there are other reasons for unbalanced storage on Ceph OSD.
The main reason is too few PGs (there's a calculator on ceph.com, google
for it).
These tmp mounts aren't normal, you should find out what is causing them.

So it might be a Ceph issue (too few PGs) or a system issue (some
component trying to use your filesystems for its own purposes).
You might have more luck on the ceph-users list (post your Ceph version,
the result of ceph osd tree, df on all OSDs and hunt for the process
creating theses mounts on your systems).

It's probably not a Btrfs issue (I run a Ceph on Btrfs cluster in
production and I've never seen this kind of problem).

Lionel
