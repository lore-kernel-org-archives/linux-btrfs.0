From: =?ISO-8859-1?Q?P=E1draig_Brady?= <P@draigBrady.com>
Subject: Re: [PATCH] xfstests 255: add a seek_data/seek_hole tester
Date: Wed, 29 Jun 2011 22:29:57 +0100
Message-ID: <4E0B9955.3040905@draigBrady.com>
References: <1309275199-10801-1-git-send-email-josef@redhat.com> <1309275199-10801-5-git-send-email-josef@redhat.com> <20110629065306.GC1026@dastard> <20110629074021.GA26086@infradead.org> <4E0B019E.8080800@draigBrady.com> <4E0B60DE.50908@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Christoph Hellwig <hch@infradead.org>,
	Dave Chinner <david@fromorbit.com>,
	Josef Bacik <josef@redhat.com>, linux-fsdevel@vger.kernel.org,
	viro@ZenIV.linux.org.uk, linux-kernel@vger.kernel.org,
	linux-btrfs@vger.kernel.org, xfs@oss.sgi.com
To: Sunil Mushran <sunil.mushran@oracle.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <4E0B60DE.50908@oracle.com>
List-ID: <linux-btrfs.vger.kernel.org>

On 29/06/11 18:29, Sunil Mushran wrote:
> On 06/29/2011 03:42 AM, P=E1draig Brady wrote:
>> There is the argument, that if this interface can distinguish
>> these dirty unwritten extents, then why can't the fiemap interface t=
oo?
>> The advantage of the fiemap interface is that it can distinguish
>> empty extents vs holes. Empty extents will become increasingly commo=
n
>> I think, given the fragmentation and space guarantee benefits they g=
ive.
>> It would be cool for cp for example to be able to efficiently copy
>> empty extents from source to dest.
>=20
> I'm not too sure about that. Atleast not enabled by default. Most use=
rs
> use cp to backup data. Not empty space. In this case, this empty exte=
nt
> may not even be de-dupable.

That's a fair point. On the other hand if
you wanted to start working with the backup copy,
you might want it allocated to avoid fragmentation and ENOSPC issues.
What we were going with was empty -> hole with cp --sparse=3Dalways
and empty -> empty otherwise. If empty and hole can not be
distinguished though, then this process will be impacted.

>=20
> Frankly I'd be happier of cp started to exploited fallocate() to crea=
te
> larger
> extents before copying data into them. Atleast for the large files.

Yes we definitely will start doing that.
That will help fragmentation and give early ENOSPC.
We can't use fiemap for this at the moment
(on XSF or ext4 (without a sync))
but the seek_data interface should allow us
to do this to some extent (pardon the pun).

cheers,
P=E1draig.
