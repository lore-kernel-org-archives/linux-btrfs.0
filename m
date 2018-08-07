Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:36636 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2388943AbeHGTYc (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 7 Aug 2018 15:24:32 -0400
Date: Tue, 7 Aug 2018 19:09:09 +0200
From: David Sterba <dsterba@suse.cz>
To: Anand Jain <anand.jain@oracle.com>
Cc: Nikolay Borisov <nborisov@suse.com>, linux-btrfs@vger.kernel.org,
        David Sterba <dsterba@suse.cz>
Subject: Re: [PATCH] btrfs: handle the BUG_ON in btrfs_num_devices()
Message-ID: <20180807170908.GQ3218@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180726065334.30594-1-anand.jain@oracle.com>
 <20180803124526.18497-1-anand.jain@oracle.com>
 <20180803124526.18497-2-anand.jain@oracle.com>
 <9f7d4969-6496-ad5a-a0f9-71bade56e3a6@suse.com>
 <6b4efd17-d04f-6b3b-32c6-28d7ecba4510@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <6b4efd17-d04f-6b3b-32c6-28d7ecba4510@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Aug 06, 2018 at 04:57:45PM +0800, Anand Jain wrote:
> 
> 
> On 08/03/2018 09:33 PM, Nikolay Borisov wrote:
> > 
> > 
> > On  3.08.2018 15:45, Anand Jain wrote:
> >> Its a logical bug if we hit fs_devices::num_devices == 1 and if the
> >> replace is running because, as fs_devices::num_devices counts the in memory
> >> devices, so it should include the replace target which is running as
> >> indicated by the flag. If this happens return the -EINVAL back.
> >>
> >> Suggested-by: Nikolay Borisov <nborisov@suse.com>
> >> Signed-off-by: Anand Jain <anand.jain@oracle.com>
> >> ---
> >> Hi,
> >>   As it fixes the BUG_ON I have spun a new patch for this.
> >>   Instead of -EINVAL should we use ASSERT?
> >>
> >>   fs/btrfs/volumes.c | 27 ++++++++++++++++++++-------
> >>   1 file changed, 20 insertions(+), 7 deletions(-)
> >>
> >> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
> >> index 7359596ac8eb..ed2399caff80 100644
> >> --- a/fs/btrfs/volumes.c
> >> +++ b/fs/btrfs/volumes.c
> >> @@ -1855,9 +1855,11 @@ void btrfs_assign_next_active_device(struct btrfs_device *device,
> >>   }
> >>   
> >>   /* Returns btrfs_fs_devices::num_devices minus replace device if any */
> >> -static u64 btrfs_num_devices(struct btrfs_fs_info *fs_info)
> >> +static int btrfs_num_devices(struct btrfs_fs_info *fs_info, u64 *num_devices)
> > 
> > Why do you resort to this travesty of returning the value in an input
> > parameter? Having the function return int, assuming that we will always
> > have a positive device num and in case of an error return a negative
> > value. In the worst case when we get to see a btrfs fs consisting of 2
> > billion devices then we can start worrying that an int here won't do it.
> 
>   Its theoretically wrong. I wonder if David is OK with this? Will wait
>   for his comments.

Theoretically, as in having 2^64 devices where the numbers would clash
with error code. Practically we're talking about tens maybe hundreds of
devices, anything that fits to 32 bits in the forseeable future. Yes I
agree with Nikolai.

But the BUG_ON can be removed, or the number of devices can be checked
in advance as mentioned in other mails, I'm starting to lose track of
what's the last version.
