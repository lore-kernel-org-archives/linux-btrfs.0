From: Ric Wheeler <rwheeler@redhat.com>
Subject: Re: btrfs for enterprise raid arrays
Date: Fri, 03 Apr 2009 07:51:15 -0400
Message-ID: <49D5F833.6050309@redhat.com>
References: <B7F26A02AFF8EB44B8635EB1D34BAC2C0536C8BF@USSCCEVS102.corp.hds.com> <20090403073228.GA22406@cumulus>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Cc: Erwin van Londen <erwin.vanlonden@hds.com>,
	linux-btrfs@vger.kernel.org
To: sander@humilis.net
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20090403073228.GA22406@cumulus>
List-ID: <linux-btrfs.vger.kernel.org>

Sander wrote:
> Dear Erwin,
>
> Erwin van Londen wrote (ao):
>   
>> Another thing is that some arrays have the capability to
>> "thin-provision" volumes. In the back-end on the physical layer the
>> array configures, let say, a 1 TB volume and virtually provisions 5TB
>> to the host. On writes it dynamically allocates more pages in the pool
>> up to the 5TB point. Now if for some reason large holes occur on the
>> volume, maybe a couple of ISO images that have been deleted, what
>> normally happens is just some pointers in the inodes get deleted so
>> from an array perspective there is still data on those locations and
>> will never release those allocated blocks. New firmware/microcode
>> versions are able to reclaim that space if it sees a certain number of
>> consecutive zero's and will reclaim that space to the volume pool. Are
>> there any thoughts on writing a low-priority tread that zeros out
>> those "non-used" blocks?
>>     
>
> SSD would also benefit from such a feature as it doesn't need to copy
> deleted data when erasing blocks.
>   

The joy of the proposed T10 UNMAP commands is that you send one block 
down with special bits set which lets the target know you don't need the 
whole block range. No real data movement to or from the storage device 
(other than that one special sector).

> The storage could use the ATA/SCSI commands TRIM, UNMAP and DISCARD for
> that?
>   
That is the current plan & is being implemented in a way that should let 
us transparently (from a btrfs level) take advantage of arrays that do 
unmap or SSD trim enabled devices with no fs level changes.  Currently, 
as far as I know, we have no thin enabled devices to play with.
> I have one question on thin provisioning: if Windows XP performs defrag
> on a 20GB 'virtual' size LUN with 2GB in actuall use, whil the volume
> grow to 20GB on the storage and never shrink afterwards anymore, while
> the client still has only 2GB in use?
>   

That is the inverse of what would happen - the windows people will 
probably hack defrag to emit its equivalent of block discard commands 
for the old blocks after defragging a file (just guessing here). With a 
per fs defrag pass, you could use this kind of hook to resync the actual 
allocated block state between your fs image and the storage.
> This would make thin provisioning on virtual desktops less useful.
>
> Do you have any numbers on the performance impact of thin provisioning?
> I can imagine that thin provisioning causes on-storage defragmentation
> of disk images, which would kill any OS optimisations like grouping often
> read files.
>
> 	With kind regards, Sander
>
>   
Big arrays have virtual block ranges anyway, this is just a different 
layer of abstraction that is invisible to us.

Thin enabled devices might have a performance hit for small discard 
commands (that would impact truncate/unlink performance).  I suspect the 
performance impact will vary a lot depending on how the feature is coded 
internally in the storage, but we will only know when we get one to play 
with :-)

ric


