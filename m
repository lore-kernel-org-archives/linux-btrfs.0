From: Ric Wheeler <rwheeler@redhat.com>
Subject: Re: btrfs for enterprise raid arrays
Date: Fri, 03 Apr 2009 07:43:53 -0400
Message-ID: <49D5F679.6060702@redhat.com>
References: <B7F26A02AFF8EB44B8635EB1D34BAC2C0536C8BF@USSCCEVS102.corp.hds.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Cc: linux-btrfs@vger.kernel.org, Alasdair G Kergon <agk@redhat.com>,
	James Bottomley <JBottomley@Novell.com>, willy@linux.intel.com,
	David.Woodhouse@intel.com, Tom Coughlan <coughlan@redhat.com>
To: Erwin van Londen <erwin.vanlonden@hds.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <B7F26A02AFF8EB44B8635EB1D34BAC2C0536C8BF@USSCCEVS102.corp.hds.com>
List-ID: <linux-btrfs.vger.kernel.org>

Erwin van Londen wrote:
> Dear all,
>
> While going through the archived mailing list and crawling along the wiki I didn't find any clues if there would be any optimizations in Btrfs to make efficient use of functions and features that today exist on enterprise class storage arrays.
>
> One exception to that was the ssd option which I think can make a improvement on read and write IO's however when attached to a storage array, from an OS perspective, it doesn't really matter since it can't look behind the array front-end interface anyhow(whether it FC/iSCSI or any other).
>
> There are however more options that we could think of. Almost all storage arrays these days have the capabilities to replicate volume (or part of it in COW cases) either in the system or remotely. It would be handy that if a Btrfs formatted volume could make use of those features since this might offload a lot of the processing time involved in maintaining these. The arrays already have optimized code to make these snapshots. I'm not saying we should step away from the host based snapshots but integration would be very nice.
>   
I agree - it would be great to have a standard way to invoke built in 
snap shots in enterprise arrays. Does HDS export something that we could 
invoke from kernel context to perform a snap shot?

> Furthermore some enterprise array have a feature that allows for full or partial staging data in cache. By this I mean when a volume contains a certain amount of blocks you can define to have the first X number of blocks pre-staged in cache which enables you to have extremely high IO rates on these first ones. An option related to the -ssd parameter could be to have a mount command say "mount -t btrfs -ssd 0-10000" so Btrfs knows what to expect from the partial area and maybe can optimize the locality of frequently used blocks to optimize performance.
>   
Effectively, you prefetch and pin these blocks in cache?  Is this 
something we can preconfigure via some interface per LUN?
> Another thing is that some arrays have the capability to "thin-provision" volumes. In the back-end on the physical layer the array configures, let say, a 1 TB volume and virtually provisions 5TB to the host. On writes it dynamically allocates more pages in the pool up to the 5TB point. Now if for some reason large holes occur on the volume, maybe a couple of ISO images that have been deleted, what normally happens is just some pointers in the inodes get deleted so from an array perspective there is still data on those locations and will never release those allocated blocks. New firmware/microcode versions are able to reclaim that space if it sees a certain number of consecutive zero's and will reclaim that space to the volume pool. Are there any thoughts on writing a low-priority tread t
 hat zeros out those "non-used" blocks?
>   

Patches have been floating around to support this - see the recent 
patches around "DISCARD" on linux-ide and lkml.  It would be great to 
get access to a box that implemented the T10 proposed UNMAP commands 
that we could test against. 
> Given the scalability targets of Btrfs it will most likely be heavily used in the enterprise environment once it reaches a stable code level. If we would be able to interface with these array based features that would be very beneficial. 
>
> Furthermore one question also pops to mind and that's when looking at the scalability of Btrfs and its targeted capacity levels I think we will run into problems with the capabilities of the server hardware itself. From what I can see now it will not be designed as a distributed file-system with integrated distributed lock manager to scale out over multiple nodes. (I know Oracle is working on a similar thing but this might get things more complicated than it already is.) This might impose some serious issues with recovery scenarios like backup/restore since it will take quite some time to backup/restore a multi PB system when it resides on just 1 physical host even when we're talking high end P-series, I25K's or Superdome class.
>
> I'm not a coder but am heavily involved in the storage industry for the past 15 years so this is just some of the things I come across in real life enterprise customer environments so these are just some of my mind spinnings.
>
> There are some more however these would be best covered in another topic.
>
> Let me know your thoughts.
>
> Kind regards,
>
> Erwin van Londen
> Systems Engineer
> HITACHI DATA SYSTEMS
> Level 4, 441 St. Kilda Rd.
> Melbourne, Victoria, 3004
> Australia
>  
>   
Erwin, the real key here is to figure out what standard interfaces we 
can use to invoke these functions (from kernel context). Having a 
background in storage myself, the challenge in taking advantage of these 
advanced array features has been that each vendor has their own back 
door API's to control this. Linux likes to take advantage of well 
supported by multiple vendor features.

If you have HDS engineers interested in exploring this or spilling 
details on how to trigger these, it would be a great conversation (but 
not just for btrfs, you would need to talk to the broader SCSI, LVM, etc 
lists as well :-))

Ric

