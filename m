Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mondschein.lichtvoll.de ([194.150.191.11]:59241 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758147Ab3EYWtU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 25 May 2013 18:49:20 -0400
From: Martin Steigerwald <Martin@lichtvoll.de>
To: Leonidas Spyropoulos <artafinde@gmail.com>
Cc: Duncan <1i5t5.duncan@cox.net>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: Recommended settings for SSD
Date: Sun, 26 May 2013 00:49:18 +0200
Message-ID: <1678992.ZSqdH6UUdd@merkaba>
In-Reply-To: <CAAeznTq_+fv5SoPcr7ZYmYAvora2VCgN1WR9c8q=jPHNZORYrw@mail.gmail.com>
References: <CAAeznTr3rsJWcFWKoagNrduXGzP2AWaXMKY0FO8te2Xpa7XiHw@mail.gmail.com> <1751895.r3q1HmeO0C@merkaba> <CAAeznTq_+fv5SoPcr7ZYmYAvora2VCgN1WR9c8q=jPHNZORYrw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am Samstag, 25. Mai 2013, 23:29:41 schrieb Leonidas Spyropoulos:
> On Sat, May 25, 2013 at 1:13 PM, Martin Steigerwald <Martin@lichtvoll.de> wrote:
> > Am Samstag, 25. Mai 2013, 03:58:12 schrieb Duncan:
> > [...]
> > And can be verified by:
> >
> > martin@merkaba:~> grep ssd /proc/mounts
> > /dev/mapper/merkaba-debian / btrfs rw,noatime,compress=lzo,ssd,space_cache 0 0
> > /dev/mapper/merkaba-debian /mnt/debian-zeit btrfs
> > rw,noatime,compress=lzo,ssd,space_cache 0 0
> > /dev/mapper/merkaba-home /home btrfs rw,noatime,compress=lzo,ssd,space_cache 0
> > 0
> > /dev/mapper/merkaba-home /mnt/home-zeit btrfs
> > rw,noatime,compress=lzo,ssd,space_cache 0 0
> > martin@merkaba:~> grep ssd /etc/fstab
> > martin@merkaba:~#1>
> > [...]
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> I see you are using compression. I don't have compression at the
> moment and I would like to use it. What will happen to the data that
> are already on the partitions? Will it be compressed when I use them?
> Do I have to re-write them? Would it be compressed with btrfs defrag
> command?
> 
> Thanks for the information

Only new or defragmented data as Harald explained already.

Beware: I wouldn´t use compression on SSDs that compress themselves, like
any modern SandForce SSDs I bet.

The Intel SSD 320 in use here doesn´t compress itself, it just encrypts.

-- 
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
