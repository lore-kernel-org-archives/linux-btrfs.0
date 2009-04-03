From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: btrfs for enterprise raid arrays
Date: Fri, 03 Apr 2009 08:51:54 -0500
Message-ID: <1238766714.3359.7.camel@mulgrave.int.hansenpartnership.com>
References: <B7F26A02AFF8EB44B8635EB1D34BAC2C0536C8BF@USSCCEVS102.corp.hds.com>
	 <49D5F679.6060702@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: Erwin van Londen <erwin.vanlonden@hds.com>,
	linux-btrfs@vger.kernel.org, Alasdair G Kergon <agk@redhat.com>,
	willy@linux.intel.com, David.Woodhouse@intel.com,
	Tom Coughlan <coughlan@redhat.com>
To: Ric Wheeler <rwheeler@redhat.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <49D5F679.6060702@redhat.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, 2009-04-03 at 07:43 -0400, Ric Wheeler wrote:
> Erwin van Londen wrote:
> > Another thing is that some arrays have the capability to "thin-provision" volumes. In the back-end on the physical layer the array configures, let say, a 1 TB volume and virtually provisions 5TB to the host. On writes it dynamically allocates more pages in the pool up to the 5TB point. Now if for some reason large holes occur on the volume, maybe a couple of ISO images that have been deleted, what normally happens is just some pointers in the inodes get deleted so from an array perspective there is still data on those locations and will never release those allocated blocks. New firmware/microcode versions are able to reclaim that space if it sees a certain number of consecutive zero's and will reclaim that space to the volume pool. Are there any thoughts on writing a low-priority tread
  that zeros out those "non-used" blocks?
> >   
> 
> Patches have been floating around to support this - see the recent 
> patches around "DISCARD" on linux-ide and lkml.  It would be great to 
> get access to a box that implemented the T10 proposed UNMAP commands 
> that we could test against. 

So we went several times around the block in the upcoming Linux
Filesystem and Storage workshop to see if anyone from the array vendors
might be interested in discussing thin provisioning.  The general result
was no since travel is tight.  The upshot will be that most of our
discard infrastructure will be focussed on SSD TRIM, but that we'll try
to preserve the TP option for arrays ... there are still private
conversations going on with various people who know the UNMAP/WRITE SAME
requirements of the various arrays at the various vendors.

James


