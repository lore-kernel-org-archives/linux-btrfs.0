From: Christian Brunner <chb@muc.de>
Subject: Re: ceph on btrfs [was Re: ceph on non-btrfs file systems]
Date: Wed, 26 Oct 2011 10:21:32 +0200
Message-ID: <CAO47_-9=5aTCygL0aNCAuWDeb8E2E__c=rSKogdQaKz_CnMsgQ@mail.gmail.com>
References: <Pine.LNX.4.64.1110231739380.25255@cobra.newdream.net>
	<CAO47_-9jp===DT=scpe=U8BnPnUCAVz7xUWVCC9AMVmx67CdaA@mail.gmail.com>
	<Pine.LNX.4.64.1110240941500.15349@cobra.newdream.net>
	<20111024195147.GB31264@dhcp231-156.rdu.redhat.com>
	<CAO47_-_=1uLV34WAAHFhv6z7fDmtY8L-+HUzfu=WcHNatbvxJQ@mail.gmail.com>
	<20111025122320.GA3703@dhcp231-156.rdu.redhat.com>
	<CAO47_--rkkKw7AJVRHdhwVXEq736ijhVWKYhRDQdgUxix3P-0w@mail.gmail.com>
	<20111025150512.GC3703@dhcp231-156.rdu.redhat.com>
	<20111025201545.GA4082@shiny.Mikenopa.local>
	<20111025202248.GE3703@dhcp231-156.rdu.redhat.com>
	<CAO47_-9vgo=pVQ1aq_cAArYJWAmTapWnxxugiGWsBJW3rNjBbA@mail.gmail.com>
Reply-To: chb@muc.de
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Chris Mason <chris.mason@oracle.com>,
	Sage Weil <sage@newdream.net>, ceph-devel@vger.kernel.org,
	linux-btrfs@vger.kernel.org
To: Josef Bacik <josef@redhat.com>
Return-path: <ceph-devel-owner@vger.kernel.org>
In-Reply-To: <CAO47_-9vgo=pVQ1aq_cAArYJWAmTapWnxxugiGWsBJW3rNjBbA@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

2011/10/26 Christian Brunner <chb@muc.de>:
> 2011/10/25 Josef Bacik <josef@redhat.com>:
>> On Tue, Oct 25, 2011 at 04:15:45PM -0400, Chris Mason wrote:
>>> On Tue, Oct 25, 2011 at 11:05:12AM -0400, Josef Bacik wrote:
>>> > On Tue, Oct 25, 2011 at 04:25:02PM +0200, Christian Brunner wrote=
:
>>> > >
>>> > > Attached is a perf-report. I have included the whole report, so=
 that
>>> > > you can see the difference between the good and the bad
>>> > > btrfs-endio-wri.
>>> > >
>>> >
>>> > We also shouldn't be running run_ordered_operations, man this is =
screwed up,
>>> > thanks so much for this, I should be able to nail this down prett=
y easily.
>>> > Thanks,
>>>
>>> Looks like we're getting there from reserve_metadata_bytes when we =
join
>>> the transaction?
>>>
>>
>> We don't do reservations in the endio stuff, we assume you've reserv=
ed all the
>> space you need in delalloc, plus we would have seen reserve_metadata=
_bytes in
>> the trace. =A0Though it does look like perf is lying to us in at lea=
st one case
>> sicne btrfs_alloc_logged_file_extent is only called from log replay =
and not
>> during normal runtime, so it definitely shouldn't be showing up. =A0=
Thanks,
>
> Strange! - I'll check if symbols got messed up in the report tomorrow=
=2E

I've checked this now: Except for the missing symbols for iomemory_vsl
module, everything is looking normal.

I've also run the report on another OSD again, but the results look
quite similar.

Regards,
Christian

PS: This is what perf report -v is saying...

build id event received for [kernel.kallsyms]:
805ca93f4057cc0c8f53b061a849b3f847f2de40
build id event received for
/lib/modules/3.0.6-1.fits.8.el6.x86_64/kernel/fs/btrfs/btrfs.ko:
64a723e05af3908fb9593f4a3401d6563cb1a01b
build id event received for
/lib/modules/3.0.6-1.fits.8.el6.x86_64/kernel/lib/libcrc32c.ko:
b1391be8d33b54b6de20e07b7f2ee8d777fc09d2
build id event received for
/lib/modules/3.0.6-1.fits.8.el6.x86_64/kernel/drivers/net/bonding/bondi=
ng.ko:
663392df0f407211ab8f9527c482d54fce890c5e
build id event received for
/lib/modules/3.0.6-1.fits.8.el6.x86_64/kernel/drivers/scsi/hpsa.ko:
676eecffd476aef1b0f2f8c1bf8c8e6120d369c9
build id event received for
/lib/modules/3.0.6-1.fits.8.el6.x86_64/kernel/drivers/net/ixgbe/ixgbe.k=
o:
db7c200894b27e71ae6fe5cf7adaebf787c90da9
build id event received for [iomemory_vsl]:
4ed417c9a815e6bbe77a1656bceda95d9f06cb13
build id event received for /lib64/libc-2.12.so:
2ab28d41242ede641418966ef08f9aacffd9e8c7
build id event received for /lib64/libpthread-2.12.so:
c177389a6f119b3883ea0b3c33cb04df3f8e5cc7
build id event received for /sbin/rsyslogd:
1372ef1e2ec550967fe20d0bdddbc0aab0bb36dc
build id event received for /lib64/libglib-2.0.so.0.2200.5:
d880be15bf992b5fbcc629e6bbf1c747a928ddd5
build id event received for /usr/sbin/irqbalance:
842de64f46ca9fde55efa29a793c08b197d58354
build id event received for /lib64/libm-2.12.so:
46ac89195918407d2937bd1450c0ec99c8d41a2a
build id event received for /usr/bin/ceph-osd:
9fcb36e020c49fc49171b4c88bd784b38eb0675b
build id event received for /usr/lib64/libstdc++.so.6.0.13:
d1b2ca4e1ec8f81ba820e5f1375d960107ac7e50
build id event received for /usr/lib64/libtcmalloc.so.0.2.0:
02766551b2eb5a453f003daee0c5fc9cd176e831
Looking at the vmlinux_path (6 entries long)
dso__load_sym: cannot get elf header.
Using /proc/kallsyms for symbols
Looking at the vmlinux_path (6 entries long)
No kallsyms or vmlinux with build-id
4ed417c9a815e6bbe77a1656bceda95d9f06cb13 was found
[iomemory_vsl] with build id 4ed417c9a815e6bbe77a1656bceda95d9f06cb13
not found, continuing without symbols
--
To unsubscribe from this list: send the line "unsubscribe ceph-devel" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
