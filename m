Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:59823 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754433Ab3CGNhT (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 7 Mar 2013 08:37:19 -0500
Message-ID: <5138980C.8080000@redhat.com>
Date: Thu, 07 Mar 2013 07:37:16 -0600
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Sw=E2mi_Petaramesh?= <swami@petaramesh.org>
CC: "BTRFS, Linux" <linux-btrfs@vger.kernel.org>
Subject: Re: mkfs.btrfs broken
References: <513883DD.8080203@petaramesh.org>
In-Reply-To: <513883DD.8080203@petaramesh.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 3/7/13 6:11 AM, Swâmi Petaramesh wrote:
> Hi,
> 
> mkfs.btrfs v0.20-rc1, as provided in the excellent "Parted Magic" tool,
> latest version dated 2013/02/28, is broken :

Unfortunately "v0.20-rc1" spans months of development, since btrfs-progs
has no consistent release or versioning activity.

> When trying to mkfs.btrfs - even on newly made, FS-free partition, it
> always spits an error that it cannot check partition mount status and fails.

What error messages does it emit, anything helpful?

> There has always been such an issue with mkfs.btrfs AFAIR, but it can
> more or less work depending on the distribution etc...
> 
> In the past, some versions of mkfs.btrfs had a "-f" option that would
> force formatting even if this test failed, but alas this option seems to
> have disappeared...

The option is quite new, and still exists upstream.  But it only forces
overwrite of an existing filesystem, it has never affected the mount status
check AFAIK.

> PartedMagic being a "live CD", it might be easy to reproduce and check
> what, exactly, goes wrong ?

There are also steps you could take to investigate some more yourself:

Did earlier versions of the livecd work for you?
If so, when did it break?
Looking at the PartedMagic changelog, what were relevant changes?
Can you reproduce this outside the PartedMagic CD?
Is it possibly a PartedMagic bug?
Can you capture an strace of the failing mkfs.btrfs?

-Eric

> Kind regards.
> 

