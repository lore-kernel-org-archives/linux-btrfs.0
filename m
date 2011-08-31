From: =?ISO-8859-1?Q?P=E1draig_Brady?= <P@draigBrady.com>
Subject: Re: [PATCH] xfstests 255: add a seek_data/seek_hole tester
Date: Wed, 31 Aug 2011 10:05:21 +0100
Message-ID: <4E5DF951.4010804@draigBrady.com>
References: <1309275199-10801-1-git-send-email-josef@redhat.com> <1309275199-10801-5-git-send-email-josef@redhat.com> <20110825060632.GA9933@infradead.org> <20110825064039.GO3162@dastard> <0A267E55-7772-438D-B6A7-89B73020F311@dilger.ca> <20110826013528.GW3162@dastard> <4E5D8B8E.8030401@oracle.com> <20110831032932.GI32358@dastard> <4E5DBBFD.5020202@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Dave Chinner <david@fromorbit.com>,
	Andreas Dilger <adilger@dilger.ca>,
	Christoph Hellwig <hch@infradead.org>,
	Josef Bacik <josef@redhat.com>, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org,
	xfs@oss.sgi.com, viro@ZenIV.linux.org.uk, dchinner@redhat.com
To: Sunil Mushran <sunil.mushran@oracle.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <4E5DBBFD.5020202@oracle.com>
List-ID: <linux-btrfs.vger.kernel.org>

On 08/31/2011 05:43 AM, Sunil Mushran wrote:
> On 8/30/2011 8:29 PM, Dave Chinner wrote:
>> And that's -exactly- the ambiguous, vague definition that has raised
>> all these questions in the first place. I was in doubt about whether
>> unwritten extents can be considered a hole, and by your definition
>> that means it should be data. But Andreas seems to be in no doubt it
>> should be considered a hole.
>=20
> Fair enough. Let me rephrase.
>=20
> Data:
> A range in a file when read could return something other than nulls.
>=20
> Hole:
> A range in a file when read only returns nulls.
>=20
> Considering preallocated extents only return null, they should
> be considered holes.

I would concur with this.
Treating preallocated extents as holes will allow them to be
processed quickly by `cp` etc.

What we lose is the ability to copy the allocation from src to dst.
But that's less important in comparison, and could probably be done
on a per file rather than per extent basis anyway.
Note preallocation would be good for disk layout and timely ENOSPC.

Note fiemap gives us greater control by distinguishing
holes and empty extents, thus allowing us to both
efficiently copy and maintain allocation.  But that
interface currently requires a sync of the file on some
file systems, which we couldn't enable for performance
reasons in cp.

cheers,
P=E1draig.
