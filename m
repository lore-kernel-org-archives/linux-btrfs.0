From: Gordan Bobic <gordan@bobich.net>
Subject: Re: VFS support for fast copy on deduplicating FSes
Date: Thu, 25 Nov 2010 10:36:11 +0000
Message-ID: <4CEE3C1B.9030009@bobich.net>
References: <AANLkTinz17SePZCCixBCA_WoW3rFWAsB7mRghL9uN17h@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	BTRFS MAILING LIST <linux-btrfs@vger.kernel.org>
To: David Nicol <davidnicol@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <AANLkTinz17SePZCCixBCA_WoW3rFWAsB7mRghL9uN17h@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

David Nicol wrote:
> unresearched question/suggestion:
> 
> Is there general support for a "fast copy" ioctl in the VFS layer,
> which would be hooked by file systems that support COW or other forms
> of deduplication and can provide copy semantics by manipulating
> metadata only?

What would be nice to have is something that provides functionality like 
this:
http://www.xmailserver.org/flcow.html

My use case is to do with chroot-type virtualization, to save DLL memory 
and disk space, but the author's use case is clearly different.

Vserver does something similar transparently within the combined 
guest-spaces (i.e. once you hashify the files, you no longer have 10 
instances of the identical glibc for 10 guests, and they are no longer 
using 10x the RAM and disk space), and when the file is touched for 
writing it COWs a new copy.

It would be nice to have something like this exist on FS level without 
need for patching by the likes of vserver, by simply applying a flag to 
files we want to be COW-ed (chattr?).

Having this work across snapshots is potentially a bit dubious. I can 
see why it might be a bad idea, so perhaps a better way might be to have 
something that works semantically and syntactically similar to snapshots 
for duplicating directory subtrees into COW copies?

Gordan
