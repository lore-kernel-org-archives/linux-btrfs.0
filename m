Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from 9.mo1.mail-out.ovh.net ([178.32.108.172]:39689 "EHLO
	mo1.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751103AbaKBMCZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 2 Nov 2014 07:02:25 -0500
Received: from mail636.ha.ovh.net (b6.ovh.net [213.186.33.56])
	by mo1.mail-out.ovh.net (Postfix) with SMTP id D9BA0FFA25B
	for <linux-btrfs@vger.kernel.org>; Sun,  2 Nov 2014 11:42:55 +0100 (CET)
Content-Type: text/plain; charset=windows-1252
Mime-Version: 1.0 (Mac OS X Mail 8.0 \(1990.1\))
Subject: Re: Quota question
From: Cyril Scetbon <cyril.scetbon@free.fr>
In-Reply-To: <7A4F7864-B01A-4B69-B2DE-3140DA6216D8@colorremedies.com>
Date: Sun, 2 Nov 2014 11:42:52 +0100
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Message-Id: <4E5FAFF3-DB6F-4695-87E7-8AA9B64B34F1@free.fr>
References: <23550138-C487-44E1-AA4A-B3B951D778D1@free.fr> <F924EC8F-D124-4E6D-A8FE-E03D82A8DAB8@free.fr> <pan$db0e5$7ee7229b$da3a292b$c1219b2@cox.net> <BC83CB99-11A1-429E-B741-7B0CB9B96AEE@free.fr> <7A4F7864-B01A-4B69-B2DE-3140DA6216D8@colorremedies.com>
To: Chris Murphy <lists@colorremedies.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


>> Hmm I chose btrfs because it's the only one supported by docker that supports quotas for the root user …
> 
> https://github.com/docker/docker/issues/3804
> 
> I don't think Docker is supporting quotas at all on anything yet. They want to do this but it seems the work hasn't been done yet, and they want it to be agnostic so it can work with device mapper, XFS, EXT4, and Btrfs.

What I'm saying is that btrfs is the only one that can apply quotas for root user (as docker needs to be launched as root user for some reason but it could change in the future). So Today, I apply quotas them after each container creation. However, you're right it could change in the next months but that's not the case today …

>> I'd really appreciate if someone can tell me exactly what should work and what shouldn't 
> 
> Well I haven't tested this at all yet, but maybe XFS project quotas fits your use case better than group quotas? With project quotas you can still also use user quotas if necessary (but project and group quotas on XFS are mutually exclusive).

I have only one user that creates/launches containers, root ! What I'm looking for is being able to apply quotas to a container and also to a group of containers. That's why I'm trying to use parent qgroups with btrfs.

-- 
Cyril SCETBON

