Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:35332 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751244AbaKBVss convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 2 Nov 2014 16:48:48 -0500
Received: from c-75-70-18-61.hsd1.co.comcast.net ([75.70.18.61]:56853 helo=[192.168.1.126])
	by slmp-550-94.slc.westdc.net with esmtpsa (TLSv1:RC4-SHA:128)
	(Exim 4.82)
	(envelope-from <lists@colorremedies.com>)
	id 1Xl30x-004CFX-D0
	for linux-btrfs@vger.kernel.org; Sun, 02 Nov 2014 14:48:47 -0700
Content-Type: text/plain; charset=windows-1252
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: Quota question
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <4E5FAFF3-DB6F-4695-87E7-8AA9B64B34F1@free.fr>
Date: Sun, 2 Nov 2014 14:48:46 -0700
Message-Id: <8F387133-3535-40A0-BCEC-C624760B1E92@colorremedies.com>
References: <23550138-C487-44E1-AA4A-B3B951D778D1@free.fr> <F924EC8F-D124-4E6D-A8FE-E03D82A8DAB8@free.fr> <pan$db0e5$7ee7229b$da3a292b$c1219b2@cox.net> <BC83CB99-11A1-429E-B741-7B0CB9B96AEE@free.fr> <7A4F7864-B01A-4B69-B2DE-3140DA6216D8@colorremedies.com> <4E5FAFF3-DB6F-4695-87E7-8AA9B64B34F1@free.fr>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Nov 2, 2014, at 3:42 AM, Cyril Scetbon <cyril.scetbon@free.fr> wrote:

> 
>>> Hmm I chose btrfs because it's the only one supported by docker that supports quotas for the root user …
>> 
>> https://github.com/docker/docker/issues/3804
>> 
>> I don't think Docker is supporting quotas at all on anything yet. They want to do this but it seems the work hasn't been done yet, and they want it to be agnostic so it can work with device mapper, XFS, EXT4, and Btrfs.
> 
> What I'm saying is that btrfs is the only one that can apply quotas for root user (as docker needs to be launched as root user for some reason but it could change in the future).

OK no, XFS project quotas apply to root also which is why I suggested it.

[root@localhost project_quota_test1]# xfs_quota -c df
Filesystem           1K-blocks       Used  Available  Use% Pathname
/dev/sdb              83845120     157980   83687140    0% /xfs_local
/dev/sdb                102400     124928 9223372036854753280  122% /xfs_local/project_quota_test1
[root@localhost project_quota_test1]# dd if=/dev/zero of=test100MB bs=1M count=100
dd: error writing ‘test100MB’: No space left on device
79+0 records in
78+0 records out
81788928 bytes (82 MB) copied, 0.163849 s, 499 MB/s
[root@localhost project_quota_test1]# xfs_quota -c df
Filesystem           1K-blocks       Used  Available  Use% Pathname
/dev/sdb              83845120     237748   83607372    0% /xfs_local
/dev/sdb                102400     204800 9223372036854673408  200% /xfs_local/project_quota_test1


The available value is totally wonky, but once I reach the 200MB hard limit on this directory, even as root I get a no space left on device message.


> 
> 
>>> I'd really appreciate if someone can tell me exactly what should work and what shouldn't 
>> 
>> Well I haven't tested this at all yet, but maybe XFS project quotas fits your use case better than group quotas? With project quotas you can still also use user quotas if necessary (but project and group quotas on XFS are mutually exclusive).
> 
> I have only one user that creates/launches containers, root ! What I'm looking for is being able to apply quotas to a container and also to a group of containers. That's why I'm trying to use parent qgroups with btrfs.

It looks like XFS project quotas will do what you want.


Chris Murphy

