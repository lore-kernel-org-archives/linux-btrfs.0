From: Michael Vrable <mvrable@cs.ucsd.edu>
Subject: Re: What to do about subvolumes?
Date: Wed, 1 Dec 2010 17:52:07 -0800
Message-ID: <20101202015207.GC2304@vrable.net>
References: <20101201142136.GD427@dhcp231-156.rdu.redhat.com>
 <20101201194404.GE17142@fieldses.org>
 <20101201195433.GE7021@localhost.localdomain>
 <20101201200007.GH17142@fieldses.org>
 <20101201200949.GG7021@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Cc: "J. Bruce Fields" <bfields@fieldses.org>,
	linux-btrfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	chris.mason@oracle.com, hch@lst.de, ssorce@redhat.com
To: Josef Bacik <josef@redhat.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20101201200949.GG7021@localhost.localdomain>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Dec 01, 2010 at 03:09:52PM -0500, Josef Bacik wrote:
> On Wed, Dec 01, 2010 at 03:00:08PM -0500, J. Bruce Fields wrote:
>> I think you're already fine:
>> 
>> 	# mkdir TMP
>> 	# dd if=/dev/zero of=TMP-image bs=1M count=512
>> 	# mkfs.btrfs TMP-image
>> 	# mount -oloop TMP-image TMP/
>> 	# btrfs subvolume create sub-a
>> 	# btrfs subvolume create sub-b
>> 	../readdir-inos .
>> 	. 256 256
>> 	.. 256 4130609
>> 	sub-a 256 256
>> 	sub-b 257 256
>> 
>> Where readdir-inos is my silly test program below, and the first 
>> number is from readdir, the second from stat.
>> 
> 
> Heh as soon as I typed my email I went and actually looked at the 
> code, looks like for readdir we fill in the root id, which will be 
> unique, so hotdamn we are good and I don't have to use a stupid 
> incompat flag.  Thanks for checking that :),

Except, aren't the inode numbers within a filesystem and the sunbvolume 
tree IDs allocated out of separate namespaces?  I don't think there's 
anything preventing a file/directory from having an inode number that 
clashes with one of the snapshots.

In fact, this already happens in the example above: "." (inode 256 in 
the root subvolume) and "sub-a" (subvolume ID 256).

(Though I still don't understand the semantics well enough to say 
whether we need all the inode numbers returned by readdir to be 
distinct.)

--Michael Vrable
