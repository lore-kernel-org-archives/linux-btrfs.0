Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:36867 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752253Ab2LRDQq (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 17 Dec 2012 22:16:46 -0500
Message-ID: <50CFE17A.40502@oracle.com>
Date: Tue, 18 Dec 2012 11:22:34 +0800
From: Anand Jain <Anand.Jain@oracle.com>
MIME-Version: 1.0
To: Gene Czarcinski <gene@czarc.net>
CC: linux-btrfs@vger.kernel.org
Subject: Re: subvolume show
References: <50C8CB70.4060901@czarc.net>
In-Reply-To: <50C8CB70.4060901@czarc.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


> This looks like a useful capability. I was trying to find out
> what the UUID was for a newly created subvolume and have not
> found out how to do that.

  btrfs subvol list -u /mnt

  should help ?

  btrfs subvol show <subvol> is quite useful indeed we should
  consider to have it in git.

-Anand


On 13/12/2012 02:22, Gene Czarcinski wrote:
> I was looking through some of the archives and notice a patch submitted
> to implement:
> btrfs subvolume show <path-to-subvolume>
> command.
>
> I also noticed that is does not appear to be in the git.
>
> This looks like a useful capability. I was trying to find out what the
> UUID was for a newly created subvolume and have not found out how to do
> that.
>
> Gene
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at http://vger.kernel.org/majordomo-info.html
