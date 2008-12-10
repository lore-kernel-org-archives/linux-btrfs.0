From: Linda Knippers <linda.knippers@hp.com>
Subject: Re: Selective Compression/Encryption
Date: Wed, 10 Dec 2008 13:02:56 -0500
Message-ID: <49400450.2070703@hp.com>
References: <20081209145952.GA30494@tux64-03> <f058a9c30812090745v15b5f983u468b560ae791dc37@mail.gmail.com> <200812091722.21567.mail@earthworm.de> <20081209180951.GA6551@tux64-03> <20081210000512.7be20413@diego-desktop> <493F043B.50804@hp.com> <1228916687.11900.10.camel@think.oraclecorp.com> <20081210175538.GA23225@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Chris Mason <chris.mason@oracle.com>, jim owens <jowens@hp.com>,
	Diego Calleja <diegocg@gmail.com>,
	Lee Trager <lt73@cs.drexel.edu>,
	Christian Hesse <mail@earthworm.de>, miguel.filipe@gmail.com,
	linux-btrfs@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20081210175538.GA23225@infradead.org>
List-ID: <linux-btrfs.vger.kernel.org>

Christoph Hellwig wrote:
> On Wed, Dec 10, 2008 at 08:44:47AM -0500, Chris Mason wrote:
>> I had planned to make the bits inheritable from the directory inode
>> flags.  There are two different discussions around xattrs for this.  One
>> is using xattrs to store the flag, which I'd would rather avoid because
>> it is checked in some performance critical places.
>>
>> The second is using xattr programs to set the flag, which I don't really
>> have an opinion on.  The idea of having the flags backed up by backup
>> programs or rsync is really nice, but do any of the backup programs
>> actually copy out all the xattrs?
> 
> xfsdump does :)  But I think especially the compressed bit is much
> better off in the bit for the set/get flags ioctls used by chattr /
> lsattr.  These are implemented by all Linux filesystems, and even have
> a compressed bit allocated already.  (and xfsdump of course backs them
> up, too ;-))  *run*

The 'star' command has an -xattr option.

-- ljk


