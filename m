From: Steve Freitas <sflist@ihonk.com>
Subject: Re: btrfs volume mounts and dies (was Re: Segfault in btrfsck)
Date: Wed, 06 Jan 2010 12:11:35 -0800
Message-ID: <1262808695.6214.9.camel@phat>
References: <1262476565.17096.20.camel@phat> <20100106075253.GA5665@cumulus>
	 <1262793595.6214.5.camel@phat>
	 <201001061824.37159.johannes.hirte@fem.tu-ilmenau.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <201001061824.37159.johannes.hirte@fem.tu-ilmenau.de>
List-ID: <linux-btrfs.vger.kernel.org>

Hi Johannes,

On Wed, 2010-01-06 at 18:24 +0100, Johannes Hirte wrote:
> Am Mittwoch 06 Januar 2010 16:59:55 schrieb Steve Freitas:
> > Thanks for your  response. You're correct about the bad sector warning.
> > So please correct me if I have some mistaken assumptions. I thought
> > btrfs would be tolerant of that -- if a block failed the checksum test,
> > it would reconstruct and remap it. 
> Only if enough redundancy is left. And with the default setup btrfs is only 
> mirroring the metadata not the data.

Okay. What capacity does btrfs have for reconstructing data, and how do
I enable it (if any) for a new partition? I think I've confused
checksums with magical ponies.

> Bad sectors are only remapped by the drive on write time. As long as this 
> isn't the case, they are only marked as pending. As you have written, that 
> SMART detected many bad blocks, I suspect the FS is really damaged. And as 
> btrfsck is limited, I don't think it can fix this.

Alright, I'll trash it and start over with a different drive.

Thanks,

Steve

