Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:35177 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750927AbaAWSg0 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 23 Jan 2014 13:36:26 -0500
Date: Thu, 23 Jan 2014 19:36:24 +0100
From: David Sterba <dsterba@suse.cz>
To: Roger Binns <rogerb@rogerbinns.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Working on Btrfs as topic for master thesis
Message-ID: <20140123183624.GQ6498@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <8E968DF3B7EC0D40B67B5A9D25675A6A03FC70@MBXSRV03EDU.edu.local>
 <lbid3r$1ui$1@ger.gmane.org>
 <20140122121220.GF6498@twin.jikos.cz>
 <lbpb7v$7m2$1@ger.gmane.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <lbpb7v$7m2$1@ger.gmane.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jan 22, 2014 at 12:55:39PM -0800, Roger Binns wrote:
> There was the theoretical side - ie coming up with a way of defining
> perfection which then allows measuring against.  For example you have
> going up to a 128K block size but without knowing the theoretical best we
> don't know if that is a stopgap or very good.

I got some inspiration from
http://web.archive.org/web/20060511214233/http://www.namesys.com/compression.txt
there's a metric proposed and some analysis of cluster sizes.

Referenced from
http://web.archive.org/web/20070403001821/http://www.namesys.com/cryptcompress_design.html
with the related filesysem details

'Theoretical best' seems too vaguely defined, with compression it's
always some trade-off and compromise (comp/decomp speed vs ratio) and
counting the filesystem requirements like a reasonable read and write
latencies/throughput it's not getting easier.

The main categories I'm targeting are 'real-time, good on average for
random read-write', and 'slow, high compression ratio, expected
streaming reads/writes'.

I'm trying to evaluate the effects of the changes with respect to the
filesystem, eg. when the larger chunk means the ratio improves from 80%
to 70% for some data set type, what's the reduced block count and if
it's worth.

If the interface is flexible enough, it gives the user chance to
experiment with the options and make the choice.

> That also feeds into things like if it would be a good idea to go back
> afterwards (perhaps as part of defrag) and spend more effort on
> (re)compression.

This is a bit different usecase, defrag is triggered by user at the time
he knows the resources are available and usually on known files and
their potential compressibility. More, the userspace defrag process can
do a preliminary analysis of the files, eg. guess the mime type or do a
random sample of the file data and guess compressibility.

> Another consideration is perhaps having the compression dictionary kept
> separate from the compressed blocks thereby allowing it to be used across
> blocks and potentially files.  Compressors like smaz (very good on short
> pieces of text) work by having a precomputed dictionary - perhaps those
> can be used too.

Keeping the dictionary implies more data to be read/written, with small
chunks there's a low chance of actual dictionary reuse for other files.
Also, thinking about the implementaion, it would become too complex to
do in kernel for this particular usecase.

It's interesting theoretically, there's a paper about that

"To Zip or Not to Zip: Effective Resource Usage for Real-Time
Compression"
https://www.usenix.org/conference/fast13/technical-sessions/presentation/harnik

but haven't found it feasible to push the implementation to kernel and
worth the required disk format changes.
