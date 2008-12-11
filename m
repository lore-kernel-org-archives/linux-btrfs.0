From: "Lee Trager" <lt73@cs.drexel.edu>
Subject: Re: Selective Compression/Encryption
Date: Thu, 11 Dec 2008 17:03:05 -0500
Message-ID: <20081211220304.GA9082@tux64-02>
References: <20081209145952.GA30494@tux64-03> <1228840516.27601.10.camel@think.oraclecorp.com> <200812091126.04044.des@condordes.net> <493ED385.7000608@hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "Joshua J. Berry" <des@condordes.net>,
	Chris Mason <chris.mason@oracle.com>,
	Lee Trager <lt73@cs.drexel.edu>, linux-btrfs@vger.kernel.org
To: jim owens <jowens@hp.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <493ED385.7000608@hp.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Dec 09, 2008 at 03:22:29PM -0500, jim owens wrote:
> Joshua J. Berry wrote:
>> On Tuesday 09 December 2008 08:35:16 Chris Mason wrote:
>>> On Tue, 2008-12-09 at 09:59 -0500, Lee Trager wrote:
>>>> Currently compression and I assume if encryption is implemented it is
>>>> turned on or off during mount. There are however many times when a user
>>>> may want to select which files/directories they want to compress or
>>>> encrypt. This will also be helpful when implementing btrfs support in
>>>> grub for example. We can say the disk can be compressed/encrypted except
>>>> for /boot so compression/encryption doesn't have to be implemented in
>>>> grub.
>>>>
>>>> I was thinking of adding this functionality to the userspace application
>>>> btrfstune. The way I was thinking of doing this is when btrfstune +c is
>>>> applied to a directory or file the directory(and all its contents) or
>>>> file will always be compressed reguardless of how the filesystem is
>>>> mounted. The opposite would happen when btrfstune -c is used.
>>> This was my plan, but btrfstune probably isn't the best program to do it
>>> (the ext2 tune program is mostly aimed at the super block level things).
>>>
>>> I think it would be better to make a setattr style program to call the
>>> ioctls.  There is already a per file compression flag, and the code
>>> should already be checking it.
>>
>> Is there some reason this can't be done with the existing extended 
>> attribute facilities?
>>
>> It seems like xattrs would be preferable to some btrfs-specific 
>> tunable, as programs like rsync or backup tools would be able to 
>> preserve (and restore) these bits with no extra work required.
>
> I had the same thought... that many btrfs per-file tunables would
> be better implemented in xattrs (I've read christoph's earlier
> objections and hope to get around those issues).
I agree that implementing it in the xattr would be best but what
userspace tools should be used to control it? lsattr/chattr or our own?
lsattr/chattr does seem to do what we want for compression but it really
has nothing for encryption. Should we also support attribute(a), no
modification(i), etc support in xattrs?
>
> I have been working on changing the xattr code with the first
> step getting it functioning properly when selinux is enabled
> so we can see just how costly btrfs xattrs are in actual use.
Could you send me to xattr code you are working on or will you be
submitting patches soon?

Thanks,

Lee

>
> jim
