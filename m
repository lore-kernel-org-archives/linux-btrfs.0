Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.fusionio.com ([66.114.96.30]:53162 "EHLO mx1.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754302Ab2LROEM (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 18 Dec 2012 09:04:12 -0500
Date: Tue, 18 Dec 2012 09:04:09 -0500
From: Josef Bacik <jbacik@fusionio.com>
To: Atri Sharma <atri.jiit@gmail.com>
CC: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: BTree lock contention
Message-ID: <20121218140409.GD2403@localhost.localdomain>
References: <CAOeZVifRT=63Md+03bu9Fj8a9+p+c32_J-FRH5uZdiv6n=zNXw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <CAOeZVifRT=63Md+03bu9Fj8a9+p+c32_J-FRH5uZdiv6n=zNXw@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Dec 17, 2012 at 09:24:23PM -0700, Atri Sharma wrote:
> Hi All,
> 
> I was looking through the project ideas page for picking up a project
> do start working with BTRFS. I am really interested in Btree lock
> contention project, but it seems to be marked that it has already been
> done in v3.1
> 
> Is the project still open? Can I work on it?
> 

Go for it, we still have plenty of lock contention, it's just in 3.1 we switched
to a read/write lock which helped a bunch.  Still if you have all writers you
are going to hit quite a bit of lock contention, especially on the root nodes.
If you have ideas go for it.  Thanks,

Josef
