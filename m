Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:59023 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750901AbaDOQ1f (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 15 Apr 2014 12:27:35 -0400
Date: Tue, 15 Apr 2014 18:27:34 +0200
From: David Sterba <dsterba@suse.cz>
To: Chris Mason <clm@fb.com>
Cc: linux-btrfs@vger.kernel.org, Miao Xie <miaox@cn.fujitsu.com>,
        Wang Shilong <wangsl.fnst@cn.fujitsu.com>
Subject: Re: [PATCH 1/2] btrfs: protect snapshots from deleting during send
Message-ID: <20140415162734.GX29256@suse.cz>
Reply-To: dsterba@suse.cz
References: <cover.1397572052.git.dsterba@suse.cz>
 <6c15e8cf5f832398461e8dbde0a02255c35fdd4b.1397572052.git.dsterba@suse.cz>
 <534D479E.3070200@fb.com>
 <20140415154412.GU29256@twin.jikos.cz>
 <534D57B1.6090501@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <534D57B1.6090501@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Apr 15, 2014 at 12:00:49PM -0400, Chris Mason wrote:
> >>I'm worried about the use case where we have:
> >>
> >>   * periodic automated snapshots
> >>   * periodic automated deletion of old snapshots
> >>   * periodic send for backup
> >>
> >>The automated deletion doesn't want to error out if send is in progress, it
> >>just wants the deletion to happen in the background.
> >
> >I'd give the precedence to the 'backup' process before the 'clean old
> >snapshots', because it can do more harm if the snapshot is removed
> >meanwhile without any possibility to recover.
> 
> Right, we don't want either process to stop with an error.  We just want
> them to continue happily and do the right thing...

... if everything goes without errors. Not like send going out of
memory, send through network has a glitch, send to a file runs out of
space, and has to be restarted. Is this too unrealistic to happen?
