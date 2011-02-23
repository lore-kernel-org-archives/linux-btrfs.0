From: Josef Bacik <josef@redhat.com>
Subject: Re: [PATCH] btrfs: make inode ref log recovery faster
Date: Tue, 22 Feb 2011 20:30:05 -0500
Message-ID: <20110223013004.GE26100@dhcp231-156.rdu.redhat.com>
References: <4D63A121.3090605@cn.fujitsu.com> <20110222143203.GB18570@twin.jikos.cz> <4D645F04.4060608@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Linux Btrfs <linux-btrfs@vger.kernel.org>
To: liubo <liubo2009@cn.fujitsu.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4D645F04.4060608@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Feb 23, 2011 at 09:12:36AM +0800, liubo wrote:
> On 02/22/2011 10:32 PM, David Sterba wrote:
> > Hi,
> > 
> > no deeper analysis done, but the double free error was obvious :)
> > 
> > On Tue, Feb 22, 2011 at 07:42:25PM +0800, liubo wrote:
> >> When we recover from crash via write-ahead log tree and process
> >> the inode refs, for each btrfs_inode_ref item, we will
> >> 1) check if we already have a perfect match in fs/file tree, if
> >>    we have, then we're done.
> >> 2) search the corresponding back reference in fs/file tree, and
> >>    check all the names in this back reference to see if they are
> >>    also in the log to avoid conflict corners.
> >> 3) recover the logged inode refs to fs/file tree.
> >>
> >> In current btrfs, however,
> >> - for 2)'s check, once is enough, since the checked back references
> >>   will remain unchanged after processing all the inode refs belonged
> >>   to the key.
> >> - it has no need to do another 1) between 2) and 3).
> >>
> >> This patch focus on the above problems and
> >> I've made a small test to show how it improves,
> >>
> >> $dd if=/dev/zero of=foobar bs=4K count=1
> >> $sync
> >> $make 100 hard links continuously, like ln foobar link_i
> >> $fsync foobar
> >> $echo b > /proc/sysrq-trigger
> >> after reboot
> >> $time mount DEV PATH
> >>
> >> without patch:
> >> real	0m0.285s
> >> user	0m0.001s
> >> sys	0m0.009s
> >>
> >> with patch:
> >> real	0m0.123s
> >> user	0m0.000s
> >> sys	0m0.010s
> >>
> >> Signed-off-by: Liu Bo <liubo2009@cn.fujitsu.com>
> >> ---
> >>  fs/btrfs/tree-log.c |   33 +++++++++++----------------------
> >>  1 files changed, 11 insertions(+), 22 deletions(-)
> >>
> >> diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
> >> index a4bbb85..8f2a9f3 100644
> >> --- a/fs/btrfs/tree-log.c
> >> +++ b/fs/btrfs/tree-log.c
> >> @@ -799,12 +799,12 @@ static noinline int add_inode_ref(struct btrfs_trans_handle *trans,
> >>  	struct inode *dir;
> >>  	int ret;
> >>  	struct btrfs_inode_ref *ref;
> >> -	struct btrfs_dir_item *di;
> >>  	struct inode *inode;
> >>  	char *name;
> >>  	int namelen;
> >>  	unsigned long ref_ptr;
> >>  	unsigned long ref_end;
> >> +	int search_done = 0;
> >>  
> >>  	/*
> >>  	 * it is possible that we didn't log all the parent directories
> >> @@ -845,7 +845,10 @@ again:
> >>  	 * existing back reference, and we don't want to create
> >>  	 * dangling pointers in the directory.
> >>  	 */
> >> -conflict_again:
> >> +
> >> +	if (search_done)
> >> +		goto insert;
> >> +
> >>  	ret = btrfs_search_slot(NULL, root, key, path, 0, 0);
> >>  	if (ret == 0) {
> >>  		char *victim_name;
> >> @@ -888,35 +891,21 @@ conflict_again:
> >>  							 victim_name_len);
> >>  				kfree(victim_name);
> >                                 ^^^^^^^^^^^^^^^^^^^
> >>  				btrfs_release_path(root, path);
> >> -				goto conflict_again;
> >>  			}
> >>  			kfree(victim_name);
> >                         ^^^^^^^^^^^^^^^^^^^
> > double free
> 
> thanks for reviewing, but the first one is followed by a goto phrase, so IMO it is ok.
>

Your patch removes that goto, so it's not ok.  Thanks,

Josef 
