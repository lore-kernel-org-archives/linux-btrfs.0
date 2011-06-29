From: Sunil Mushran <sunil.mushran@oracle.com>
Subject: Re: [PATCH] xfstests 255: add a seek_data/seek_hole tester
Date: Wed, 29 Jun 2011 10:29:02 -0700
Message-ID: <4E0B60DE.50908@oracle.com>
References: <1309275199-10801-1-git-send-email-josef@redhat.com> <1309275199-10801-5-git-send-email-josef@redhat.com> <20110629065306.GC1026@dastard> <20110629074021.GA26086@infradead.org> <4E0B019E.8080800@draigBrady.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Cc: Christoph Hellwig <hch@infradead.org>,
	Dave Chinner <david@fromorbit.com>,
	Josef Bacik <josef@redhat.com>, linux-fsdevel@vger.kernel.org,
	viro@ZenIV.linux.org.uk, linux-kernel@vger.kernel.org,
	linux-btrfs@vger.kernel.org, xfs@oss.sgi.com
To: =?ISO-8859-1?Q?P=E1draig_Brady?= <P@draigBrady.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <4E0B019E.8080800@draigBrady.com>
List-ID: <linux-btrfs.vger.kernel.org>

On 06/29/2011 03:42 AM, P=E1draig Brady wrote:
> There is the argument, that if this interface can distinguish
> these dirty unwritten extents, then why can't the fiemap interface to=
o?
> The advantage of the fiemap interface is that it can distinguish
> empty extents vs holes. Empty extents will become increasingly common
> I think, given the fragmentation and space guarantee benefits they gi=
ve.
> It would be cool for cp for example to be able to efficiently copy
> empty extents from source to dest.

I'm not too sure about that. Atleast not enabled by default. Most users
use cp to backup data. Not empty space. In this case, this empty extent
may not even be de-dupable.

=46rankly I'd be happier of cp started to exploited fallocate() to crea=
te larger
extents before copying data into them. Atleast for the large files.
--
To unsubscribe from this list: send the line "unsubscribe linux-fsdevel=
" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
