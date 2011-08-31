From: Sunil Mushran <sunil.mushran@oracle.com>
Subject: Re: [PATCH] xfstests 255: add a seek_data/seek_hole tester
Date: Tue, 30 Aug 2011 21:43:41 -0700
Message-ID: <4E5DBBFD.5020202@oracle.com>
References: <1309275199-10801-1-git-send-email-josef@redhat.com> <1309275199-10801-5-git-send-email-josef@redhat.com> <20110825060632.GA9933@infradead.org> <20110825064039.GO3162@dastard> <0A267E55-7772-438D-B6A7-89B73020F311@dilger.ca> <20110826013528.GW3162@dastard> <4E5D8B8E.8030401@oracle.com> <20110831032932.GI32358@dastard>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Cc: Andreas Dilger <adilger@dilger.ca>,
	Christoph Hellwig <hch@infradead.org>,
	Josef Bacik <josef@redhat.com>, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org,
	xfs@oss.sgi.com, viro@ZenIV.linux.org.uk, dchinner@redhat.com
To: Dave Chinner <david@fromorbit.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20110831032932.GI32358@dastard>
List-ID: <linux-btrfs.vger.kernel.org>

On 8/30/2011 8:29 PM, Dave Chinner wrote:
> And that's -exactly- the ambiguous, vague definition that has raised
> all these questions in the first place. I was in doubt about whether
> unwritten extents can be considered a hole, and by your definition
> that means it should be data. But Andreas seems to be in no doubt it
> should be considered a hole.

Fair enough. Let me rephrase.

Data:
A range in a file when read could return something other than nulls.

Hole:
A range in a file when read only returns nulls.

Considering preallocated extents only return null, they should
be considered holes.


