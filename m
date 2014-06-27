Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:38837 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753187AbaF0Pg6 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 27 Jun 2014 11:36:58 -0400
Message-ID: <53AD8F96.4060401@redhat.com>
Date: Fri, 27 Jun 2014 10:36:54 -0500
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
To: dsterba@suse.cz, linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] btrfs-progs: add supported attr flags to btrfs(5)
References: <53AC84C9.2080106@redhat.com> <20140627134257.GE1553@twin.jikos.cz> <53AD860A.8090804@redhat.com> <20140627153017.GF1553@suse.cz>
In-Reply-To: <20140627153017.GF1553@suse.cz>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 6/27/14, 10:30 AM, David Sterba wrote:
> On Fri, Jun 27, 2014 at 09:56:10AM -0500, Eric Sandeen wrote:
>>> * and 'X' does not mean "no compression" and never has, although I'd
>>>   like to see a chattr bit for that because we have the corresponding
>>>   inode bit
>>
>> Ok, then I'm not sure what it does mean.  Supposedly these flags are supported;
>> via check_flags(), called by setflags(), which I was basing these on:
>>
>>         if (flags & ~(FS_IMMUTABLE_FL | FS_APPEND_FL | \
>>                       FS_NOATIME_FL | FS_NODUMP_FL | \
>>                       FS_SYNC_FL | FS_DIRSYNC_FL | \
>>                       FS_NOCOMP_FL | FS_COMPR_FL |
>>                       FS_NOCOW_FL))
>>
>> and the kernel header says that's:
>>
>> #define FS_NOCOMP_FL                    0x00000400 /* Don't compress */
> 
> Passing this bit directly via ioctl works as expected, but to my
> knowledge there is no chattr letter allocated for it.

it's in the manpage, but as a read-only attribute, i.e. lsattr only.

>> chattr(1) says: "compression raw access (X)," and also "The ’X’ attribute
>> is used by the experimental compression patches to indicate that a raw
>> contents of a compressed file  can  be  accessed  directly.  It currently 
>> may not be set or reset using chattr(1), although it can be displayed by lsattr(1)."
>>
>> Hum, ok, so we are starting to go off the rails here, aren't we ;)
> 
> Yeah. And there's no support for accessing raw compressed data.
> 
>> e2fsprogs has this flag translation:
>>          { EXT2_NOCOMPR_FL, "X", "Compression_Raw_Access" },
>> for:
>> #define EXT2_NOCOMPR_FL                 0x00000400 /* Access raw compressed data */
>>
>> and btrfs_ioctl_setflags claims to handle it:
>>
>>         if (flags & FS_NOCOMP_FL) {
>>                 ip->flags &= ~BTRFS_INODE_COMPRESS;
>>                 ip->flags |= BTRFS_INODE_NOCOMPRESS;
>> 		...
>>
>> so hopefully you can understand my confusion? ;)
> 
> Oh I do now, but it's ext2 fault :)

Ok but btrfs setflags tries to handle "FS_NOCOMP_FL" - how is that ever set?

>> The comment says:
>>
>>          * The COMPRESS flag can only be changed by users, while the NOCOMPRESS
>>          * flag may be changed automatically if compression code won't make
>>          * things smaller.
>>
>> (but doesn't says "may *only* be...")
> 
> And thats IMO right (at least I expect it work like that), the user may
> set or drop the NOCOMPRESS flag. The comment says that it may appear
> without user interaction.
> 
>> But OTOH, chattr won't ever even *pass* "X" to the fs, will it.
>>
>> So I guess I'm lost.  It looks like there's code to handle an incoming
>> "X" but I don't think chattr will send it.
>>
>> Do we ever get an outbound "X" for an opportunistically not-compressed file?
>> If so, maybe that still needs to be specified.
> 
> AFAICS 'X' is not listed among the standard chattr options and chattr.c
> in e2fsprogs has no support for that.
> 
> There is
> 
> lib/e2p/pf.c:   { EXT2_NOCOMPR_FL, "X", "Compression_Raw_Access" },
> 
> but this is used only locally by print_flags.

Right, it's a "read-only" flag for lsattr.

> I hope this answers your questions, 'X' has no meaning for btrfs now.

The only remaining question is, why does the btrfs setflags interface
try to parse it, if nothing sends it?  Or if something does send it,
what?  And where is this all documented? ;)

btrfs tries to handle a flag value which is identical to the
'X' flag value, which lsattr/chattr says is readonly...

-Eric
