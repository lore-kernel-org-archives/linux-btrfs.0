From: Gordan Bobic <gordan@bobich.net>
Subject: Re: What to do about subvolumes?
Date: Wed, 01 Dec 2010 16:48:02 +0000
Message-ID: <4CF67C42.9080406@bobich.net>
References: <20101201142136.GD427@dhcp231-156.rdu.redhat.com> <20101201163800.GA4087@carfax.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
To: Hugo Mills <hugo-lkml@carfax.org.uk>,
	Josef Bacik <josef@redhat.com>, linux-btrfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, chris.mason@oracle.com, hch@lst.de,
	ssorce@redhat.com
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20101201163800.GA4087@carfax.org.uk>
List-ID: <linux-btrfs.vger.kernel.org>

Hugo Mills wrote:
> On Wed, Dec 01, 2010 at 09:21:36AM -0500, Josef Bacik wrote:
>> === Quotas ===
>>
>> This is a huge topic in and of itself, but Christoph mentioned wanting to have
>> an idea of what we wanted to do with it, so I'm putting it here.  There are
>> really 2 things here
>>
>> 1) Limiting the size of subvolumes.  This is really easy for us, just create a
>> subvolume and at creation time set a maximum size it can grow to and not let it
>> go farther than that.  Nice, simple and straightforward.
>>
>> 2) Normal quotas, via the quota tools.  This just comes down to how do we want
>> to charge users, do we want to do it per subvolume, or per filesystem.  My vote
>> is per filesystem.  Obviously this will make it tricky with snapshots, but I
>> think if we're just charging the diff's between the original volume and the
>> snapshot to the user then that will be the easiest for people to understand,
>> rather than making a snapshot all of a sudden count the users currently used
>> quota * 2.
> 
>    This is going to be tricky to get the semantics right, I suspect.
> 
>    Say you've created a subvolume, A, containing 10G of Useful Stuff
> (say, a base image for VMs). This counts 10G against your quota. Now,
> I come along and snapshot that subvolume (as a writable subvolume) --
> call it B. This is essentially free for me, because I've got a COW
> copy of your subvolume (and the original counts against your quota).
> 
>    If I now modify a file in subvolume B, the full modified section
> goes onto my quota. This is all well and good. But what happens if you
> delete your subvolume, A? Suddenly, I get lumbered with 10G of extra
> files.  Worse, what happens if someone else had made a snapshot of A,
> too? Who gets the 10G added to their quota, me or them? What if I'd
> filled up my quota? Would that stop you from deleting your copy,
> because my copy can't be charged against my quota? Would I just end up
> unexpectedly 10G over quota?
> 
>    This is a whole gigantic can of worms, as far as I can see, and I
> don't think it's going to be possible to implement quotas, even on a
> filesystem level, until there's some good and functional model for
> dealing with all the implications of COW copies. :(

I would argue that a simple and probably correct solution is to have the 
files count toward the quota of everyone who has a COW copy. i.e. if I 
have a volume A and you make a snapshot B, the du content of B should 
count toward your quota as well, rather than being "free". I don't see 
any reason why this would not be the correct and intuitive way to do it. 
Simply treat it as you would transparent block-level deduplication.

Gordan
