From: =?ISO-8859-1?Q?P=E1draig_Brady?= <P@draigBrady.com>
Subject: Re: BTRFS file clone support for cp
Date: Wed, 29 Jul 2009 15:14:49 +0100
Message-ID: <4A705959.7010303@draigBrady.com>
References: <87d47o3fip.fsf@master.homenet> <4A6CEA48.5050208@draigBrady.com> <8763defuvq.fsf@meyering.net> <87ws5tvrq8.fsf@master.homenet> <4A6E3ADE.6050008@draigBrady.com> <8763dcvagk.fsf@master.homenet> <20090729130106.GF13940@think>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: Chris Mason <chris.mason@oracle.com>,
	Giuseppe Scrivano <gscrivano@gnu.org>,
	Jim Meyering <jim@meyering.net>, bug-coreutils@gnu.org,
	linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20090729130106.GF13940@think>
List-ID: <linux-btrfs.vger.kernel.org>

Chris Mason wrote:
> On Tue, Jul 28, 2009 at 10:06:35PM +0200, Giuseppe Scrivano wrote:
>>
>> I can't replicate it now, all tests I am doing report that blocks us=
ed
>> before and after the clone are the same.  Probably yesterday the
>> difference I noticed was in reality the original file flushed to the
>> disk.
>=20
> The clone will use some additional space for the metadata required to
> point to the cloned blocks.  It isn't exactly O(1) it is O(metadata f=
or
> the file).

Thanks for the clarification Chris.
So the just committed change in cp will
link the destination file to the extents of the source.

We may need to play around with fallocate()
if we want to get back to the original
cp semantics of actually allocating space
on the file system for the new file.

I'll test this when I get an up to date btrfs
and when the fallocate interface in glibc settles down.

cheers,
P=E1draig.
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
