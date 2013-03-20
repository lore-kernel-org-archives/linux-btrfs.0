Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mondschein.lichtvoll.de ([194.150.191.11]:49227 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933360Ab3CTTUg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 20 Mar 2013 15:20:36 -0400
From: Martin Steigerwald <Martin@lichtvoll.de>
To: linux-btrfs@vger.kernel.org
Subject: Re: Impossible or Possible to Securely Erase File on Btrfs?
Date: Wed, 20 Mar 2013 20:20:34 +0100
Cc: Marek Otahal <markotahal@gmail.com>, Kyle <lists@lolwut.org>
References: <514759B5.5000507@lolwut.org> <1510992.7BWEEWRdZp@beruska> (sfid-20130319_235455_099058_370B3F2E)
In-Reply-To: <1510992.7BWEEWRdZp@beruska>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Message-Id: <201303202020.34699.Martin@lichtvoll.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am Dienstag, 19. März 2013 schrieb Marek Otahal:
> Hi,
> 
> just reading chattr manpage..
> 
> On Monday 18 March 2013 14:15:17 you wrote:
> > Hi,
> > 
> > After reading through the btrfs documentation I'm curious to know if
> > it's possible to ever securely erase a file from a btrfs filesystem (or
> > ZFS for that matter). On non-COW filesystems atop regular HDDs one can
> > simply overwrite the file with zeros or random data using dd or some
> > other tool and rest assured that the blocks which contained the
> > sensitive information have been wiped. However on btrfs it would seem
> > any such attempt would write the zeros/random data to a new location,
> > leaving the old blocks with the sensitive data intact. Further, since
> > specifying NOCOW is only possible for newly created files, there seems
> > to be no way to overwrite the appropriate blocks short of deleting the
> > associated file and then filling the entire free filesystem space with
> > zeros/random data such that the old blocks are eventually overwritten.
> > What's the verdict on this?
> 
> what would chattr +s do?
> 
> "
> When a file with the `s' attribute set is deleted, its blocks are zeroed
> and written back to the disk.  Note: please make sure to read the bugs
> and limitations section at the end of this document. "
> 
> Nice spring to all of you! :)

Did you read on as suggested?

BUGS AND LIMITATIONS
       The `c', 's',  and `u' attributes are not honored by the ext2 and 
ext3 filesystems as implemented in the current mainline Linux kernels.


But well question still stands: Does BTRFS honor it?

My bet is: It doesn´t.

Thanks,
-- 
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
