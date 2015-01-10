Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mondschein.lichtvoll.de ([194.150.191.11]:39155 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750780AbbAJKNy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 10 Jan 2015 05:13:54 -0500
From: Martin Steigerwald <Martin@lichtvoll.de>
To: Christoph Hellwig <hch@infradead.org>
Cc: Lennart Poettering <lennart@poettering.net>, dsterba@suse.cz,
        linux-btrfs@vger.kernel.org
Subject: Re: btrfs_inode_item's otime?
Date: Sat, 10 Jan 2015 11:13:52 +0100
Message-ID: <8849914.dEW4UQEyXo@merkaba>
In-Reply-To: <20150107144250.GA2901@infradead.org>
References: <20150105172152.GB19126@gardel-login> <20150107135734.GA21327@gardel-login> <20150107144250.GA2901@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am Mittwoch, 7. Januar 2015, 06:42:50 schrieb Christoph Hellwig:
> On Wed, Jan 07, 2015 at 02:57:35PM +0100, Lennart Poettering wrote:
> > Exposig this as xattr sounds great to me too.
> 
> NAK - exposing random stat data as xattr only creates problems.
> 
> Given that we don't seem to be able to get a new stat format anytime
> soon we should add a generic ioctl to expose it, reading it from struct
> kstat which all filesystem that support this attribute should fill out.
> And there's quite a lot of them.

What is the issue with the xstat, new stat format stuff? Basically I have the 
feeling that this is in discussion for at least 5 years or so and I always 
wondered where it is stuck. I am not aware of any discussions of it recently, 
but I may have overseen those.

Ext4, I think, already supports birth time, but cannot expose it either. And 
even the stat command already seems to have some support for it, except that 
it doesn´t work yet (this is on BTRFS, but on Ext4 its the same).

merkaba:~> LANG=C stat /bin/ls
  File: '/bin/ls'
  Size: 118280          Blocks: 232        IO Block: 4096   regular file
Device: 14h/20d Inode: 3574391     Links: 1
Access: (0755/-rwxr-xr-x)  Uid: (    0/    root)   Gid: (    0/    root)
Access: 2014-10-31 11:29:37.000000000 +0100
Modify: 2014-10-30 03:43:06.000000000 +0100
Change: 2014-10-31 11:29:41.440773090 +0100
 Birth: -

Any pointers?

-- 
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
