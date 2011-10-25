From: Sage Weil <sage@newdream.net>
Subject: Re: ceph on btrfs [was Re: ceph on non-btrfs file systems]
Date: Tue, 25 Oct 2011 09:36:29 -0700 (PDT)
Message-ID: <Pine.LNX.4.64.1110250932140.20108@cobra.newdream.net>
References: <Pine.LNX.4.64.1110231739380.25255@cobra.newdream.net>
 <CAO47_-9jp===DT=scpe=U8BnPnUCAVz7xUWVCC9AMVmx67CdaA@mail.gmail.com>
 <Pine.LNX.4.64.1110240941500.15349@cobra.newdream.net>
 <20111024195147.GB31264@dhcp231-156.rdu.redhat.com>
 <CAO47_-_=1uLV34WAAHFhv6z7fDmtY8L-+HUzfu=WcHNatbvxJQ@mail.gmail.com>
 <20111025122320.GA3703@dhcp231-156.rdu.redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Josef Bacik <josef@redhat.com>, ceph-devel@vger.kernel.org,
	linux-btrfs@vger.kernel.org
To: Christian Brunner <chb@muc.de>
Return-path: <ceph-devel-owner@vger.kernel.org>
In-Reply-To: <20111025122320.GA3703@dhcp231-156.rdu.redhat.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, 25 Oct 2011, Josef Bacik wrote:
> At this point it seems like the biggest problem with latency in ceph-osd 
> is not related to btrfs, the latency seems to all be from the fact that 
> ceph-osd is fsyncing a block dev for whatever reason. 

There is one place where we sync_file_range() on the journal block device, 
but that should only happen if directio is disabled (it's on by default).  

Christian, have you tweaked those settings in your ceph.conf?  It would be 
something like 'journal dio = false'.  If not, can you verify that 
directio shows true when the journal is initialized from your osd log?  
E.g.,

 2011-10-21 15:21:02.026789 7ff7e5c54720 journal _open dev/osd0.journal fd 14: 104857600 bytes, block size 4096 bytes, directio = 1

If directio = 1 for you, something else funky is causing those 
blkdev_fsync's...

sage
