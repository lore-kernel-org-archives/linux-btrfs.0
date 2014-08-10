Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mondschein.lichtvoll.de ([194.150.191.11]:60833 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750991AbaHJRVc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 10 Aug 2014 13:21:32 -0400
From: Martin Steigerwald <Martin@lichtvoll.de>
To: Clemens Eisserer <linuxhippy@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: ENOSPC with mkdir and rename
Date: Sun, 10 Aug 2014 19:21:26 +0200
Message-ID: <2254732.l7uT8kohif@merkaba>
In-Reply-To: <CAFvQSYQhGhoRXWQ4Wqb7LZd3tdx8wLHDxn1uMqNEij8=yEvf1A@mail.gmail.com>
References: <CAFChkqtpb+xMhFk+7RBux-o-FOO0oaxx28Wz-LZZZVpvq2nRFQ@mail.gmail.com> <5484676.xyTNESz9qN@xev> <CAFvQSYQhGhoRXWQ4Wqb7LZd3tdx8wLHDxn1uMqNEij8=yEvf1A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am Dienstag, 5. August 2014, 14:58:34 schrieb Clemens Eisserer:
> Hi Russel,
> 
> > The Debian installer has BTRFS in a list of filesystems to choose with no
> > special notice about it.  I'm thinking of filing a Debian bug requesting
> > that they put a warning against it.
> 
> As long as it is not selected as the default filesystem, I think it is fine.
> Other distributions have been offering btrfs for some time now, too.

For example SLES 11 SP 2. A Linux training VM image I developed some slides 
about implementing an OpenLDAP server in SLES with on the next day was totally 
broke:

- no space left on device
- snapper created tons of snapshots
- yet in df -h still 2 GB free
- rm on a logfile returned no space left on device
- btrfs subvol delete returned no space left on device
- I think I also tried btrfs balance with no space left on device, but I am 
not 100% sure


At that time I just created a snapshot of the broken state and returned to a 
previous snapshot to have the VM fixed.

And note: This is on a distro that has enterprise support for using BTRFS on 
root filesystem – while using a 3.0 kernel, with hopefully some… but apparently 
not enough backports.

Granted, still it would be nice to to add a warning to Debian.

Better still would be just to have stability fixes for the hangs go into 3.16-
stable and thus also into Debian Jessie.

-- 
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
