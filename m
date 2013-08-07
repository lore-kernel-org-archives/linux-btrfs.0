Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.virtall.com ([178.63.195.102]:35123 "EHLO mail.virtall.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932158Ab3HGTCr (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 7 Aug 2013 15:02:47 -0400
Date: Thu, 8 Aug 2013 03:02:36 +0800
From: Tomasz Chmielewski <tch@virtall.com>
To: Josef Bacik <jbacik@fusionio.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: btrfs filesystem "hang" after page allocation failure: order:0
 + kernel BUG at fs/btrfs/extent_io.c:4151
Message-ID: <20130808030236.6bd63d54@virtall.com>
In-Reply-To: <20130807185704.GC2397@localhost.localdomain>
References: <20130808021705.1dcb139e@virtall.com>
	<20130807185704.GC2397@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, 7 Aug 2013 14:57:04 -0400
Josef Bacik <jbacik@fusionio.com> wrote:

> > One of btrfs filesystems hanged on my server.
> > 
> > By "hang", I mean it's not possible to finish any write operation,
> > i.e.:
> > 
> > # cd /mnt/btrfs
> > 
> > # ls
> > some-file
> > 
> > # touch 1
> > [it never returns to shell here]
> > 
> I've just posted a patch to get rid of the panic on oom, could you
> please apply it and verify you no longer see the panic?  The OOM is
> another issue, but we should at the very least not panic.  Thanks,

It wasn't a panic or server hang; it was just "process hang" on uncached
read and all write operations on this particular btrfs filesystem
(there was another btrfs filesystem mounted on the same server, using
different drives / mount points, and it was still working fine).


-- 
Tomasz Chmielewski
http://wpkg.org
