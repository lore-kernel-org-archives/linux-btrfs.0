From: David Sterba <dave@jikos.cz>
Subject: Re: Updated btrfs/crypto snappy interface ready for merging
Date: Tue, 17 Jan 2012 10:07:46 +0100
Message-ID: <20120117090746.GD7322@twin.jikos.cz>
References: <1326414530-10789-1-git-send-email-andi@firstfloor.org>
Reply-To: dave@jikos.cz
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: chris.mason@oracle.com, linux-kernel@vger.kernel.org,
	linux-btrfs@vger.kernel.org
To: Andi Kleen <andi@firstfloor.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1326414530-10789-1-git-send-email-andi@firstfloor.org>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jan 12, 2012 at 04:28:47PM -0800, Andi Kleen wrote:
> Here's a slightly updated version of the BTRFS snappy interface.
> snappy is a faster compression algorithm that provides similar
> compression as LZO, but generally better performance.

Recently the LZ4 method showed up on the real-time compression scene

http://fastcompression.blogspot.com/p/lz4.html (homepage)
http://code.google.com/p/lz4/ (source repo)

it has comparable performance and compression ratio to snappy. Quoting
from the source repo main page:

Name            Ratio   C.speed D.speed
LZ4 (r41)       2.08    319     1070
LZO 2.05 1x_1   2.07    318      466
Snappy 1.0.4    2.02    242      683

My own benchmarking confirms that lz4 is has a bit faster decompression,
but what is a big difference from snappy is it's memory consumption for
compression:
* 32kb for unbounded chunksize
* 16kb for chunksize < 64k (a tuned compression)

No additional memory is needed for decompression in both snappy and lz4.
With a minor tweak and chunksize < 4G the context size could be reduced
to 16k as well.

There is also LZ4HC, "high compression" mode, which maintains same
binary format, but the compression ratio is better.

http://code.google.com/p/lz4hc/

Usecase:
There could be the fast version used transparently and the -hc version
could be allowed for the 'fi defrag' command in order to recompress
selected files.

LZ4 is written in C and it's BSD, LZ4HC is L-GPL. There is some space
for improvements in the code, but as it's good already as it stands now.


david
