From: Martin Mailand <martin@tuxadero.com>
Subject: Re: Btrfs slowdown with ceph (how to reproduce)
Date: Tue, 24 Jan 2012 20:15:58 +0100
Message-ID: <4F1F036E.9030801@tuxadero.com>
References: <CAO47_-8Eb_v8X95KxSZ2H-DNC3hLZkrfq1ce3CAfW2G9CUV5gQ@mail.gmail.com> <20120123181928.GA3724@localhost.localdomain> <20120123185040.GH4387@shiny>
Reply-To: martin@tuxadero.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
To: Chris Mason <chris.mason@oracle.com>,
	Josef Bacik <josef@redhat.com>, Christian Brunner <chb@muc.de>,
	linux-btrfs@vger.kernel.org, ceph-devel@vger.kernel.org
Return-path: <ceph-devel-owner@vger.kernel.org>
In-Reply-To: <20120123185040.GH4387@shiny>
List-ID: <linux-btrfs.vger.kernel.org>

Hi
I tried the branch on one of my ceph osd, and there is a big difference 
in the performance.
The average request size stayed high, but after around a hour the kernel 
crashed.

IOstat
http://pastebin.com/xjuriJ6J

Kernel trace
http://pastebin.com/SYE95GgH

-martin

Am 23.01.2012 19:50, schrieb Chris Mason:
> On Mon, Jan 23, 2012 at 01:19:29PM -0500, Josef Bacik wrote:
>> On Fri, Jan 20, 2012 at 01:13:37PM +0100, Christian Brunner wrote:
>>> As you might know, I have been seeing btrfs slowdowns in our ceph
>>> cluster for quite some time. Even with the latest btrfs code for 3.3
>>> I'm still seeing these problems. To make things reproducible, I've now
>>> written a small test, that imitates ceph's behavior:
>>>
>>> On a freshly created btrfs filesystem (2 TB size, mounted with
>>> "noatime,nodiratime,compress=lzo,space_cache,inode_cache") I'm opening
>>> 100 files. After that I'm doing random writes on these files with a
>>> sync_file_range after each write (each write has a size of 100 bytes)
>>> and ioctl(BTRFS_IOC_SYNC) after every 100 writes.
>>>
>>> After approximately 20 minutes, write activity suddenly increases
>>> fourfold and the average request size decreases (see chart in the
>>> attachment).
>>>
>>> You can find IOstat output here: http://pastebin.com/Smbfg1aG
>>>
>>> I hope that you are able to trace down the problem with the test
>>> program in the attachment.
>>
>> Ran it, saw the problem, tried the dangerdonteveruse branch in Chris's tree and
>> formatted the fs with 64k node and leaf sizes and the problem appeared to go
>> away.  So surprise surprise fragmentation is biting us in the ass.  If you can
>> try running that branch with 64k node and leaf sizes with your ceph cluster and
>> see how that works out.  Course you should only do that if you dont mind if you
>> lose everything :).  Thanks,
>>
>
> Please keep in mind this branch is only out there for development, and
> it really might have huge flaws.  scrub doesn't work with it correctly
> right now, and the IO error recovery code is probably broken too.
>
> Long term though, I think the bigger block sizes are going to make a
> huge difference in these workloads.
>
> If you use the very dangerous code:
>
> mkfs.btrfs -l 64k -n 64k /dev/xxx
>
> (-l is leaf size, -n is node size).
>
> 64K is the max right now, 32K may help just as much at a lower CPU cost.
>
> -chris
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
