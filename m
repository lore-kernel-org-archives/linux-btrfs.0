Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:21242 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753594AbbINJqQ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 14 Sep 2015 05:46:16 -0400
Message-ID: <55F696F9.7090708@oracle.com>
Date: Mon, 14 Sep 2015 17:44:25 +0800
From: Anand Jain <anand.jain@oracle.com>
MIME-Version: 1.0
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
CC: Ivan Petrovic <ivan@ipplus.rs>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: unable to mount multi disk volume with recovery mode
References: <CAEyaVk+QnDb5sbfMtV_pGbkwA4BB9ODpVv-_hdMJWjuPbGG+Xg@mail.gmail.com> <55F66855.4010000@cn.fujitsu.com>
In-Reply-To: <55F66855.4010000@cn.fujitsu.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



Hi Qu,

> Unfortunately, single mode means no duplication.
> And degrade mount only works for RAID level with
> duplication(DUP,RAID1/5/6/10).

further to the below commit.

  commit 95669976bd7d30ae265db938ecb46a6b7f8cb893
     Btrfs: don't consider the missing device when allocating new chunks

in case of 2-disk RAID1 mounted with only one good disk, we would create 
Single profile and actually the created single profiles are still 
workable with one disk failed. And so the proposed patch below will let 
single profile to be mount in this context..
   [PATCH 23/23] Btrfs: allow -o rw,degraded for single group profile

to recover when missing disk is replaced balance convert can migrate 
single profiles back to RAID1 profile.

Also your explanation for degraded is correct, I am ok to use a new new 
mount option (like auto-reduced-profile ?) if needed / confusing.

Any comments / feedbacks are welcome.

Thanks, Anand
