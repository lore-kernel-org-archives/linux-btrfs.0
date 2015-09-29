Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.17.13]:62071 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965055AbbI2OMS (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 29 Sep 2015 10:12:18 -0400
Received: from durkon.lan ([178.201.238.189]) by mrelayeu.kundenserver.de
 (mreue101) with ESMTPSA (Nemesis) id 0MBkiF-1ZqaQR0sLv-00ArFp for
 <linux-btrfs@vger.kernel.org>; Tue, 29 Sep 2015 16:12:16 +0200
Received: from g.menke.ac (haley.lan [192.168.2.21])
	by durkon.lan (Postfix) with ESMTPSA id 193BA224C7
	for <linux-btrfs@vger.kernel.org>; Tue, 29 Sep 2015 16:12:15 +0200 (CEST)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Date: Tue, 29 Sep 2015 16:12:15 +0200
From: Gert Menke <gert@menke.ac>
To: linux-btrfs@vger.kernel.org
Subject: Re: BTRFS as image store for KVM?
In-Reply-To: <56055839.9000904@gmail.com>
References: <55F88ECC.1040604@menke.ac> <55FE0B42.50300@jrs-s.net>
 <CAGfcS_=bst0S8YLsr6y4oGDu7Gy-ox9ow5+_nD4c3zFdj-Y6ug@mail.gmail.com>
 <56054665.1020608@gmail.com> <5605518B.2020103@jrs-s.net>
 <CAGqmi75-Wc-YOwCJhRD1ahgKhEM5tPPBVjCYmvgjMZNhEnk77w@mail.gmail.com>
 <56055839.9000904@gmail.com>
Message-ID: <a5f26946b9bf488bfce46503de2b9495@durkon.lan>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

thank you all for your helpful comments.

 From what I've read, I forged the following guidelines (for myself; 
ymmv):
- Use btrfs for generic data storage on spinning disks and for 
everything on ssds.
- Use zfs for spinning disks that may be used for cow-unfriendly 
workloads, like vm images (if they are too big and/or too fast-changing 
for a scheduled defrag to make sense).

For now I'm going with the following setup: a Debian system with root on 
btrfs/raid1 on two ssds, and a raidz1 pool for storage and vm images. 
However, those few vms that really should be fast would also fit on the 
SSDs, so I might move them there and switch from ZFS to btrfs on the 
storage pool at some point in the future.

Some of the ideas presented here sound really interesting - for example 
I think that improving the Linux page cache to be more "arc-like" will 
probably benefit not only btrfs. Having both the page cache and the arc 
in parallel when using ZoL does not feel like an elegant solution, so 
maybe there's hope for that. (But I don't know if it is feasible for ZoL 
to abandon the arc in favor of an improved Linux page cache; I imagine 
it might be much work for little benefit.)

Thanks again
Gert
