From: Edward Shishkin <edward.shishkin@gmail.com>
Subject: Re: [PATCH] btrfs: implement FS_IOC_GETFLAGS/SETFLAGS/GETVERSION
Date: Tue, 21 Apr 2009 23:30:54 +0200
Message-ID: <49EE3B0E.90706@gmail.com>
References: <20090417083741.GA14933@lst.de> <49E855EB.5010001@gmail.com> <20090420154725.GA14284@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Cc: linux-btrfs@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20090420154725.GA14284@lst.de>
List-ID: <linux-btrfs.vger.kernel.org>

Christoph Hellwig wrote:
> On Fri, Apr 17, 2009 at 12:11:55PM +0200, Edward Shishkin wrote:
>   
>> Christoph Hellwig wrote:
>>     
>>> Add support for the standard attributes set via chattr and read vis
>>> lsattr.  Currently we store the attributes in the flags value in
>>> the btrfs inode, but I wonder whether we should split it into two so
>>> that we don't have to keep converting between the two formats.
>>>  
>>>       
>> Imho, since inode items are of fixed size, is won't be possible
>> to avoid such workarounds like conversion between formats.
>> No?
>>     
>
> While the inode format is fixed it has 256 spare bits for expansion.
>   

Ah, I meant the case when the spare bits are exhausted..

> But what I mean with the above is to split the current 64bit flags value
> into a a 32 bit internal flags and a 32bit user visible flags value
> and store the ioctl flags in the latter.
>
> OTOH every filesystem but extN seem to need some conversion so btrfs
> wouldn't be unusual at that.

Not sure about extN, but one of the techniques is to represent
inode item as a set of (optional) "extensions", so that every
such extension includes it's version number (think of it as
release date). If file system driver is older, then some encountered
extension, init_inode() returns error. OTOH, if some extension
is missed, then some featured operations can be undefined (i.e.
read(), or write(), etc.. will return error). No conversion is
needed, however such approach requires more sophisticated fsck.

>   And the GETFLAGS/SETFLAGS flags value
> are pretty ugly anyway as they mix up flags for user visible behaviour
> with extN implementation details that shouldn't really need to be
> exposed to userspace.
>
>
>   

