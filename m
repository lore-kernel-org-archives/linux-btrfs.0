Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:38431 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756509AbbAIPxB (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 9 Jan 2015 10:53:01 -0500
Date: Fri, 9 Jan 2015 16:52:59 +0100
From: David Sterba <dsterba@suse.cz>
To: Lennart Poettering <lennart@poettering.net>
Cc: Josef Bacik <jbacik@fb.com>, linux-btrfs@vger.kernel.org
Subject: Re: price to pay for nocow file bit?
Message-ID: <20150109155259.GB3685@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20150107174315.GA21865@gardel-login>
 <54AD929E.608@fb.com>
 <20150108133036.GA23096@gardel-login>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20150108133036.GA23096@gardel-login>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jan 08, 2015 at 02:30:36PM +0100, Lennart Poettering wrote:
> On Wed, 07.01.15 15:10, Josef Bacik (jbacik@fb.com) wrote:
> > On 01/07/2015 12:43 PM, Lennart Poettering wrote:
> > >Currently, systemd-journald's disk access patterns (appending to the
> > >end of files, then updating a few pointers in the front) result in
> > >awfully fragmented journal files on btrfs, which has a pretty
> > >negative effect on performance when accessing them.
> > 
> > I've been wondering if mount -o autodefrag would deal with this problem but
> > I haven't had the chance to look into it.
> 
> Hmm, I am kinda interested in a solution that I can just implement in
> systemd/journald now and that will then just make things work for
> people suffering by the problem. I mean, I can hardly make systemd
> patch the mount options of btrfs just because I place a journal file
> on some fs...
> 
> Is "autodefrag" supposed to become a default one day?

Maybe. The option brings a performance hit because reading a block
that's out of sequential order with it's neighbors will also require to
read the neighbors. Then the group (like 8 blocks) will be written
sequentially to a new location.

It's an increased read latency in the fragmented case and more stress to
the block allocator. Practically it's not that bad for general use, eg.
a root partition, but now it's still users' decision whether to use it
or not.

> Anyway, given the pros and cons I have now changed journald to set the
> nocow bit on newly created journal files. When files are rotated (and
> we hence know we will never ever write again to them) the bit is tried
> to be unset again, and a defrag ioctl will be invoked right
> after. btrfs currently silently ignores that we unset the bit, and
> leaves it set, but I figure i should try to unset it anyway, in case
> it learns that one day. After all, after rotating the files there's no
> reason to treat the files special anymore...
> 
> I'll keep an eye on this, and see if I still get user complaints about
> it. Should autodefrag become default eventually we can get rid of this
> code in journald again.
> 
> One question regarding the btrfs defrag ioctl: playing around with it
> it appears to be asynchronous, the defrag request is simply queued and
> the ioctl returns immediately. Which is great for my usecase. However
> I was wondering if it always was async like this? I googled a bit, and
> found reports that defrag might take a while, but I am not sure if
> those reports were about the ioctl taking so long, or the effect of
> defrag actually hitting the disk... 

Defrag can be both sync and async, that's what the option -f is for.
Schedule file blocks for write and flush it, then go to the next file.
This avoids the hit in the async mode when tons of data can get
redirtied at once.
