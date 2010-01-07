From: Steve Freitas <sflist@ihonk.com>
Subject: What protection does btrfs checksumming currently give? (Was Re:
 btrfs volume mounts and dies (was Re: Segfault in btrfsck))
Date: Thu, 07 Jan 2010 10:28:32 -0800
Message-ID: <1262888912.6214.20.camel@phat>
References: <1262476565.17096.20.camel@phat> <20100106075253.GA5665@cumulus>
	 <1262793595.6214.5.camel@phat>
	 <201001061824.37159.johannes.hirte@fem.tu-ilmenau.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <201001061824.37159.johannes.hirte@fem.tu-ilmenau.de>
List-ID: <linux-btrfs.vger.kernel.org>

Hi all,

I was under the mistaken impression that btrfs checksumming, in its
current default configuration, protected your data from bitrot. It
appears this is not the case:

On Wed, 2010-01-06 at 18:24 +0100, Johannes Hirte wrote:
> Am Mittwoch 06 Januar 2010 16:59:55 schrieb Steve Freitas:
> > So please correct me if I have some mistaken assumptions. I thought
> > btrfs would be tolerant of that -- if a block failed the checksum test,
> > it would reconstruct and remap it. 

> Only if enough redundancy is left. And with the default setup btrfs is only 
> mirroring the metadata not the data.

So can someone please tell me what the current state-of-the-art is of
data protection with btrfs? Does it differ with single-device versus
multiple-device configurations? Is it possible to enable data
checksumming now? Under what conditions? And will it do what a naive
user would expect it to do, namely, correct for diverse kinds of errors
in your storage subsystem? If not, what does it do? Etc...

Any and all information is much appreciated.

Thanks!

Steve

