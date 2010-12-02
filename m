From: David Pottage <david@electric-spoon.com>
Subject: Re: What to do about subvolumes?
Date: Thu, 02 Dec 2010 17:14:53 +0000
Message-ID: <4CF7D40D.508@electric-spoon.com>
References: <20101201142136.GD427@dhcp231-156.rdu.redhat.com> <4CF76BB3.3020705@gmx.net> <1291306150-sup-7861@think>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Cc: Arne Jansen <sensille@gmx.net>, Josef Bacik <josef@redhat.com>,
	linux-btrfs <linux-btrfs@vger.kernel.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>, hch <hch@lst.de>,
	ssorce <ssorce@redhat.com>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1291306150-sup-7861@think>
List-ID: <linux-btrfs.vger.kernel.org>

On 02/12/10 16:11, Chris Mason wrote:
> Excerpts from Arne Jansen's message of 2010-12-02 04:49:39 -0500:
>    
>> Josef Bacik wrote:
>>      
>>> 1) Scrap the 256 inode number thing.  Instead we'll just put a flag in the inode
>>> to say "Hey, I'm a subvolume" and then we can do all of the appropriate magic
>>> that way.  This unfortunately will be an incompatible format change, but the
>>> sooner we get this adressed the easier it will be in the long run.  Obviously
>>> when I say format change I mean via the incompat bits we have, so old fs's won't
>>> be broken and such.
>>>
>>> 2) Do something like NFS's referral mounts when we cd into a subvolume.  Now we
>>> just do dentry trickery, but that doesn't make the boundary between subvolumes
>>> clear, so it will confuse people (and samba) when they walk into a subvolume and
>>> all of a sudden the inode numbers are the same as in the directory behind them.
>>> With doing the referral mount thing, each subvolume appears to be its own mount
>>> and that way things like NFS and samba will work properly.
>>>
>>>        
>> What about the alternative and allocating inode numbers globally? The only
>> problem would be with snapshots as they share the inum with the source, but
>> one could just remap inode numbers in snapshots by sparing some bits at the
>> top of this 64 bit field.
>>      
> The global inode number is possible, it's just another btree that must
> be maintained on disk in order to map which inodes are free and which
> ones aren't.  It also needs to have a reference count on each inode,
> since each snapshot effectively increases the reference count on
> every file and directory it contains.
>
> The cost of maintaining that reference count is very very high.
>    

A couple of years ago I was suffering from the problem of different 
files having the same inode number on Netapp servers. On a Netapp device 
if you snapshot a volume then the files in the snapshot have the same 
inode number as the original, even if the original changes. (Netapp 
snapshots are read only).

This means that if you attempt to see what has changed since your last 
snapshot using a command line such as:

diff src/file.c .snapshots/hourly.12/src.file.c

Then the diff tool will tell you that the files are the same even if 
they are different, because it is assuming that files with the same 
inode number will have identical contents.

Therefore I think it is a bad idea if potentially different files on 
btrfs can have the same inode number. It will break all sorts of tools.

Instead of maintaining a big complicated reference count of used inode 
numbers, could btrfs use bit masks to create a the userland visible 
inode number from the subvolume id and the real internal inode number. 
Something like:

userland_inode = ( volume_id << 48 ) & internal_inode;

Please forgive me if this is impossible, or if that C snippet is 
syntactically incorrect. I am not a filesystem or kernel developer, and 
I have not coded in C for many years.

-- 
David Pottage

