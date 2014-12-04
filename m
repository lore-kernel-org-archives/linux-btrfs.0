Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:33248 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750725AbaLDG5k convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 4 Dec 2014 01:57:40 -0500
Message-ID: <548005B7.40503@cn.fujitsu.com>
Date: Thu, 4 Dec 2014 14:56:55 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
To: Robert White <rwhite@pobox.com>, linux-btrfs <linux-btrfs@vger.kernel.org>
CC: David Sterba <dsterba@suse.cz>
Subject: Re: Crazy idea of cleanup the inode_record btrfsck things with SQL?
References: <547BCB43.5020505@cn.fujitsu.com> <547BE8A5.7050900@pobox.com> <547C0834.7090706@cn.fujitsu.com> <547CAF2E.7070109@pobox.com> <547D1339.10404@cn.fujitsu.com> <547F61F6.7020707@pobox.com>
In-Reply-To: <547F61F6.7020707@pobox.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


-------- Original Message --------
Subject: Re: Crazy idea of cleanup the inode_record btrfsck things with SQL?
From: Robert White <rwhite@pobox.com>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>, linux-btrfs 
<linux-btrfs@vger.kernel.org>
Date: 2014年12月04日 03:18
> On 12/01/2014 05:17 PM, Qu Wenruo wrote:
>> But I am also somewhat tired of bringing new structure new searching
>> functions or even bring larger change on
>> the btrfsck record infrastructure when I found that can't provide the
>> function when new recovery function is going
>> to be implemented.
>
> DISCLAIMER: My actual thing is modeling, so coming from the idea that 
> btrfsck is basically building a model of the filesystem and comparing 
> the theoretically correct model to the actual filesystem as found... 
> and having spent nearly zero time inside of the btrfsck code base 
> itself...
>
> I've looked at what I _think_ you are trying to do with the 
> lookup/correlate phase finding peer/parent/child references and I'd 
> think other things would make sense far more sense than SQL.
>
> C++ Standard Template Library at a minimum, life is too short to 
> reinvent data lookups in memory. But its also too short to re-factor 
> SQL queries or wait for degenerate full-table scans.
C++ doesn't comes to me in my first thought, since I haven't use it for 
a long long time... :-(
>
> The boost "multi-index container", if you are going to bring in an 
> external library, would do you far better for dealing with future 
> structural changes. It would directly index the fields of your 
> (parent,child,name) relation and let you switch iteration on-the-fly 
> (e.g. you can be walking parents and use the same iterator to start 
> walking names etc). (there's even a cookbook item for adding an LRU 
> cache as a natural index for space-constrained items.) Again you'd 
> have to switch over to C++, but it implements exactly what I think you 
> are looking for. the multi-index container declaration syntax gets a 
> little thick but once declared the usage model is really simple. (you 
> pay most-or-all the cost during "update" which is really a 
> remove-then-readd but you won't be updating as often as adding so...)
Yeah, C++ seems much easier to switch, but as the preparation, it is 
better to cleanup the inode_record codes from
cmds-check.c and put them into a single file.
After the cleanup, I think we can even have different backend to test with.
(Only to test, multi-backend support also seems to be overkilled)
>
> My "crazy-ist idea" would be to maybe mmap all the metadata from the 
> filesystem into the process space and build a page-table-like index 
> over that. The virtual memory demand paging will become your caching 
> buddy. mapped_block+offest gets you directly to the whole native 
> structure. You might have to juggle mappings (map and unmap them) on 
> systems with arger filesystems but smaller virtual tables (e.g. 
> classic pentium 32 bit). Even then, you'd be juggling mappings and the 
> kernel would be doing all the real caching. The more data you can 
> leave in the mmapped ranges the less storage management takes place in 
> the local code.
>
> IMHO, finding a USB stick to make a swap space on is probably just as 
> good, if not better than, doing it with a whole other filesystem and 
> the "put my temp files there" option during emergency maintenance.
Sadly, there is already user complaining about the memory usage:
http://comments.gmane.org/gmane.comp.file-systems.btrfs/34573

The 13T fs may contain several hundreds GB of metadata, already takes 
over 8G memory.
It may takes up 10+ of GB memory, so a memory stick may help but when it 
happens on a remote server?
Or can you tolerate the snail like slow IO speed?
So better store them on disk when things go really huge.

Map and unmap will be good,but it may not resolve the problem at all.
The main memory usage in btrfsck is extent record, which
we can't free them until we read them all in and checked, so even we 
mmap/unmap, it can only help with
the extent_buffer(which is already freed if not used according to refs).

Now, I miss the page cache in kernel so much...

Anyway, btrfsck should really consider about the memory usage now.

>
>
> If the mailing list engine honors attachments, you will find 
> FileEntries.h from one of my projects, offered as a simplified example 
> of a directory entry cache implemented in a boost multi-index container.
>
> (Note that this is fully working code from an upcoming addition to my 
> soruceforge project, so it's not just theoretical implementation ideas.)
>
> struct FileEntry {
>   struct NameIndex {};
>   struct DirectoryIndex {};
>   struct INodeIndex {};
>   struct TypedIndex {};
>   dev_t         Device;
>   long          ParentINode;
>   long          INode;
>   std::string   Name;
>   enum FileType Type;
> };
>
> The empty structs inside the struct act as index identifiers/names 
> (Because C++ templates only disambiguate on types so 
> FileEntry::NameIndex is the type-name of the index of file names (etc).
>
> Any other data could be added to FileEntry without disrupting any 
> existing code for indexing or iterating.
>
> The container itself is a little grusome textually ::
>
> typedef multi_index_container<
>   FileEntry,
>   indexed_by<
>     ordered_non_unique<
>       tag<FileEntry::NameIndex>,
>       member<
>         FileEntry,
>         std::string,
>         &FileEntry::Name
>       >
>     >,
>     ordered_non_unique<
>       tag<FileEntry::DirectoryIndex>,
>       composite_key<
>         FileEntry,
>         member<
>           FileEntry,
>           dev_t,
>           &FileEntry::Device
>         >,
>         member<
>           FileEntry,
>           long,
>           &FileEntry::ParentINode
>         >
>       >
>     >,
>     ordered_non_unique<
>       tag<FileEntry::INodeIndex>,
>       composite_key<
>         FileEntry,
>         member<
>           FileEntry,
>           dev_t,
>           &FileEntry::Device
>         >,
>         member<
>           FileEntry,
>           long,
>           &FileEntry::INode
>         >
>       >
>     >,
>     ordered_non_unique<
>       tag<FileEntry::TypedIndex>,
>       composite_key<
>         FileEntry,
>         member<
>           FileEntry,
>           enum FileType,
>           &FileEntry::Type
>         >,
>         member<
>           FileEntry,
>           std::string,
>           &FileEntry::Name
>         >
>       >
>     >
>   >
> > FileSet;
>
>
> But after that it's super easy to use, uh, if you know STL iterator 
> speak anyway. 8-)
>
> Having a file set is easy and typesafe in any type-able context (such 
> as a member of another structure, or a global):
> FileSet result;
>
> Picking yoru index/view has to be done by (admittedly ugly looking) type
> FileSet::index<FileEntry::NameIndex>::type
>
> But then when you make one and plumb it ("result" being the working set
> FileSet::index<FileEntry::NameIndex>::type & by_name = 
> result.get<FileEntry::NameIndex>();
>
> by_name is now a fully functional view of the set as an iteraterable 
> container with elements like by_name.erase(some_name) and such.
>
> It gets you what you say you want from SQL but without all the 
> indirection or duplication of SQL.
>
> (Note that the attached example will fill a FileSet object into memory 
> with the entire (sub) tree of a file system if you call Fill() with 
> the deep selector; or just fill the set with the contents of a single 
> directory when the shallow selector is used.
>
> etc.
>
> So anyway. I've been in this modeling space for a while. I looked at 
> other means of modeling such as SQL and I decided this one was "the 
> best" for what I was doing.
>
> The results are fast, deterministic, and type-safe with no internal 
> typecasts or full table scan results.
Great implement! Almost fits all the needs, except the ability to save 
it on disk...

In fact, I have already an idea to implement it in pure C, although not 
so generic than C++ template, but should
work anyway.

So the remaining problem will be the ability to cache things on disk for 
case like the 13T array.

For C/C++, saving recording to disk will be a simplified version of page 
cache, but will still be a huge chanllenge.
For SQL, it will be much easier but I am consider it as the last try 
now, since the C++ implement seems quite good.

Anyway, the memory usage problem is still a problem to resolve.

Thanks,
Qu
