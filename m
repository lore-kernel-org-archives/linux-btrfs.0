Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from outrelay07.libero.it ([212.52.84.111]:38839 "EHLO
	outrelay07.libero.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756129AbaEISKN (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 9 May 2014 14:10:13 -0400
Message-ID: <536D1AA6.7050407@libero.it>
Date: Fri, 09 May 2014 20:12:54 +0200
From: Goffredo Baroncelli <kreijack@libero.it>
Reply-To: kreijack@inwind.it
MIME-Version: 1.0
To: dsterba@suse.cz, =?UTF-8?B?VG9tw6HFoSBQcnXFvmluYQ==?= <pruzinat@gmail.com>,
        linux-btrfs@vger.kernel.org
Subject: Re: Fwd: [suggestion] Add verbose notification about inode-cache
 rebuild to kernel log
References: <CACHxQ2tAU15z_pUEGBuGqYFR9n_fH9BeyA8=jYryRrb3H=zCYA@mail.gmail.com> <CACHxQ2sQH96Z==zqEaoEoOxc65k9TYD66yLXQzOYL1kxaPcrqw@mail.gmail.com> <20140509145118.GD5988@twin.jikos.cz>
In-Reply-To: <20140509145118.GD5988@twin.jikos.cz>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 05/09/2014 04:51 PM, David Sterba wrote:
> On Thu, May 08, 2014 at 04:22:13PM +0200, Tomáš Pružina wrote:
>> I ran into some troubles with inode-cache rebuilding on root fs after
>> filesystem was mounted without inode_cache, which stalls boot of my
>> box by several minutes.
>>
>> I boot from commandline like:
>> root=/dev/sda4 rootfstype=btrfs
>> rootflags=inode_cache,space_cache,autodefrag rw ...
>>
>> However when I manually remount root fs without inode_cache (for
>> example via kexec), it triggers cache rebuild at next mount which
>> takes several tens of minutes and mimick 'freeze' on boot.
>>
>> Would it be possible to put some printk saying that this is happening
>> so users don't get confused about it??
> 
> Adding the printk is probably a good thing, but I'd rather reconsider
> using inode_cache at all. IMO it's supposed to fix problems with inode
> numbers that we don't have.

IIRC, the problem is for the 32 bit system, were the API wants the inode number to be 32 bit..

In the past the inode_cache was introduced because the inode often reached 2^32 [1]

Because most modern hardware is 64 bit (with the exception of ARM ?), could be make sense to allow btrfs to work without inode_cache only on 64bit, loosing the possibility to be used on 32 bit system.

Instead when the inode_cache is used, btrfs still be compatible with both 32bit and 64bit systems.

How often a filesystem is moved between a 64bit and 32bit systems ?


[1] http://article.gmane.org/gmane.comp.file-systems.btrfs/9573
-- 
gpg @keyserver.linux.it: Goffredo Baroncelli (kreijackATinwind.it>
Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5
