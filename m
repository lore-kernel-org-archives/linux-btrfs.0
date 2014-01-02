Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:44367 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751769AbaABPYQ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 2 Jan 2014 10:24:16 -0500
Date: Thu, 2 Jan 2014 16:24:14 +0100
From: David Sterba <dsterba@suse.cz>
To: Michal Nazarewicz <mina86@mina86.com>
Cc: fdmanana@gmail.com, Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH RESEND] btrfs: remove dead code
Message-ID: <20140102152414.GK6498@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1388553589-26778-1-git-send-email-mina86@mina86.com>
 <CAL3q7H6ftrPyGK56i2EQ8fZaHa+RvaiFPR9SdJ4C9QrpFGPe=A@mail.gmail.com>
 <xa1tiou3d64l.fsf@mina86.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <xa1tiou3d64l.fsf@mina86.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jan 01, 2014 at 05:22:18PM +0100, Michal Nazarewicz wrote:
> > On Wed, Jan 1, 2014 at 5:19 AM, Michal Nazarewicz <mina86@mina86.com> wrote:
> >> [commit 8185554d: fix incorrect inode acl reset] introduced a dead
> >> code by adding a condition which can never be true to an else
> >> branch.  The condition can never be true because it is already
> >> checked by a previous if statement which causes function to return.
> 
> On Wed, Jan 01 2014, Filipe David Manana wrote:
> > Josef already added this patch to btrfs-next weeks ago:
> >
> > http://git.kernel.org/cgit/linux/kernel/git/josef/btrfs-next.git/commit/?id=c4a886e433dce2b902324a54ef2d13691a760312
> 
> Ah, sorry for the spam then.
> 
> The original thread did not mention it and this commit was not included
> in linux-next's master branch.

FYI, the patches get merged to btrfs-next without confirmations to the
mailiglist, the linux-next tree does not merge the development branches,
only when Chris publishes a branch named 'next'.
(http://linux.f-seidel.de/linux-next/pmwiki/pmwiki.php?n=Linux-next.IncludedTrees)

david
