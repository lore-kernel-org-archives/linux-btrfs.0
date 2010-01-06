From: Johannes Hirte <johannes.hirte@fem.tu-ilmenau.de>
Subject: Re: btrfs volume mounts and dies (was Re: Segfault in btrfsck)
Date: Wed, 6 Jan 2010 18:24:35 +0100
Message-ID: <201001061824.37159.johannes.hirte@fem.tu-ilmenau.de>
References: <1262476565.17096.20.camel@phat> <20100106075253.GA5665@cumulus> <1262793595.6214.5.camel@phat>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Cc: linux-btrfs@vger.kernel.org
To: Steve Freitas <sflist@ihonk.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1262793595.6214.5.camel@phat>
List-ID: <linux-btrfs.vger.kernel.org>

Am Mittwoch 06 Januar 2010 16:59:55 schrieb Steve Freitas:
> Hi Sander,
> 
> On Wed, 2010-01-06 at 08:52 +0100, Sander wrote:
> > I don't have your original mail, but I think I remember you mentioned a
> > lot of bad sectors on that disk reported by SMART.
> >
> > If that is indeed the case it might be dificult for the people who might
> > be able to help you, to help you.
> 
> Thanks for your  response. You're correct about the bad sector warning.
> So please correct me if I have some mistaken assumptions. I thought
> btrfs would be tolerant of that -- if a block failed the checksum test,
> it would reconstruct and remap it. 
Only if enough redundancy is left. And with the default setup btrfs is only 
mirroring the metadata not the data.

> (Also, I assumed that if a drive
> hadn't filled its bad sector remapping table, it could handle it at the
> hardware level, and SMART's warning was just that -- a warning, not a
> dire pronouncement of utter unsuitability -- but that's something else.)

Bad sectors are only remapped by the drive on write time. As long as this 
isn't the case, they are only marked as pending. As you have written, that 
SMART detected many bad blocks, I suspect the FS is really damaged. And as 
btrfsck is limited, I don't think it can fix this.

regards,
  Johannes
