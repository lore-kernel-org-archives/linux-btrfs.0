From: Roberto Ragusa <mail@robertoragusa.it>
Subject: [Fwd: Re: Linking two files together][RFC]
Date: Wed, 09 Jun 2010 13:53:00 +0200
Message-ID: <4C0F809C.4040209@robertoragusa.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

I hope that ideas about btrfs are not off-topic for this mailing list.

The forwarded message below was written by me on fedora-users.
The thread is about the ability to link two files in a manner
similar to "cat 1 2 >3 && rm 1 2" while avoiding any data
movement on the disk.
The implementation should just put the original extents together in
the new file. Is there any filesystem which is capable of doing that?
As btrfs is already based on extents and COW, couldn't this feature be
evaluated for feasibility? I think a lot of usages will be found
for it if actually implemented.

Read the following part if interested.

Thanks.

-------- Original Message --------
From: - Thu May 27 20:44:26 2010
X-Mozilla-Status: 0001
X-Mozilla-Status2: 00000000
Message-ID: <4BFE537B.8050002@robertoragusa.it>
Date: Thu, 27 May 2010 13:11:55 +0200
From: Roberto Ragusa <mail@robertoragusa.it>
User-Agent: Thunderbird 2.0.0.23 (X11/20090825)
MIME-Version: 1.0
To: Community support for Fedora users <users@lists.fedoraproject.org>
Subject: Re: Linking two files together
References: <7F593570D3366E4E85C76BAF70FD0EED0106DBF31FB1@CVMMBX.vetmed.wsu.edu> <4BFD589F.7090601@kjchome.homeip.net>
In-Reply-To: <4BFD589F.7090601@kjchome.homeip.net>
X-Enigmail-Version: 0.96.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Kevin J. Cummings wrote:
> On 05/26/2010 01:16 PM, Rector, David wrote:
>> Hello,
>>
>> I have studied various filesystems, and am fairly familiar with how they are structured. However, I am currently stuck on trying to do what seems like a simple thing.
>>
>> I would like to join two files together without having to physically copy bytes (i.e. I have vary large files, so I don't want to use 'cat'). It seems to me that it should be possible to simply modify the file entry in the filesystem such that the last inode of the first file points to the first inode of the second file. I guess this is similar to a "hard link", but used to join files rather than simply have another pointer to one file.
>>
>> I have seen 'mmv' and 'lxsplit' and they all seem to do the same thing, namely they want to physically copy the bytes in order to join two files together.
>>
>> Is there any such utility in linux to perform such a hard link to join or connect two files together without having to copy bytes?
> 
> If you could guarantee that the last extent used by the first file was
> completely full of data with no extraneous bytes, it might be possible
> to "merge" the extent maps of the 2 files into a single file entry.  If
> you cannot guarantee that, then you will have to copy bytes from the 2nd
> file to the end of the first file.

But everything becomes possible if the fileystem permits partially empty blocks
in the middle of the file. No filesystem does it AFAIK, but it is not a
big issue, as partial blocks (or compacted tails) are already permitted
at the end of the file. New filesystems use extents rather than blocks,
so if the extents are measured in bytes instead of 512b-blocks you can
just use a smaller extent in the middle of the file where the join happened.

At this point, you can support inplace-joining, inplace-inflating (add 10000 bytes
in this file at position 300000), inplace-erasure (remove 10000 bytes
at position 300000) and data shuffling (swap the first 50meg of the file with
the last 50meg).

With heavy usage you have just created a new kind of fragmentation, which can
be corrected with the usual defragmentation tools (including "cp").
(add that fragmentation is losing importance with the spreading of SSD)

Considering that sparse files have been a reality for decades and that
the implementation of operation with inside-file byte-grained extents
is not more difficult than truncate, I wonder if we will see something
of this kind in some advanced filesystem (btrfs?).

There are a lot of possible uses:
- delete/replace mail in mbox format repositories
- smart packaging (delete from tar, delete from zip)
- in-place iso creation
and.... just imagine.....
- video editing (!) add/remove/replace frames inside a 150GiB captured video

Where can you submit ideas to btrfs?
It also has COW, so everything becomes even more exciting...

-- 
   Roberto Ragusa    mail at robertoragusa.it


-- 
   Roberto Ragusa    mail at robertoragusa.it
