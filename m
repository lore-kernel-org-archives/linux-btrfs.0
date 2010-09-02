From: "K. Richard Pixley" <rich@noir.com>
Subject: Re: BTRFS: Unbelievably slow with kvm/qemu
Date: Thu, 02 Sep 2010 09:36:58 -0700
Message-ID: <4C7FD2AA.8090302__42105.7067266249$1283445459$gmane$org@noir.com>
References: <4C7AB645.5090804@wpkg.org> <20100830001441.GA838@dhcp231-156.rdu.redhat.com> <4C7BD569.9000702@noir.com> <AANLkTin-BZvqCChXEmsDfjhVmRmJLaoaudnuFL6EXZQx@mail.gmail.com> <4C7D7B14.9020008@noir.com> <20100902001859.GA4930@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
To: Ted Ts'o <tytso@mit.edu>, Mike Fedyk <mfedyk@mikefedyk.com>,
	Josef Bacik <josef@redhat.com>,
	Tomasz Chmielewski <mangoo@wpkg.org>,
	linux-kernel@vger.kernel.org, linux-btrfs@vger.kerne
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20100902001859.GA4930@thunk.org>
List-ID: <linux-btrfs.vger.kernel.org>

  On 9/1/10 17:18 , Ted Ts'o wrote:
> On Tue, Aug 31, 2010 at 02:58:44PM -0700, K. Richard Pixley wrote:
>>   On 20100831 14:46, Mike Fedyk wrote:
>>> There is little reason not to use duplicate metadata.  Only small
>>> files (less than 2kb) get stored in the tree, so there should be no
>>> worries about images being duplicated without data duplication set at
>>> mkfs time.
>> My benchmarks show that for my kinds of data, btrfs is somewhat
>> slower than ext4, (which is slightly slower than ext3 which is
>> somewhat slower than ext2), when using the defaults, (ie, duplicate
>> metadata).
>>
>> It's a hair faster than ext2, (the fastest of the ext family), when
>> using singleton metadata.  And ext2 isn't even crash resistant while
>> btrfs has snapshots.
> I'm really, really curious.  Can you describe your data and your
> workload in detail?  You mentioned "continuous builders"; is this some
> kind of tinderbox setup?
I'm not familiar with tinderbox.  Continuous builders tend to be a lot 
like shell scripts - its usually easier to write a new one than to even 
bother to read someone else's.  :).

Basically, it's an automated system that started out life as a shell 
script loop around a build a few years ago.  The current rendition 
includes a number of extra features.  The basic idea here is to expose 
top-of-tree build errors as fast as possible which means that these 
machines can take some build shortcuts that would not be appropriate for 
official builds intended as release candidates.  We have a different set 
of builders which build release candidates.

When it starts, it removes as many snapshots as it needs to in order to 
make space for another build.  Initially it creates a snapshot from 
/home, checks out source, and does a full build of top of tree.  Then it 
starts over.  If it has a build and is not top of tree, it creates a 
snapshot from the last successful build, updates, and does an 
incremental build.  When it reaches top of tree, it starts taking requests.

We're using openembedded so the build is largely based on components 
with a global "BOM", (bill of materials), acting as a code based 
database of which versions of which components are in use for which 
images.  This acts as a funneling point.  Requests are a specification 
of a list of components to change, (different versions, etc).  A 
snapshot is taken from the last successful build, the BOM is changed 
locally and built incrementally.  If everything builds alright, then the 
new BOM may be committed and/or the resulting binary packages may be 
published for QA consumption.  But even in the case of failure, this 
snapshot is terminal and never marked as "successful" so never reused.

The system acts both as a continuous builder to check top of tree as 
well as an automated method for serializing changes, (which stands in 
for real, human integration).

We currently have about 20 of these servers, ranging from 2 - 24 cores, 
4 - 24G memory, etc.  A single device build takes about 22G so a 24G 
machine can do an entire build in memory.  The different machines run 
similar builds against different branches or against different targets 
and the staggering tends to create a lower response time in the case of 
top-of-tree build errors that affect all devices, (the most common type 
of error).  And most of the servers are cast offs, older servers that 
would be discarded otherwise.  Server speed tends to be an issue 
primarily for the full builds.  Once the full build has been created, 
the incrementals tend to be limited to single threading as the build 
spends most of it's time doing dependency rechecking.

The snapshot based approach is recent, as is our btrfs usage, (which is 
currently problematic, polluted file systems, kernel crashes, etc).  
Previously I was using rsync to backup a copy of a full build and rsync 
to replace it when a build failed.  The working directory was the same 
working directory and I went to some pains to make it reusable.  I've 
been looking for a snapshotting facility for a couple of years now but 
only discovered btrfs recently.  (I tried lvm based snapshots but they 
don't really have the characteristics that I want, nor do nilfs2 snapshots.)

Is that what you were looking for?

--rich
