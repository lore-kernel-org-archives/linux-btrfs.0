From: Struan Bartlett <struan.bartlett@NewsNow.co.uk>
Subject: Re: btrfs balancing start - and stop?
Date: Tue, 05 Apr 2011 17:06:11 +0100
Message-ID: <4D9B3DF3.8090804@NewsNow.co.uk>
References: <4D95B3AA.2090106@NewsNow.co.uk> <20110401115935.GA2984@carfax.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
To: Hugo Mills <hugo-lkml@carfax.org.uk>, linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20110401115935.GA2984@carfax.org.uk>
List-ID: <linux-btrfs.vger.kernel.org>


On 01/04/11 12:59, Hugo Mills wrote:
> On Fri, Apr 01, 2011 at 12:14:50PM +0100, Struan Bartlett wrote:
>    
>> My company is testing btrfs (kernel 2.6.38) on a slave MySQL
>> database server with a 195Gb filesystem (of which about 123Gb is
>> used). So far, we're quite impressed with the performance. Our
>> database loads are high, and if  filesystem performance wasn't good,
>> MySQL replication wouldn't be able to keep up and the slave latency
>> would begin to climb. This though, is generally not happening, which
>> is good.
>>
>> However, we recently tried running 'btrfs fi balance' on the
>> filesystem, and found this deteriorated performance significantly,
>> and the MySQL replication latency did begin to climb. Several hours
>> later, with the btrfs-cleaner thread apparently still busy, and our
>> replication latency running to a couple of hours, and no sign of the
>> balancing operation finishing, we decided we needed to terminate the
>> balancing operation, which we did by rebooting the server.
>>
>> That, however, is suboptimal in a production environment, and so
>> I've some questions.
>>
>> 1) Is the balancing operation expected to take many hours (or days?)
>> on a filesystem such as this? Or are there known issues with the
>> algorithm that are yet to be addressed?
>>      
>     A balance rewrites all the data on the filesystem, so it can take a
> very long time (I think the longest reported time I've seen from
> anyone was 48 hours, on several terabytes of data). However, this will
> be highly dependent on the amount of I/O bandwidth available to the
> FS, and on the size of the data to be written.
>
>    
>> 2) Is it supposed to be desirable to run balancing operations
>> periodically anyway? Our server is running on hardware mirrored
>> disks, so our btrfs filesystem is simply created in spare space on
>> the LVM volume group, using a single LV block device. Does balancing
>> help improve performance/optimise free space in this setup anyway?
>>      
>     Not that I'm aware of, particularly in the light of the recent
> patch that frees up unused block groups. Others here may have a more
> informed take on this, though.
>
>    
>> 3) If there's an ioctl for launching a balancing operation, would it
>> be an idea to add one for pausing a balancing operation? If
>> balancing may take 'significant' lengths of time, and if it's
>> intended that balancing be done periodically, it might be helpful if
>> one could start balancing when loads are lower, and make sure one
>> can stop them when resources are needed (in our case, when slave
>> latency exceeds acceptable limits).
>>      
>     There's patches for a cancel operation on the mailing list.
> Further, I've got (as yet) unreleased patches for various forms of
> partial balance, at least one of which would allow a balance to be
> restarted after it was cancelled. The only reason I've not released
> them is because I want to do a final check of what I send to the list
> to ensure that I'm not making an idiot of myself (and wasting people's
> time) with malformed patches. I hope to have time for this on Sunday.
>
>     Hugo.
>
>    
Hugo - thanks very much for your thorough reply. I look forward to being 
able to cancel a balancing operation, but in the meantime we simply 
won't bother setting any going, and see how things go. So far, our btrfs 
slave database has been running two weeks, with a rolling history of 
snapshots taken every ten minutes, without any other apparent issues.

Struan

