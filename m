From: Alan Chandler <alan@chandlerfamily.org.uk>
Subject: Re: Synching a Backup Server
Date: Sun, 09 Jan 2011 20:57:12 +0000
Message-ID: <4D2A2128.2060508@chandlerfamily.org.uk>
References: <201101060935.14059.CACook@quantum-sci.com> <201101061342.23991.CACook@quantum-sci.com> <AANLkTimOEsFiF7tiCzV-Y3NfGYHjK+uL_3O6PNDKum90@mail.gmail.com> <201101071720.08298.hka@qbs.com.pl> <4D29A033.7000803@chandlerfamily.org.uk> <AANLkTi=KASX7pFO8dxJ1P=OhP3qj6qjTgtA6g1Fw-ou4@mail.gmail.com> <4D29D508.6080006@chandlerfamily.org.uk> <AANLkTim96P3ZD-WpDonsOHB7aicNBQX-wK6v347r1z8s@mail.gmail.com> <20110109183030.GA29572@carfax.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20110109183030.GA29572@carfax.org.uk>
List-ID: <linux-btrfs.vger.kernel.org>



On 09/01/11 18:30, Hugo Mills wrote:
>
>     No, subvolumes are a part of the whole filesystem. In btrfs, there
> is only one filesystem. There are 6 main B-trees that store metadata
> in btrfs (plus a couple of others). One of those is the "filesystem
> tree" (or FS tree), which contains all the metadata associated with
> the normal POSIX directory/file namespace (basically all the inode and
> xattr data). When you create a subvolume, a new FS tree is created,
> but it shares *all* of the other btrfs B-trees.
>
>     There is only one filesystem, but there may be distinct namespaces
> within that filesystem that can be mounted as if they were
> filesystems. Think of it more like NFSv4, where there's one overall
> namespace exported per server, but clients can mount subsections of
> it.
>
>    
I think this explanation is still missing the key piece that has 
confused me despite trying very hard to understand it by reading the 
wiki.  You talk about "Distinct Namespaces", but what I learnt from 
further up the thread is that this "namespace" is also inside the the 
"namespace" that makes up the whole filesystem.  I mount the whole 
filesystem, and all my subvolumes are automatically there (at least that 
is what I find in practice).  Its this duality of namespace that is the 
difficult concept.  I am still not sure of there is a default subvolume, 
and the other subvolumes are defined within its namespace, or whether 
there is an overall filesystem namespace and subvolumes defined within 
it and if you mount the default subvolume you would then loose the 
overall filesystem namespace and hence no longer see the subvolumes.  I 
find the wiki also confusing because it talks about subvolumes having to 
be at the first level of the filesystem, but again further up this 
thread there is an example which is used for real of it not being at the 
first level, but at one level down inside a directory.

What it means is that I don't have a mental picture of how this all 
works, and all use cases could then be worked out by following this 
mental picture.  I think it would be helpful if the Wiki contained some 
of the use cases that we have been talking about in this thread - but 
with more detailed information - like the actual commands used to mount 
the filesystems like this, and information as to in what circumstances 
you would perform each action.


>     The main awkward piece of btrfs terminology is the use of "RAID" to
> describe btrfs's replication strategies. It's not RAID, and thinking
> of it in RAID terms is causing lots of confusion. Most of the other
> things in btrfs are, I think, named relatively sanely.
>    

I don't find this AS confusing, although there is still information 
missing which I asked in another post that wasn't answered.  I still 
can't understand if its possible to initialise a filesystem in degraded 
mode. If you create the filesystem so that -m RAID1 and -d RAID1 but 
only have one device - it implies that it writes two copies of both 
metadata and data to that one device.  However if you successfully 
create the filesystem on two devices and then fail one and mount it -o 
degraded it appears to suggest it will only write the one copy.

I was considering how to migrate from an existing mdmadm Raid1 /lvm 
arrangement

I suppose I could fail one device of the mdm pair and initialise the 
btrfs filesystem with this one device as the first half of a raid1 
mirror and the other as a usb stick, then remove the usb stick and mount 
the filesystem -o degraded.  Copy data to it from the still working half 
available lv and then dispose of mdmadm device completely and add in the 
freed up device using btrfs device add


-- 

Alan Chandler
http://www.chandlerfamily.org.uk

