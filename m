Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:58328 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750971AbaDOPoO (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 15 Apr 2014 11:44:14 -0400
Date: Tue, 15 Apr 2014 17:44:12 +0200
From: David Sterba <dsterba@suse.cz>
To: Chris Mason <clm@fb.com>
Cc: David Sterba <dsterba@suse.cz>, linux-btrfs@vger.kernel.org,
        Miao Xie <miaox@cn.fujitsu.com>,
        Wang Shilong <wangsl.fnst@cn.fujitsu.com>
Subject: Re: [PATCH 1/2] btrfs: protect snapshots from deleting during send
Message-ID: <20140415154412.GU29256@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <cover.1397572052.git.dsterba@suse.cz>
 <6c15e8cf5f832398461e8dbde0a02255c35fdd4b.1397572052.git.dsterba@suse.cz>
 <534D479E.3070200@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <534D479E.3070200@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Apr 15, 2014 at 10:52:14AM -0400, Chris Mason wrote:
> On 04/15/2014 10:41 AM, David Sterba wrote:
> >The patch "Btrfs: fix protection between send and root deletion"
> >(18f687d538449373c37c) does not actually prevent to delete the snapshot
> >and just takes care during background cleaning, but this seems rather
> >user unfriendly, this patch implements the idea presented in
> >
> >http://www.spinics.net/lists/linux-btrfs/msg30813.html
> >
> >- add an internal root_item flag to denote a dead root
> >- check if the send_in_progress is set and refuse to delete, otherwise
> >   set the flag and proceed
> >- check the flag in send similar to the btrfs_root_readonly checks, for
> >   all involved roots
> >
> >The root lookup in send via btrfs_read_fs_root_no_name will check if the
> >root is really dead or not. If it is, ENOENT, aborted send. If it's
> >alive, it's protected by send_in_progress, send can continue.
> 
> I'm worried about the use case where we have:
> 
>   * periodic automated snapshots
>   * periodic automated deletion of old snapshots
>   * periodic send for backup
> 
> The automated deletion doesn't want to error out if send is in progress, it
> just wants the deletion to happen in the background.

I'd give the precedence to the 'backup' process before the 'clean old
snapshots', because it can do more harm if the snapshot is removed
meanwhile without any possibility to recover.

I understand that send does not have to be done only for the backup
purposes, the snapshots can be recreated in case of error, etc.

Adding more tunables would lead to confusion and usability mess, eg.
somehow mark the snapshot as disposable, or not, wrt the
send-in-progress status. I don't want to go that way.

The automatic deletion process is external to btrfs and has more context
of what to do if the subvolume deletion fails, for example schedule
another deletion attempt.

I don't think this would cause severe problems if the the snapshots live
for a bit longer, but yes it needs more work on the user's side.
