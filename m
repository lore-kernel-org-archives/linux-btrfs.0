Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:38817 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756293AbaEGP1O (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 7 May 2014 11:27:14 -0400
Message-ID: <536A50C0.6010907@fb.com>
Date: Wed, 7 May 2014 11:26:56 -0400
From: Josef Bacik <jbacik@fb.com>
MIME-Version: 1.0
To: <bo.li.liu@oracle.com>, Filipe David Borba Manana <fdmanana@gmail.com>
CC: <linux-btrfs@vger.kernel.org>, Chris Mason <clm@fb.com>
Subject: Re: [PATCH] Btrfs: faster/more efficient insertion of file extent
 items
References: <1391989512-31797-1-git-send-email-fdmanana@gmail.com> <20140507152100.GA2702@localhost.localdomain>
In-Reply-To: <20140507152100.GA2702@localhost.localdomain>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 05/07/2014 11:21 AM, Liu Bo wrote:
> On Sun, Feb 09, 2014 at 11:45:12PM +0000, Filipe David Borba Manana wrote:
>> This is an extension to my previous commit titled:
>>
>>    "Btrfs: faster file extent item replace operations"
>>    (hash 1acae57b161ef1282f565ef907f72aeed0eb71d9)
>>
>> Instead of inserting the new file extent item if we deleted existing
>> file extent items covering our target file range, also allow to insert
>> the new file extent item if we didn't find any existing items to delete
>> and replace_extent != 0, since in this case our caller would do another
>> tree search to insert the new file extent item anyway, therefore just
>> combine the two tree searches into a single one, saving cpu time, reducing
>> lock contention and reducing btree node/leaf COW operations.
>>
>> This covers the case where applications keep doing tail append writes to
>> files, which for example is the case of Apache CouchDB (its database and
>> view index files are always open with O_APPEND).
>
> (I'm tracking a bug which is very hard to reproduce and the stack seems to
> locate on this area.)
>
> Even I know that this has been merged, I still have to say that this just
> makes the code nearly hard-to-maintained.
>
> __btrfs_drop_extents() has already been one of the most complex function since
> it was written, but now it's become more and more complex!
>
> I'm not sure whether the gained performance number deserves that kind of
> complexity, man, to be honest, try to ask yourself how much time you'll spend in
> re-understanding the code and all the details.
>

It's just a complex operation anyway, so really it's going to suck no 
matter what.  What I would like to see is some sanity tests committed 
that test the various corner cases of btrfs_drop_extents so when we make 
these sort of changes we can be sure we're not breaking anything.

So in fact that's the new requirement, whoever wants to touch 
btrfs_drop_extents next has to make sanity tests for it first, and then 
they can do what they want, this includes cleaning it up.  Thanks,

Josef

