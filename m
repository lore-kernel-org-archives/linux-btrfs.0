Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from 18.mo6.mail-out.ovh.net ([46.105.73.110]:48368 "EHLO
	mo6.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750796AbaKEWMJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 5 Nov 2014 17:12:09 -0500
Received: from mail179.ha.ovh.net (gw6.ovh.net [213.251.189.206])
	by mo6.mail-out.ovh.net (Postfix) with SMTP id 22CDBFF8CB8
	for <linux-btrfs@vger.kernel.org>; Wed,  5 Nov 2014 21:52:17 +0100 (CET)
Content-Type: text/plain; charset=windows-1252
Mime-Version: 1.0 (Mac OS X Mail 8.0 \(1990.1\))
Subject: Re: Quota question
From: Cyril Scetbon <cyril.scetbon@free.fr>
In-Reply-To: <8F387133-3535-40A0-BCEC-C624760B1E92@colorremedies.com>
Date: Wed, 5 Nov 2014 21:52:18 +0100
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Message-Id: <EC156DAA-1971-41CD-B978-5E368E245E82@free.fr>
References: <23550138-C487-44E1-AA4A-B3B951D778D1@free.fr> <F924EC8F-D124-4E6D-A8FE-E03D82A8DAB8@free.fr> <pan$db0e5$7ee7229b$da3a292b$c1219b2@cox.net> <BC83CB99-11A1-429E-B741-7B0CB9B96AEE@free.fr> <7A4F7864-B01A-4B69-B2DE-3140DA6216D8@colorremedies.com> <4E5FAFF3-DB6F-4695-87E7-8AA9B64B34F1@free.fr> <8F387133-3535-40A0-BCEC-C624760B1E92@colorremedies.com>
To: Chris Murphy <lists@colorremedies.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

oh cool to know !

It's weird that the man page says "limits are never enforced on the superuser (nor are they enforced for group and project ID zero)"

http://manpages.ubuntu.com/manpages/trusty/en/man8/xfs_quota.8.html

Thanks
-- 
Cyril SCETBON

> On 02 Nov 2014, at 22:48, Chris Murphy <lists@colorremedies.com> wrote:
> 
> 
> On Nov 2, 2014, at 3:42 AM, Cyril Scetbon <cyril.scetbon@free.fr> wrote:
> 
>> 
>>>> Hmm I chose btrfs because it's the only one supported by docker that supports quotas for the root user …
>>> 
>>> https://github.com/docker/docker/issues/3804
>>> 
>>> I don't think Docker is supporting quotas at all on anything yet. They want to do this but it seems the work hasn't been done yet, and they want it to be agnostic so it can work with device mapper, XFS, EXT4, and Btrfs.
>> 
>> What I'm saying is that btrfs is the only one that can apply quotas for root user (as docker needs to be launched as root user for some reason but it could change in the future).
> 
> OK no, XFS project quotas apply to root also which is why I suggested it.
> 
> [root@localhost project_quota_test1]# xfs_quota -c df
> Filesystem           1K-blocks       Used  Available  Use% Pathname
> /dev/sdb              83845120     157980   83687140    0% /xfs_local
> /dev/sdb                102400     124928 9223372036854753280  122% /xfs_local/project_quota_test1
> [root@localhost project_quota_test1]# dd if=/dev/zero of=test100MB bs=1M count=100
> dd: error writing ‘test100MB’: No space left on device
> 79+0 records in
> 78+0 records out
> 81788928 bytes (82 MB) copied, 0.163849 s, 499 MB/s
> [root@localhost project_quota_test1]# xfs_quota -c df
> Filesystem           1K-blocks       Used  Available  Use% Pathname
> /dev/sdb              83845120     237748   83607372    0% /xfs_local
> /dev/sdb                102400     204800 9223372036854673408  200% /xfs_local/project_quota_test1
> 
> 
> The available value is totally wonky, but once I reach the 200MB hard limit on this directory, even as root I get a no space left on device message.
> 
> 
>> 
>> 
>>>> I'd really appreciate if someone can tell me exactly what should work and what shouldn't 
>>> 
>>> Well I haven't tested this at all yet, but maybe XFS project quotas fits your use case better than group quotas? With project quotas you can still also use user quotas if necessary (but project and group quotas on XFS are mutually exclusive).
>> 
>> I have only one user that creates/launches containers, root ! What I'm looking for is being able to apply quotas to a container and also to a group of containers. That's why I'm trying to use parent qgroups with btrfs.
> 
> It looks like XFS project quotas will do what you want.
> 
> 
> Chris Murphy
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

