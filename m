Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:33874 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2388005AbeGWO7S (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 23 Jul 2018 10:59:18 -0400
Date: Mon, 23 Jul 2018 15:57:44 +0200
From: David Sterba <dsterba@suse.cz>
To: Anand Jain <anand.jain@oracle.com>
Cc: dsterba@suse.cz, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 6/7] btrfs: add helper btrfs_num_devices() to deduce
 num_devices
Message-ID: <20180723135743.GM26141@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180716145812.20836-1-anand.jain@oracle.com>
 <20180716145812.20836-7-anand.jain@oracle.com>
 <20180719115332.GI26141@twin.jikos.cz>
 <d3fc6178-0884-28cf-ac3e-e42a00682150@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <d3fc6178-0884-28cf-ac3e-e42a00682150@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jul 20, 2018 at 07:18:54PM +0800, Anand Jain wrote:
> 
> 
> On 07/19/2018 07:53 PM, David Sterba wrote:
> > On Mon, Jul 16, 2018 at 10:58:11PM +0800, Anand Jain wrote:
> >> When the replace is running the fs_devices::num_devices also includes
> >> the replace device, however in some operations like device delete and
> >> balance it needs the actual num_devices without the repalce devices, so
> >> now the function btrfs_num_devices() just provides that.
> > 
> > We can't run any two from device delete, device replace or balance at
> > the same time.
> > 
> >>
> >> Signed-off-by: Anand Jain <anand.jain@oracle.com>
> >> ---
> >> v2: add comments. Thanks Nikolay.
> >>
> >>   fs/btrfs/volumes.c | 32 ++++++++++++++++++--------------
> >>   1 file changed, 18 insertions(+), 14 deletions(-)
> >>
> >> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
> >> index 0f4c512aa6b4..1c0b56374992 100644
> >> --- a/fs/btrfs/volumes.c
> >> +++ b/fs/btrfs/volumes.c
> >> @@ -1844,6 +1844,21 @@ void btrfs_assign_next_active_device(struct btrfs_fs_info *fs_info,
> >>   		fs_info->fs_devices->latest_bdev = next_device->bdev;
> >>   }
> >>   
> >> +/* Returns btrfs_fs_devices::num_devices excluding replace device if any */
> >> +static inline u64 btrfs_num_devices(struct btrfs_fs_info *fs_info)
> >> +{
> >> +	u64 num_devices = fs_info->fs_devices->num_devices;
> >> +
> >> +	btrfs_dev_replace_read_lock(&fs_info->dev_replace);
> >> +	if (btrfs_dev_replace_is_ongoing(&fs_info->dev_replace)) {
> >> +		WARN_ON(num_devices < 1);
> >> +		num_devices--;
> >> +	}
> >> +	btrfs_dev_replace_read_unlock(&fs_info->dev_replace);
> 
> 
> 
> > This does not make sense, besides that > btrfs_dev_replace_is_ongoing is
> > always going to be false here,
> 
>   No. There is a way how balance and replace could co-exists.
>   (theoretically, I didn't experiment it yet)
>   . Start balance and pause it
>   . Now start the replace
>   . power-fail
>   . The open_ctree() first starts the balance so it must check
>   for the replace device otherwise our num_devices calculation will
>   be wrong. IMO its not a good idea to remove the replace check here.

I see, the paused states can lead to balance that sees device replace
ongoing as true. This would be good to add to the function comment as
it's not quite obvious why the helper is needed.

>   For now a consolidation as in this patch is better.

Yeah, for this context it would be good.  The function name could be
more descriptive what devices it actually counts.
