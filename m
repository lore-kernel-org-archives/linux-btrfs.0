From: Dan Merillat <dan.merillat@gmail.com>
Subject: Re: [PATCH 1/4] Btrfs: fix defragmentation regression
Date: Tue, 18 Oct 2011 04:48:08 -0400
Message-ID: <CAPL5yKdZ4kGGU5KcSAnEN2AbznHNQJvF0TUGoXT-Pn4oA+A1pA@mail.gmail.com>
References: <4E608C29.10307@cn.fujitsu.com>
	<20110902084208.GA28209@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Li Zefan <lizf@cn.fujitsu.com>,
	"linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20110902084208.GA28209@infradead.org>
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Sep 2, 2011 at 4:42 AM, Christoph Hellwig <hch@infradead.org> w=
rote:
> On Fri, Sep 02, 2011 at 03:56:25PM +0800, Li Zefan wrote:
>> There's an off-by-one bug:
>>
>> =A0 # create a file with lots of 4K file extents
>> =A0 # btrfs fi defrag /mnt/file
>> =A0 # sync
>> =A0 # filefrag -v /mnt/file
>> =A0 Filesystem type is: 9123683e
>> =A0 File size of /mnt/file is 1228800 (300 blocks, blocksize 4096)
>> =A0 =A0ext logical physical expected length flags
>> =A0 =A0 =A00 =A0 =A0 =A0 0 =A0 =A0 3372 =A0 =A0 =A0 =A0 =A0 =A0 =A06=
4
>> =A0 =A0 =A01 =A0 =A0 =A064 =A0 =A0 3136 =A0 =A0 3435 =A0 =A0 =A01
>> =A0 =A0 =A02 =A0 =A0 =A065 =A0 =A0 3436 =A0 =A0 3136 =A0 =A0 64
>> =A0 =A0 =A03 =A0 =A0 129 =A0 =A0 3201 =A0 =A0 3499 =A0 =A0 =A01
>> =A0 =A0 =A04 =A0 =A0 130 =A0 =A0 3500 =A0 =A0 3201 =A0 =A0 64
>> =A0 =A0 =A05 =A0 =A0 194 =A0 =A0 3266 =A0 =A0 3563 =A0 =A0 =A01
>> =A0 =A0 =A06 =A0 =A0 195 =A0 =A0 3564 =A0 =A0 3266 =A0 =A0 64
>> =A0 =A0 =A07 =A0 =A0 259 =A0 =A0 3331 =A0 =A0 3627 =A0 =A0 =A01
>> =A0 =A0 =A08 =A0 =A0 260 =A0 =A0 3628 =A0 =A0 3331 =A0 =A0 40 eof
>>
>> After this patch:
>
> Can you please create an xfstests testcase for this?

Did this fix get lost?  I don't see it in git, and defragmenting a
file still results in 10x as many fragments as it started with.
(3.1-rc9)
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
