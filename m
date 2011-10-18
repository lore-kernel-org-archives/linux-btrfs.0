From: Li Zefan <lizf@cn.fujitsu.com>
Subject: Re: [PATCH 1/4] Btrfs: fix defragmentation regression
Date: Tue, 18 Oct 2011 16:52:57 +0800
Message-ID: <4E9D3E69.6030307@cn.fujitsu.com>
References: <4E608C29.10307@cn.fujitsu.com>	<20110902084208.GA28209@infradead.org> <CAPL5yKdZ4kGGU5KcSAnEN2AbznHNQJvF0TUGoXT-Pn4oA+A1pA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Christoph Hellwig <hch@infradead.org>,
	"linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
To: Dan Merillat <dan.merillat@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <CAPL5yKdZ4kGGU5KcSAnEN2AbznHNQJvF0TUGoXT-Pn4oA+A1pA@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

16:48, Dan Merillat wrote:
> On Fri, Sep 2, 2011 at 4:42 AM, Christoph Hellwig <hch@infradead.org> wrote:
>> On Fri, Sep 02, 2011 at 03:56:25PM +0800, Li Zefan wrote:
>>> There's an off-by-one bug:
>>>
>>>   # create a file with lots of 4K file extents
>>>   # btrfs fi defrag /mnt/file
>>>   # sync
>>>   # filefrag -v /mnt/file
>>>   Filesystem type is: 9123683e
>>>   File size of /mnt/file is 1228800 (300 blocks, blocksize 4096)
>>>    ext logical physical expected length flags
>>>      0       0     3372              64
>>>      1      64     3136     3435      1
>>>      2      65     3436     3136     64
>>>      3     129     3201     3499      1
>>>      4     130     3500     3201     64
>>>      5     194     3266     3563      1
>>>      6     195     3564     3266     64
>>>      7     259     3331     3627      1
>>>      8     260     3628     3331     40 eof
>>>
>>> After this patch:
>>
>> Can you please create an xfstests testcase for this?
> 
> Did this fix get lost?  I don't see it in git, and defragmenting a
> file still results in 10x as many fragments as it started with.
> (3.1-rc9)
> 

No, it's queued for 3.2, but I think it's a good candidate for 3.1.x.
