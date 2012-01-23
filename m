From: Christian Brunner <chb@muc.de>
Subject: Re: Btrfs slowdown with ceph (how to reproduce)
Date: Mon, 23 Jan 2012 21:53:23 +0100
Message-ID: <CAO47_-_zZ12=GA08dV0qAgTxHNRHdJJ21eKyJrQ8M0f=EdYGaw@mail.gmail.com>
References: <CAO47_-8Eb_v8X95KxSZ2H-DNC3hLZkrfq1ce3CAfW2G9CUV5gQ@mail.gmail.com>
	<20120123181928.GA3724@localhost.localdomain>
	<20120123185040.GH4387@shiny>
Reply-To: chb@muc.de
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs@vger.kernel.org, ceph-devel@vger.kernel.org
Return-path: <ceph-devel-owner@vger.kernel.org>
In-Reply-To: <20120123185040.GH4387@shiny>
List-ID: <linux-btrfs.vger.kernel.org>

2012/1/23 Chris Mason <chris.mason@oracle.com>:
> On Mon, Jan 23, 2012 at 01:19:29PM -0500, Josef Bacik wrote:
>> On Fri, Jan 20, 2012 at 01:13:37PM +0100, Christian Brunner wrote:
>> > As you might know, I have been seeing btrfs slowdowns in our ceph
>> > cluster for quite some time. Even with the latest btrfs code for 3=
=2E3
>> > I'm still seeing these problems. To make things reproducible, I've=
 now
>> > written a small test, that imitates ceph's behavior:
>> >
>> > On a freshly created btrfs filesystem (2 TB size, mounted with
>> > "noatime,nodiratime,compress=3Dlzo,space_cache,inode_cache") I'm o=
pening
>> > 100 files. After that I'm doing random writes on these files with =
a
>> > sync_file_range after each write (each write has a size of 100 byt=
es)
>> > and ioctl(BTRFS_IOC_SYNC) after every 100 writes.
>> >
>> > After approximately 20 minutes, write activity suddenly increases
>> > fourfold and the average request size decreases (see chart in the
>> > attachment).
>> >
>> > You can find IOstat output here: http://pastebin.com/Smbfg1aG
>> >
>> > I hope that you are able to trace down the problem with the test
>> > program in the attachment.
>>
>> Ran it, saw the problem, tried the dangerdonteveruse branch in Chris=
's tree and
>> formatted the fs with 64k node and leaf sizes and the problem appear=
ed to go
>> away. =A0So surprise surprise fragmentation is biting us in the ass.=
 =A0If you can
>> try running that branch with 64k node and leaf sizes with your ceph =
cluster and
>> see how that works out. =A0Course you should only do that if you don=
t mind if you
>> lose everything :). =A0Thanks,
>>
>
> Please keep in mind this branch is only out there for development, an=
d
> it really might have huge flaws. =A0scrub doesn't work with it correc=
tly
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
> 64K is the max right now, 32K may help just as much at a lower CPU co=
st.

Thanks for taking a look. - I'm glad to hear that there is a solution
on the horizon, but I'm not brave enough to try this on our ceph
cluster. I'll try it when the code has stabilized a bit.

Regards,
Christian
--
To unsubscribe from this list: send the line "unsubscribe ceph-devel" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
