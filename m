Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mondschein.lichtvoll.de ([194.150.191.11]:52708 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755806AbaHFKWC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 6 Aug 2014 06:22:02 -0400
From: Martin Steigerwald <Martin@lichtvoll.de>
To: Liu Bo <bo.li.liu@oracle.com>
Cc: linux-btrfs@vger.kernel.org, Chris Mason <clm@fb.com>
Subject: Re: [PATCH] Btrfs: fix compressed write corruption on enospc
Date: Wed, 06 Aug 2014 12:21:59 +0200
Message-ID: <3143412.n5KSJct7YP@merkaba>
In-Reply-To: <234528786.A5cAeyBFJU@merkaba>
References: <1406213285-19607-1-git-send-email-bo.li.liu@oracle.com> <1537782.AGn1dfcASJ@merkaba> <234528786.A5cAeyBFJU@merkaba>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am Montag, 4. August 2014, 14:50:29 schrieb Martin Steigerwald:
> Am Freitag, 25. Juli 2014, 11:54:37 schrieb Martin Steigerwald:
> > Am Donnerstag, 24. Juli 2014, 22:48:05 schrieben Sie:
> > > When failing to allocate space for the whole compressed extent, we'll
> > > fallback to uncompressed IO, but we've forgotten to redirty the pages
> > > which belong to this compressed extent, and these 'clean' pages will
> > > simply skip 'submit' part and go to endio directly, at last we got data
> > > corruption as we write nothing.
> > > 
> > > Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
> > > ---
> > > 
> > >  fs/btrfs/inode.c | 12 ++++++++++++
> > >  1 file changed, 12 insertions(+)
> > > 
> > > diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> > > index 3668048..8ea7610 100644
> > > --- a/fs/btrfs/inode.c
> > > +++ b/fs/btrfs/inode.c
> > > 
> > > @@ -709,6 +709,18 @@ retry:
> > >  				unlock_extent(io_tree, async_extent->start,
> > >  				
> > >  					      async_extent->start +
> > >  					      async_extent->ram_size - 1);
> > > 
> > > +
> > > +				/*
> > > +				 * we need to redirty the pages if we decide to
> > > +				 * fallback to uncompressed IO, otherwise we
> > > +				 * will not submit these pages down to lower
> > > +				 * layers.
> > > +				 */
> > > +				extent_range_redirty_for_io(inode,
> > > +						async_extent->start,
> > > +						async_extent->start +
> > > +						async_extent->ram_size - 1);
> > > +
> > > 
> > >  				goto retry;
> > >  			
> > >  			}
> > >  			goto out_free;
> > 
> > I am testing this currently. So far no lockup. Lets see. Still has not
> > filled the the block device with trees completely after I balanced them:
> > 
> > Label: 'home'  uuid: […]
> > 
> >         Total devices 2 FS bytes used 125.57GiB
> >         devid    1 size 160.00GiB used 153.00GiB path /dev/dm-0
> >         devid    2 size 160.00GiB used 153.00GiB path
> >         /dev/mapper/sata-home
> > 
> > I believe the lockups happen more easily if the trees occupy all of disk
> > space. Well I will do some compiling of some KDE components which may let
> > BTRFS fill all space again.
> > 
> > This patch will mean it when it can´t make enough free space in the
> > (fragmented) tree it will write uncompressed?
> > 
> > This would mean that one would have a defragment trees regularily to allow
> > for writes to happen compressed at all times.
> > 
> > Well… of course still better than lockup or corruption.
> 
> So lookups so far anymore.
> 
> Tested with 3.16-rc5, 3.16-rc7, now running 3-16 final.
> 
> /home BTRFS only got today filled completely tree-wise:
> 
> merkaba:~> btrfs fi sh /home
> Label: 'home'  uuid: […]
>         Total devices 2 FS bytes used 127.35GiB
>         devid    1 size 160.00GiB used 160.00GiB path /dev/mapper/msata-home
> devid    2 size 160.00GiB used 160.00GiB path /dev/dm-3
> 
> But I had KDE and kernel compile running full throttle at that time and
> still good.
> 
> Tested-By: Martin Steigerwald <martin@lichtvoll.de>
> 
> 
> I think this should go to stable. Thanks, Liu.

Unfortunately this fix does not seem to fix all lockups.

Just had a hard lockup again during java-bases CrashPlanPROe app backuping
company data which is stored on BTRFS via ecryptfs to central Backup server.

It basically happened on about the first heavy write I/O occasion after
the BTRFS trees filled the complete device:

I am now balancing the trees down to lower sizes manually with

btrfs balance start -dusage=10 /home

btrfs balance start -musage=10 /home

and raising values. BTW I got out of space with trying both at the same time:

merkaba:~#1> btrfs balance start -dusage=10 -musage=10 /home
ERROR: error during balancing '/home' - No space left on device
There may be more info in syslog - try dmesg | tail

merkaba:~#1> btrfs fi sh /home
Label: 'home'  uuid: […]
        Total devices 2 FS bytes used 128.76GiB
        devid    1 size 160.00GiB used 146.00GiB path /dev/dm-0
        devid    2 size 160.00GiB used 146.00GiB path /dev/mapper/sata-home

So I am pretty sure meanwhile that hangs can best be trigger *if* BTRFS
trees fill the complete device.

I will try to keep tree sizes down as a work-around for now even it if means
additional write access towards the SSD devices.

And make sure tree sizes stay down on my first server BTRFS as well although
this uses debian backport kernel 3.14 and thus may not be affected.

Are there any other fixes to try out? I really like to see this resolved. Its
in two stable kernel revisions already: 3.15 and 3.16. And by this it means
if not fixed next Debian stable (Jessie) will be affected by it.


Some kern.log (have stored the complete file)

Aug  6 12:01:16 merkaba kernel: [90496.262084] INFO: task java:21301 blocked for more than 120 seconds.
Aug  6 12:01:16 merkaba kernel: [90496.263626]       Tainted: G           O  3.16.0-tp520-fixcompwrite+ #3
Aug  6 12:01:16 merkaba kernel: [90496.265159] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
Aug  6 12:01:16 merkaba kernel: [90496.266756] java            D ffff880044e3cef0     0 21301      1 0x00000000
Aug  6 12:01:16 merkaba kernel: [90496.268353]  ffff8801960e3bd8 0000000000000002 ffff880407f649b0 ffff8801960e3fd8
Aug  6 12:01:16 merkaba kernel: [90496.269980]  ffff880044e3c9b0 0000000000013040 ffff880044e3c9b0 ffff88041e293040
Aug  6 12:01:16 merkaba kernel: [90496.271766]  ffff88041e5c6868 ffff8801960e3c70 0000000000000002 ffffffff810db1d9
Aug  6 12:01:16 merkaba kernel: [90496.273383] Call Trace:
Aug  6 12:01:16 merkaba kernel: [90496.275017]  [<ffffffff810db1d9>] ? wait_on_page_read+0x37/0x37
Aug  6 12:01:16 merkaba kernel: [90496.276630]  [<ffffffff81470fd0>] schedule+0x64/0x66
Aug  6 12:01:16 merkaba kernel: [90496.278209]  [<ffffffff81471157>] io_schedule+0x57/0x76
Aug  6 12:01:16 merkaba kernel: [90496.279817]  [<ffffffff810db1e2>] sleep_on_page+0x9/0xd
Aug  6 12:01:16 merkaba kernel: [90496.281403]  [<ffffffff8147152d>] __wait_on_bit_lock+0x41/0x85
Aug  6 12:01:16 merkaba kernel: [90496.282991]  [<ffffffff810db29f>] __lock_page+0x70/0x7c
Aug  6 12:01:16 merkaba kernel: [90496.284550]  [<ffffffff81070f3a>] ? autoremove_wake_function+0x2f/0x2f
Aug  6 12:01:16 merkaba kernel: [90496.286156]  [<ffffffffc0476617>] lock_page+0x1e/0x21 [btrfs]
Aug  6 12:01:16 merkaba kernel: [90496.287742]  [<ffffffffc0476617>] ? lock_page+0x1e/0x21 [btrfs]
Aug  6 12:01:16 merkaba kernel: [90496.289344]  [<ffffffffc047a8f4>] extent_write_cache_pages.isra.21.constprop.42+0x1a7/0x2d9 [btrfs]
Aug  6 12:01:16 merkaba kernel: [90496.290955]  [<ffffffff810dba82>] ? find_get_pages_tag+0xfc/0x123
Aug  6 12:01:16 merkaba kernel: [90496.292574]  [<ffffffffc047ae1c>] extent_writepages+0x46/0x57 [btrfs]
Aug  6 12:01:16 merkaba kernel: [90496.294154]  [<ffffffffc04650b2>] ? btrfs_submit_direct+0x3ef/0x3ef [btrfs]
Aug  6 12:01:16 merkaba kernel: [90496.295760]  [<ffffffffc046361f>] btrfs_writepages+0x23/0x25 [btrfs]
Aug  6 12:01:16 merkaba kernel: [90496.297492]  [<ffffffff810e556b>] do_writepages+0x1b/0x24
Aug  6 12:01:16 merkaba kernel: [90496.299035]  [<ffffffff810dc88a>] __filemap_fdatawrite_range+0x50/0x52
Aug  6 12:01:16 merkaba kernel: [90496.300561]  [<ffffffff810dc8f1>] filemap_fdatawrite_range+0xe/0x10
Aug  6 12:01:16 merkaba kernel: [90496.302118]  [<ffffffffc046ea30>] btrfs_sync_file+0x67/0x2bd [btrfs]
Aug  6 12:01:16 merkaba kernel: [90496.303630]  [<ffffffff810dc88a>] ? __filemap_fdatawrite_range+0x50/0x52
Aug  6 12:01:16 merkaba kernel: [90496.305158]  [<ffffffff81156289>] vfs_fsync_range+0x1c/0x1e
Aug  6 12:01:16 merkaba kernel: [90496.306669]  [<ffffffff811562a2>] vfs_fsync+0x17/0x19
Aug  6 12:01:16 merkaba kernel: [90496.308197]  [<ffffffffc04f732a>] ecryptfs_fsync+0x2f/0x34 [ecryptfs]
Aug  6 12:01:16 merkaba kernel: [90496.309711]  [<ffffffff81156289>] vfs_fsync_range+0x1c/0x1e
Aug  6 12:01:16 merkaba kernel: [90496.311249]  [<ffffffff811562a2>] vfs_fsync+0x17/0x19
Aug  6 12:01:16 merkaba kernel: [90496.312771]  [<ffffffff811564c9>] do_fsync+0x2c/0x45
Aug  6 12:01:16 merkaba kernel: [90496.314288]  [<ffffffff811566af>] SyS_fsync+0xb/0xf
Aug  6 12:01:16 merkaba kernel: [90496.315800]  [<ffffffff8147420b>] tracesys+0xdd/0xe2



Aug  6 12:01:16 merkaba kernel: [90496.380221] INFO: task java:21563 blocked for more than 120 seconds.
Aug  6 12:01:16 merkaba kernel: [90496.381691]       Tainted: G           O  3.16.0-tp520-fixcompwrite+ #3
Aug  6 12:01:16 merkaba kernel: [90496.383192] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
Aug  6 12:01:16 merkaba kernel: [90496.384687] java            D ffff880038111dd0     0 21563      1 0x00000000
Aug  6 12:01:16 merkaba kernel: [90496.386203]  ffff88006df0fbd8 0000000000000002 ffffffff81a15500 ffff88006df0ffd8
Aug  6 12:01:16 merkaba kernel: [90496.387843]  ffff880038111890 0000000000013040 ffff880038111890 ffff88041e213040
Aug  6 12:01:16 merkaba kernel: [90496.389414]  ffff88041e5cc568 ffff88006df0fc70 0000000000000002 ffffffff810db1d9
Aug  6 12:01:16 merkaba kernel: [90496.391031] Call Trace:
Aug  6 12:01:16 merkaba kernel: [90496.392574]  [<ffffffff810db1d9>] ? wait_on_page_read+0x37/0x37
Aug  6 12:01:16 merkaba kernel: [90496.394154]  [<ffffffff81470fd0>] schedule+0x64/0x66
Aug  6 12:01:16 merkaba kernel: [90496.395686]  [<ffffffff81471157>] io_schedule+0x57/0x76
Aug  6 12:01:16 merkaba kernel: [90496.397218]  [<ffffffff810db1e2>] sleep_on_page+0x9/0xd
Aug  6 12:01:16 merkaba kernel: [90496.398723]  [<ffffffff8147152d>] __wait_on_bit_lock+0x41/0x85
Aug  6 12:01:16 merkaba kernel: [90496.400232]  [<ffffffff810db29f>] __lock_page+0x70/0x7c
Aug  6 12:01:16 merkaba kernel: [90496.401895]  [<ffffffff81070f3a>] ? autoremove_wake_function+0x2f/0x2f
Aug  6 12:01:16 merkaba kernel: [90496.403440]  [<ffffffffc0476617>] lock_page+0x1e/0x21 [btrfs]
Aug  6 12:01:16 merkaba kernel: [90496.404942]  [<ffffffffc0476617>] ? lock_page+0x1e/0x21 [btrfs]
Aug  6 12:01:16 merkaba kernel: [90496.406433]  [<ffffffffc047a8f4>] extent_write_cache_pages.isra.21.constprop.42+0x1a7/0x2d9 [btrfs]
Aug  6 12:01:16 merkaba kernel: [90496.407950]  [<ffffffff810dba82>] ? find_get_pages_tag+0xfc/0x123
Aug  6 12:01:16 merkaba kernel: [90496.409474]  [<ffffffffc047ae1c>] extent_writepages+0x46/0x57 [btrfs]
Aug  6 12:01:16 merkaba kernel: [90496.411020]  [<ffffffffc04650b2>] ? btrfs_submit_direct+0x3ef/0x3ef [btrfs]
Aug  6 12:01:16 merkaba kernel: [90496.412558]  [<ffffffffc046361f>] btrfs_writepages+0x23/0x25 [btrfs]
Aug  6 12:01:16 merkaba kernel: [90496.414102]  [<ffffffff810e556b>] do_writepages+0x1b/0x24
Aug  6 12:01:16 merkaba kernel: [90496.415621]  [<ffffffff810dc88a>] __filemap_fdatawrite_range+0x50/0x52
Aug  6 12:01:16 merkaba kernel: [90496.417184]  [<ffffffff810dc8f1>] filemap_fdatawrite_range+0xe/0x10
Aug  6 12:01:16 merkaba kernel: [90496.418753]  [<ffffffffc046ea30>] btrfs_sync_file+0x67/0x2bd [btrfs]
Aug  6 12:01:16 merkaba kernel: [90496.420344]  [<ffffffff810dc88a>] ? __filemap_fdatawrite_range+0x50/0x52
Aug  6 12:01:16 merkaba kernel: [90496.421914]  [<ffffffff81156289>] vfs_fsync_range+0x1c/0x1e
Aug  6 12:01:16 merkaba kernel: [90496.423467]  [<ffffffff811562a2>] vfs_fsync+0x17/0x19
Aug  6 12:01:16 merkaba kernel: [90496.425051]  [<ffffffffc04f732a>] ecryptfs_fsync+0x2f/0x34 [ecryptfs]
Aug  6 12:01:16 merkaba kernel: [90496.426593]  [<ffffffff81156289>] vfs_fsync_range+0x1c/0x1e
Aug  6 12:01:16 merkaba kernel: [90496.428280]  [<ffffffff811562a2>] vfs_fsync+0x17/0x19
Aug  6 12:01:16 merkaba kernel: [90496.429853]  [<ffffffff811564c9>] do_fsync+0x2c/0x45
Aug  6 12:01:16 merkaba kernel: [90496.431351]  [<ffffffff811566af>] SyS_fsync+0xb/0xf
Aug  6 12:01:16 merkaba kernel: [90496.432841]  [<ffffffff8147420b>] tracesys+0xdd/0xe2



Aug  6 12:01:16 merkaba kernel: [90496.434306] INFO: task kworker/u8:3:21401 blocked for more than 120 seconds.
Aug  6 12:01:16 merkaba kernel: [90496.435814]       Tainted: G           O  3.16.0-tp520-fixcompwrite+ #3
Aug  6 12:01:16 merkaba kernel: [90496.437328] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
Aug  6 12:01:16 merkaba kernel: [90496.438885] kworker/u8:3    D ffff880133ebe780     0 21401      2 0x00000000
Aug  6 12:01:16 merkaba kernel: [90496.440464] Workqueue: btrfs-flush_delalloc normal_work_helper [btrfs]
Aug  6 12:01:16 merkaba kernel: [90496.442037]  ffff88003e953b18 0000000000000002 ffffffff81a15500 ffff88003e953fd8
Aug  6 12:01:16 merkaba kernel: [90496.443639]  ffff880133ebe240 0000000000013040 ffff880133ebe240 ffff88041e213040
Aug  6 12:01:16 merkaba kernel: [90496.445246]  ffff88041e5bc968 ffff88003e953bb0 0000000000000002 ffffffff810db1d9
Aug  6 12:01:16 merkaba kernel: [90496.446901] Call Trace:
Aug  6 12:01:16 merkaba kernel: [90496.448485]  [<ffffffff810db1d9>] ? wait_on_page_read+0x37/0x37
Aug  6 12:01:16 merkaba kernel: [90496.450081]  [<ffffffff81470fd0>] schedule+0x64/0x66
Aug  6 12:01:16 merkaba kernel: [90496.451682]  [<ffffffff81471157>] io_schedule+0x57/0x76
Aug  6 12:01:16 merkaba kernel: [90496.453271]  [<ffffffff810db1e2>] sleep_on_page+0x9/0xd
Aug  6 12:01:16 merkaba kernel: [90496.455037]  [<ffffffff8147152d>] __wait_on_bit_lock+0x41/0x85
Aug  6 12:01:16 merkaba kernel: [90496.456617]  [<ffffffff810db29f>] __lock_page+0x70/0x7c
Aug  6 12:01:16 merkaba kernel: [90496.458203]  [<ffffffff81070f3a>] ? autoremove_wake_function+0x2f/0x2f
Aug  6 12:01:16 merkaba kernel: [90496.459793]  [<ffffffffc0476617>] lock_page+0x1e/0x21 [btrfs]
Aug  6 12:01:16 merkaba kernel: [90496.461353]  [<ffffffffc0476617>] ? lock_page+0x1e/0x21 [btrfs]
Aug  6 12:01:16 merkaba kernel: [90496.462917]  [<ffffffffc047a8f4>] extent_write_cache_pages.isra.21.constprop.42+0x1a7/0x2d9 [btrfs]
Aug  6 12:01:16 merkaba kernel: [90496.464479]  [<ffffffff81009e60>] ? native_sched_clock+0x3a/0x3c
Aug  6 12:01:16 merkaba kernel: [90496.466036]  [<ffffffffc047ae1c>] extent_writepages+0x46/0x57 [btrfs]
Aug  6 12:01:16 merkaba kernel: [90496.467632]  [<ffffffff81066fbf>] ? task_group_account_field+0x3b/0x40
Aug  6 12:01:16 merkaba kernel: [90496.469168]  [<ffffffffc04650b2>] ? btrfs_submit_direct+0x3ef/0x3ef [btrfs]
Aug  6 12:01:16 merkaba kernel: [90496.470737]  [<ffffffffc046361f>] btrfs_writepages+0x23/0x25 [btrfs]
Aug  6 12:01:16 merkaba kernel: [90496.472307]  [<ffffffff810e556b>] do_writepages+0x1b/0x24
Aug  6 12:01:16 merkaba kernel: [90496.473885]  [<ffffffff810dc88a>] __filemap_fdatawrite_range+0x50/0x52
Aug  6 12:01:16 merkaba kernel: [90496.475458]  [<ffffffff810dd1b3>] filemap_flush+0x17/0x19
Aug  6 12:01:16 merkaba kernel: [90496.477041]  [<ffffffffc0465df9>] btrfs_run_delalloc_work+0x2e/0x64 [btrfs]
Aug  6 12:01:16 merkaba kernel: [90496.478624]  [<ffffffffc04863d7>] normal_work_helper+0xdf/0x224 [btrfs]
Aug  6 12:01:16 merkaba kernel: [90496.480257]  [<ffffffff81052d8c>] process_one_work+0x16f/0x2b8
Aug  6 12:01:16 merkaba kernel: [90496.481977]  [<ffffffff81053636>] worker_thread+0x27b/0x32e
Aug  6 12:01:16 merkaba kernel: [90496.483544]  [<ffffffff810533bb>] ? cancel_delayed_work_sync+0x10/0x10
Aug  6 12:01:16 merkaba kernel: [90496.485082]  [<ffffffff81058012>] kthread+0xb2/0xba
Aug  6 12:01:16 merkaba kernel: [90496.486624]  [<ffffffff81470000>] ? ap_handle_dropped_data+0xf/0xc8
Aug  6 12:01:16 merkaba kernel: [90496.488148]  [<ffffffff81057f60>] ? __kthread_parkme+0x62/0x62
Aug  6 12:01:16 merkaba kernel: [90496.489719]  [<ffffffff81473f6c>] ret_from_fork+0x7c/0xb0
Aug  6 12:01:16 merkaba kernel: [90496.491265]  [<ffffffff81057f60>] ? __kthread_parkme+0x62/0x62


Ciao,
-- 
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
