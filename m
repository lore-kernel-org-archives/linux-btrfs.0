Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from rafiki-balancer.wellbehavedsoftware.com ([78.46.156.93]:47972
	"EHLO mail.wellbehavedsoftware.com" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751985AbaI0QeC (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 27 Sep 2014 12:34:02 -0400
Message-ID: <5426E6F6.5070701@pharaoh.uk>
Date: Sat, 27 Sep 2014 18:33:58 +0200
From: James Pharaoh <james@pharaoh.uk>
MIME-Version: 1.0
To: Hugo Mills <hugo@carfax.org.uk>, linux-btrfs@vger.kernel.org
Subject: Re: BTRFS backup questions
References: <5426DA1B.9010503@pharaoh.uk> <20140927161741.GB7191@carfax.org.uk>
In-Reply-To: <20140927161741.GB7191@carfax.org.uk>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 27/09/14 18:17, Hugo Mills wrote:
> On Sat, Sep 27, 2014 at 05:39:07PM +0200, James Pharaoh wrote:

>> 2. Duplicating NOCOW files
>>
>> This is obviously possible, since it takes place when you make a snapshot.
>> So why can't I create a clone of a snapshot of a NOCOW file? I am hoping the
>> answer to this is that it is possible but not implemented yet...
>
>     Umm... you should be able to, I think.

Well I've tried with the haskell btrfs library, using clone, and also 
using cp --reflink=auto. Here's an example using cp:

root@host:/btrfs# btrfs subvolume snapshot -r src dest
Create a readonly snapshot of 'src' in './dest'
root@host:/btrfs# cp --reflink dest/test test
cp: failed to clone 'test' from 'dest/test': Invalid argument

>> I also have a question about the implementation of this. It would make
>> sense, to me, to fragment the snapshot instead of the file itself. This is
>> especially true in my case, where I am taking a snapshot which I am going to
>> discard later.
>
>     Fragmenting the snapshot would require true copy-on-write, which
> doubles the amount of writes made to the media. Btrfs's CoW
> implementation is actually redirect-on-write, which puts the
> newly-written data somewhere else. This implies that the copy being
> written to gets the fragmentation.

Yeah ok. I think I'll just have to live with this one for the time 
being. Thanks ;)

>> 3. Peformance penalty of fragmentation on SSD systems with lots of memory
>>
>     There are two performance problems with fragmentation -- seek time
> to find the fragments (which affects only rotational media), and the
> amount of time taken to manage the fragments. As the number of
> fragments increases, so does the number of extents that the FS has to
> keep track of. Ultimately, with very fragmented files, this will have
> an effect, as the metadata size will increase hugely.

Ok so this sounds like the answer I wanted to hear ;-) Presumably so 
long as the load is not too great, and I run the occasional defrag, then 
this shouldn't be much to worry about then?

>> 4. Generations and tree structures
>>
>> I am planning to use lots more clever tricks which I think should be
>> available in BTRFS, but I can't see much documentation. Can anyone point out
>> any good examples or documentation of how to access the tree structures
>> directly. I'm particularly interested in finding changed files and portions
>> of files using the generations and the tree search.
>
>     You need the TREE SEARCH ioctl -- that gives you direct access to
> all the internal trees of the FS. There's some documentation on the
> wiki about how these fit together:
>
> https://btrfs.wiki.kernel.org/index.php/Data_Structures
> https://btrfs.wiki.kernel.org/index.php/Trees
>
>     What "tricks" are you thinking of, exactly?

Principally I want to be able to detect exactly what has changed, so 
that I can perform backups very quickly. I want to be able to update a 
small portion of a large file and then identify exactly which parts 
changed and only back those up, for example.

>> 5. Project
>>
>> I've looked around for existing projects, but can't find anything apart from
>> some basic scripts. Please let me know if there are any good projects I
>> should be aware of.
>
>     There's a few of them out there. Mine, in a pretty rough state, but
> functional on a single machine at the moment, is:
>
> http://git.darksatanic.net/cgi/gitweb.cgi?p=carfax-backups.git;a=summary

Thanks I'll take a look at that one.

>     Are you aware of btrfs send/receive? It should allow you to do all
> of this. The main part of the code then comes down to managing the
> send/receive, and all the distributed error handling. Then the only
> direct access to the internal metadata you need is being able to read
> UUIDs to work out what you have on each side -- which can also be done
> by "btrfs sub list".

Yes, this is one of my main inspirations. The problem is that I am 
pretty sure it won't handle deduplication of the data.

I'm planning to have a LOT of containers running the same stuff, on fast 
(expensive) SSD media, and deduplication is essential to make that work 
properly. I can already see huge savings from this.

As far as I can tell, btrfs send/receive operates on a subvolume basis, 
and any shared data between those subvolumes is duplicated if you copy 
them separately.

I'll be very happy if this is already possible, or if there is some 
simple way around this!

My current solution, which I have already implemented in the project I 
shared, is to first snapshot all the subvolumes into an identical tree, 
then to reflink copy (or normal(ish) copy for nocow) all of the files 
over to another subvolume, which I am planning to then send/receive as a 
single entity.

I believe this will allow the deduplication to be transferred over to 
the receiving machine, and that this won't take place if I transfer the 
subvolumes separately.

Thanks,
James
