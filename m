From: Linda Knippers <linda.knippers@hp.com>
Subject: Re: [RFC] new free space caching stuff
Date: Tue, 26 May 2009 12:12:21 -0400
Message-ID: <4A1C14E5.2050601@hp.com>
References: <20090521184351.GC11101@dhcp231-156.rdu.redhat.com> <20090522141133.GA8762@think>
Reply-To: linda.knippers@hp.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: Chris Mason <chris.mason@oracle.com>,
	Josef Bacik <josef@redhat.com>, linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20090522141133.GA8762@think>
List-ID: <linux-btrfs.vger.kernel.org>

Chris Mason wrote:
> On Thu, May 21, 2009 at 02:43:52PM -0400, Josef Bacik wrote:
>> Hello,
>>
>> Okay I'm looking at redoing all of this stuff again, and I'd like to make this
>> the last time, so I'm going to outline what we currently have, what the problems
>> are with it, and what I want to do.  I would appreciate any/all input so I can
>> try and get this right the first time.
>>
> 
> Josef and I hashed this out someone on IRC.  I think the bitmaps alone
> aren't going to scale all that well for huge filesystems, so he is
> looking into a hybrid bitmap/extent approach based on the size of the
> free space.

I don't know if this is of any interest but I thought I'd provide a
pointer to the AdvFS design spec for space allocation.
http://advfs.svn.sourceforge.net/viewvc/advfs/advfs_design_docs_v1/porting_designs/storage_allocation.pdf?revision=1

The Tru64 version of AdvFS used bitmaps but this was changed during the
port to HP-UX to
use a combination of b-trees.  Both the original and new designs are
discussed in
section 2 of the spec and there's a description of other design options
considered but then rejected.

The docs in the original tarball I posted were not very user friendly so
I checked them into an svc tree to make them a little easier to browse.
If it will be useful, I can do the same with the source code.

-- ljk

> -chris
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

