From: =?ISO-8859-1?Q?J=E9r=F4me_Poulin?= <jeromepoulin@gmail.com>
Subject: Re: [PATCH 0/2] btrfs: allow cross-subvolume BTRFS_IOC_CLONE
Date: Sat, 2 Apr 2011 16:01:43 -0400
Message-ID: <-5611378764978042575@unknownmsgid>
References: <cover.1301542804.git.larry@elder-gods.org> <20110331063636.GA5297@infradead.org>
 <1301572893-sup-3464@think> <20110401133405.GA17956@infradead.org>
 <1301759479.8770.8.camel@tankquad> <20110402165629.GA24734@cthulhu>
Mime-Version: 1.0 (iPhone Mail 8B117)
Content-Type: text/plain; charset=ISO-8859-1
Cc: Ken Drummond <btrfs@kendrummond.com>,
	linux-btrfs <linux-btrfs@vger.kernel.org>,
	Christoph Hellwig <hch@infradead.org>
To: "Larry D'Anna" <larry@elder-gods.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20110402165629.GA24734@cthulhu>
List-ID: <linux-btrfs.vger.kernel.org>

I am very happy to see this patch. It was one of the first thing I
tried after making a subvolume, cp --reflink, and it failed. I'll have
to try this out.

J=E9r=F4me Poulin

On 2011-04-02, at 12:56, Larry D'Anna <larry@elder-gods.org> wrote:

> * Ken Drummond (btrfs@kendrummond.com) [110402 11:51]:
>> I don't really understand the details here, but doesn't the creation=
 of
>> a snapshot already lead to data extents being shared between
>> sub-volumes?  From a simple user perspective this sounds like a very
>> useful capability.
>
> I was surprised and frustrated to find it missing.  I had just copied=
 a large
> quantity of data into btrfs, realized i need to make a subvolume to t=
ry out
> snapshotting, and then found out i had to copy all the data *again* t=
o get it
> into a subvolume.  There are tons of scenarios where users will want =
and expect
> to be able to do this.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs=
" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
