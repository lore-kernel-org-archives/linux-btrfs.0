From: Josef Bacik <josef@redhat.com>
Subject: Re: kernel BUG at fs/btrfs/extent_io.c:3982!
Date: Thu, 3 May 2012 10:53:17 -0400
Message-ID: <20120503145317.GE1914@localhost.localdomain>
References: <4F848C62.6030100@sandia.gov>
 <20120411190926.GE2506@localhost.localdomain>
 <4F85E87E.90804@sandia.gov>
 <20120501160047.GA2050@localhost.localdomain>
 <4FA01239.7080907@sandia.gov>
 <4FA29994.6030009@sandia.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Josef Bacik <josef@redhat.com>, linux-btrfs@vger.kernel.org
To: Jim Schutt <jaschut@sandia.gov>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4FA29994.6030009@sandia.gov>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, May 03, 2012 at 08:43:32AM -0600, Jim Schutt wrote:
> On 05/01/2012 10:41 AM, Jim Schutt wrote:
> >On 05/01/2012 10:00 AM, Josef Bacik wrote:
> >>On Wed, Apr 11, 2012 at 02:24:30PM -0600, Jim Schutt wrote:
> >>>On 04/11/2012 01:09 PM, Josef Bacik wrote:
> >>>>On Tue, Apr 10, 2012 at 01:39:14PM -0600, Jim Schutt wrote:
> >>>>>Hi,
> >>>>>
> >>>>>I hit this BUG today.
> >>>>>
> >>>>>I'm running 3.3.1 merged with the ceph and btrfs bits for 3.4,
> >>>>>i.e. 3.3.1 +
> >>>>>commit bc3f116fec194 "Btrfs: update the checks for mixed block groups with big metadata blocks"
> >>>>>commit c666601a935b9 "rbd: move snap_rwsem to the device, rename to header_rwsem"
> >>>>>
> >>>>>The btrfs filesystem in question is backing a Ceph OSD under
> >>>>>a heavy write load.
> >>>>>
> >>>>>Here's the bug:
> >>>>>
> >>>>
> >>>>Can you give this a whirl and let me know how it goes? If I'm right you should
> >>>>see a warning pop up in your messages. Thanks,
> >>>
> >>>OK, I've got my test running with your patch applied
> >>>to my previous kernel.
> >>>
> >>>Do you expect your warning to only fire when my
> >>>previous kernel would have BUGged? I ask because I've
> >>>only seen the BUG once, so it may be a low-probability
> >>>occurrence.
> >>>
> >>>It seems like I should keep testing until I see either
> >>>your new warning or the BUG, right?
> >>
> >>Hey Jim,
> >>
> >>I just sent a patch to the list
> >>
> >>[PATCH] Btrfs: fix page leak when allocing extent buffers
> >>
> >>Could you try that and see if you can reproduce your problem?
> >
> >Taking it for a spin now...
> >
> 
> Hit it again:
> 

Argh ok it's time to stop hopping around the problem and see what exactly the
state is when this happens so I know where to look.  Can you run with this patch
and give me the dmesg?  The important information will be above the --- cut here
 --- line so make sure to grab that part.  Thanks,

Josef


diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 7af9343..72249e3 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -3972,7 +3972,13 @@ static void btrfs_release_extent_buffer_page(struct extent_buffer *eb,
 	unsigned long num_pages;
 	struct page *page;
 
-	BUG_ON(extent_buffer_under_io(eb));
+	if (extent_buffer_under_io(eb)) {
+		printk(KERN_ERR "io_pages=%d, writeback=%d, dirty=%d, stale=%d, tree_ref=%d\n",
+		       atomic_read(&eb->io_pages), test_bit(EXTENT_BUFFER_WRITEBACK, &eb->bflags),
+		       test_bit(EXTENT_BUFFER_DIRTY, &eb->bflags), test_bit(EXTENT_BUFFER_STALE, &eb->bflags),
+		       test_bit(EXTENT_BUFFER_TREE_REF, &eb->bflags));
+		BUG();
+	}
 
 	num_pages = num_extent_pages(eb->start, eb->len);
 	index = start_idx + num_pages;
