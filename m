Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ob0-f179.google.com ([209.85.214.179]:58997 "EHLO
	mail-ob0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752982Ab3AYSQa (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 25 Jan 2013 13:16:30 -0500
Received: by mail-ob0-f179.google.com with SMTP id un3so788696obb.24
        for <linux-btrfs@vger.kernel.org>; Fri, 25 Jan 2013 10:16:29 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20130125154236.GA3997@liubo>
References: <1358339768-2314-1-git-send-email-bo.li.liu@oracle.com>
	<CAKcLGm8QDNEs3nF=VDGtRWVV9MNg9SZr0ZBH1fiqTRgJyJgOvg@mail.gmail.com>
	<CAKcLGm9RXjS1yCK7oXKHVbVoH-bMXPM1PPpHTrwMh+Ubnx8gkA@mail.gmail.com>
	<20130123075155.GE17162@liubo.jp.oracle.com>
	<CAKcLGm97CSThaz9u0sj8BE=bMGObc6rqCsmzf0AneWfhxfZFDw@mail.gmail.com>
	<20130124005221.GA28406@liubo>
	<CAKcLGm_Casj44A3OL3hpsYAL9szb3-F+8C2fsLow9Trk_y=7dg@mail.gmail.com>
	<20130125154236.GA3997@liubo>
Date: Fri, 25 Jan 2013 12:16:29 -0600
Message-ID: <CAKcLGm_fyGU3rXKvBfcjQtJDx+1JrbxiDAw1w0EpnPcc2xiHvA@mail.gmail.com>
Subject: Re: [PATCH V5] Btrfs: snapshot-aware defrag
From: Mitch Harder <mitch.harder@sabayonlinux.org>
To: bo.li.liu@oracle.com
Cc: linux-btrfs@vger.kernel.org, chris.mason@fusionio.com, JBacik@fusionio.com,
        dave@jikos.cz, kitayama@cl.bb4u.ne.jp, miaox@cn.fujitsu.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jan 25, 2013 at 9:42 AM, Liu Bo <bo.li.liu@oracle.com> wrote:
> On Fri, Jan 25, 2013 at 08:55:58AM -0600, Mitch Harder wrote:
>> On Wed, Jan 23, 2013 at 6:52 PM, Liu Bo <bo.li.liu@oracle.com> wrote:
>> > On Wed, Jan 23, 2013 at 10:05:04AM -0600, Mitch Harder wrote:
>> >> On Wed, Jan 23, 2013 at 1:51 AM, Liu Bo <bo.li.liu@oracle.com> wrote:
>> >> > On Tue, Jan 22, 2013 at 11:41:19AM -0600, Mitch Harder wrote:
>> >> >> On Thu, Jan 17, 2013 at 8:42 AM, Mitch Harder
>> >> >> <mitch.harder@sabayonlinux.org> wrote:
>> >> >> > On Wed, Jan 16, 2013 at 6:36 AM, Liu Bo <bo.li.liu@oracle.com> wrote:
>> >> >> >> This comes from one of btrfs's project ideas,
>> >> >> >> As we defragment files, we break any sharing from other snapshots.
>> >> >> >> The balancing code will preserve the sharing, and defrag needs to grow this
>> >> >> >> as well.
>> >> > [...]
>> >> >> >
>> >> >> > I've been testing this patch on a 3.7.2 kernel merged with the
>> >> >> > for-linus branch for the 3.8_rc kernels, and I'm seeing the following
>> >> >> > error:
>> >> >> >
>> >> >>
>> >> >> I've reproduced the error with CONFIG_DEBUG_LIST enabled, which shows
>> >> >> some problem with an entry in the list.
>> >> >>
>> >> >> [59312.260441] ------------[ cut here ]------------
>> >> >> [59312.260454] WARNING: at lib/list_debug.c:62 __list_del_entry+0x8d/0x98()
>> >> >> [59312.260458] Hardware name: OptiPlex 745
>> >> >> [59312.260461] list_del corruption. next->prev should be
>> >> >> ffff88006511c438, but was dead000000200200
>> >> >
>> >> > LIST_POISON2 -> (000000200200)
>> >> > So we can know that the next one is deleted from the list even _earlier_
>> >> > than the current one is.
>> >> >
>> >> > Any other messages before this warning complains?
>> >> >
>> >>
>> >> Just some normal feedback from a metadata balance I had run.
>> >
>> > Well, these do fit my expectation, since balance also involves with playing with
>> > root_list, which may lead to the bad situation.
>> >
>> >>
>> >> [14057.193343] device fsid 28c688c5-7dbd-4071-b271-1bf6726d8835 devid
>> >> 1 transid 4 /dev/sda7
>> >> [14057.194438] btrfs: force lzo compression
>> >> [14057.194446] btrfs: enabling auto defrag
>> >> [14057.194449] btrfs: disk space caching is enabled
>> >> [14057.194452] btrfs flagging fs with big metadata feature
>> >> [14057.194455] btrfs: lzo incompat flag set.
>> >> [57508.799193] btrfs: relocating block group 14516486144 flags 4
>> >> [57632.178797] btrfs: found 6775 extents
>> >> [57633.214701] btrfs: relocating block group 11832131584 flags 4
>> >> [57776.400102] btrfs: found 6480 extents
>> >> [57777.021175] btrfs: relocating block group 10489954304 flags 4
>> >> [57949.182725] btrfs: found 6681 extents
>> >> [59312.260441] ------------[ cut here ]------------
>> >> [59312.260454] WARNING: at lib/list_debug.c:62 __list_del_entry+0x8d/0x98()
>> >> [59312.260458] Hardware name: OptiPlex 745
>> >> ...
>> >>
>> >> I'm going to try to wrap some debugging around the section of code in
>> >> btrfs_clean_old_snapshots() where the dead_roots list is spliced onto
>> >> the root list being processed.  The double entry may be slipping in
>> >> here.
>> >>
>> >> 1764         spin_lock(&fs_info->trans_lock);
>> >> 1765         list_splice_init(&fs_info->dead_roots, &list);
>> >> 1766         spin_unlock(&fs_info->trans_lock);
>> >
>> > hmm, I don't think there is anything wrong in this code.  But you can
>> > give it a shot anyway :)
>> >
>>
>> I've changed up my reproducer to try some things that may hit the
>> issue quicker and more reliably.
>>
>> It gave me a slightly different set of warnings in dmesg, which seem
>> to suggest issues in the dead_root list.
>
> Great!  Many thanks for nail it down, we really shouldn't iput()
> after btrfs_iget().
>
> Could you please try this(remove iput()) and see if it gets us rid of
> the trouble?
>
> thanks,
> liubo
>
> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> index 1683f48..c7a0fb7 100644
> --- a/fs/btrfs/inode.c
> +++ b/fs/btrfs/inode.c
> @@ -2337,7 +2337,6 @@ out_free_path:
>  out_unlock:
>         unlock_extent_cached(&BTRFS_I(inode)->io_tree, lock_start,
> lock_end,
>                              &cached, GFP_NOFS);
> -       iput(inode);
>         return ret;
>  }
>

With this patch, the cleaner never runs to delete the old roots.
