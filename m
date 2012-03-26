From: Felix Blanke <felixblanke@gmail.com>
Subject: Re: btrfs and backups
Date: Mon, 26 Mar 2012 10:56:52 +0200
Message-ID: <4F702F54.90300@gmail.com>
References: <CAAMvbhFkaz7_N99D3Gu0WcBPKF2oTdaEfZXQDsUE1fRgSi5msw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Cc: linux-btrfs@vger.kernel.org
To: James Courtier-Dutton <james.dutton@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <CAAMvbhFkaz7_N99D3Gu0WcBPKF2oTdaEfZXQDsUE1fRgSi5msw@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On 3/26/12 10:30 AM, James Courtier-Dutton wrote:
> Hi,
>
> I have a local btrfs file system with various sub-volumes that have
> had snapshots done on them.
>
> Is there some tool like rsync that I could copy all the data and
> snapshots to a backup system, but still only use the same amount of
> space as the source filesystem.
> I see a problem being getting a consistent and steady state during the rsync.
> I was thinking that I might be able to do this with LVM snapshots, but
> that would require something along these lines:
> 1) pause the btrfs filesystem into a consistent state that can be
> mounted cleanly
> 2) Do LVM snapshot on it.
> 3) un-pause btrfs filesystem.
>
> I can then do a block level backup of the LVM snapshot and it should
> be mountable on the backup server.
> So, the snapshot is not a snapshot of the current filesystem, it is a
> snapshot of all the snapshots and all the sub-volumes at a particular
> time, that is in a stable state to be backed up.
>
> I don't know if 1 is supported?
> I suppose I am hoping for 1,2,3 to already be supported by some
> special btrfs command.
>
>
> Any ideas?


I'm not sure if I understand your problem right, but I would suggest:

1) Snapshot the subvolume on the source
2) rsync the snapshot to the destination
3) Snapshot the destination

Kind regards,
Felix

>
> Kind Regards
>
> James
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
