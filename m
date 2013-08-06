Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.virtall.com ([178.63.195.102]:57281 "EHLO mail.virtall.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755907Ab3HFQmi (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 6 Aug 2013 12:42:38 -0400
Date: Wed, 7 Aug 2013 00:42:27 +0800
From: Tomasz Chmielewski <mangoo@wpkg.org>
To: Arne Jansen <sensille@gmx.net>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: Heavy memory leak when using quota groups
Message-ID: <20130807004227.6b2b688e@wpkg.org>
In-Reply-To: <5200888A.4030109@gmx.net>
References: <20130806003505.7d7feff6@wpkg.org>
	<5200888A.4030109@gmx.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, 06 Aug 2013 07:24:26 +0200
Arne Jansen <sensille@gmx.net> wrote:

> On 05.08.2013 18:35, Tomasz Chmielewski wrote:
> >> I am trying to use qgroups
> >> functionality & with a basic random-write workload, it constantly
> >> keeps leaking memory & within few minutes of IO, there is either
> >> out-of-memory killer trying to kill some tasks or there are
> >> page-allocation failures that btrfs or other kernel module
> >> experiences.
> > 
> > FYI, I just saw something similar with 3.10 on a server with 32 GB
> > RAM:
> > 
> > The result was a frozen server and a need to hard reset.
> > 
> 
> What do I have to do to reproduce it here? How do you generate the
> load? What is the disk setup, what the qgroups setup?

Unfortunately I don't have a way to reproduce, as the issue
happened to me only once.

Server uptime was about 2 weeks, and there were millions of files with
multiple hardlinks on disk (backuppc archive copied from ext4 to
btrfs). Then, "rm" command was running for many days, about 5 times in
parallel, and many other rsync commands, with snapshots being added and
removed.

When I saw the issue I looked up in btrfs list archives that there was
a similar report in the past - but I doubt I will be able to find a
reliable way to reproduce this.

-- 
Tomasz Chmielewski
http://wpkg.org
