From: Chris Mason <chris.mason@oracle.com>
Subject: Re: kernel BUG at fs/btrfs/extent_io.c:3982!
Date: Wed, 11 Apr 2012 20:29:46 -0400
Message-ID: <20120412002946.GF29506@shiny>
References: <4F848C62.6030100@sandia.gov>
 <20120411190926.GE2506@localhost.localdomain>
 <4F85E87E.90804@sandia.gov>
 <20120411202823.GG2506@localhost.localdomain>
 <4F85F9FB.5020007@sandia.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Josef Bacik <josef@redhat.com>, linux-btrfs@vger.kernel.org
To: Jim Schutt <jaschut@sandia.gov>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4F85F9FB.5020007@sandia.gov>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Apr 11, 2012 at 03:39:07PM -0600, Jim Schutt wrote:
> On 04/11/2012 02:28 PM, Josef Bacik wrote:
> >On Wed, Apr 11, 2012 at 02:24:30PM -0600, Jim Schutt wrote:
> >>On 04/11/2012 01:09 PM, Josef Bacik wrote:
> >>>On Tue, Apr 10, 2012 at 01:39:14PM -0600, Jim Schutt wrote:
> >>>>Hi,
> >>>>
> >>>>I hit this BUG today.
> >>>>
> >>>>I'm running 3.3.1 merged with the ceph and btrfs bits for 3.4,
> >>>>i.e. 3.3.1 +
> >>>>   commit bc3f116fec194 "Btrfs: update the checks for mixed block groups with big metadata blocks"
> >>>>   commit c666601a935b9 "rbd: move snap_rwsem to the device, rename to header_rwsem"
> >>>>
> >>>>The btrfs filesystem in question is backing a Ceph OSD under
> >>>>a heavy write load.
> >>>>
> >>>>Here's the bug:
> >>>>
> >>>
> >>>Can you give this a whirl and let me know how it goes?  If I'm right you should
> >>>see a warning pop up in your messages.  Thanks,
> >>
> >>OK, I've got my test running with your patch applied
> >>to my previous kernel.
> >>
> >>Do you expect your warning to only fire when my
> >>previous kernel would have BUGged?  I ask because I've
> >>only seen the BUG once, so it may be a low-probability
> >>occurrence.
> >>
> >>It seems like I should keep testing until I see either
> >>your new warning or the BUG, right?
> >>
> >
> >So hopefully you will see my WARN with no BUG, but yes keep running until you
> >see one or the other please ;).  Thanks,
> 
> Hmmm, the BUG won:
> 
> [ 6202.249041] ------------[ cut here ]------------
> [ 6202.253654] kernel BUG at fs/btrfs/extent_io.c:3989!

Since this is exactly the same call trace, we can assume ref count on
the buffer is correct.  I think it means we're racing on removing the
buffer from the radix tree.  I'm adding some diagnostics here to try and
grow the window a bit.

-chris
