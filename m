From: Martin <m_btrfs@ml1.co.uk>
Subject: Re: btrfs support for efficient SSD operation (data blocks alignment)
Date: Fri, 10 Feb 2012 01:05:27 +0000
Message-ID: <jh1qgo$8ot$1@dough.gmane.org>
References: <jgui4j$th5$1@dough.gmane.org> <4F33247D.2060305@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4F33247D.2060305@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

On 09/02/12 01:42, Liu Bo wrote:
> On 02/09/2012 03:24 AM, Martin wrote:

[ No problem for 4kByte sector HDDs. However, for SSDs... ]

>> However for SSDs...
>>
>> I'm using for example a 60GByte SSD that has:
>>
>>     8kB page size;
>>     16kB logical to physical mapping chunk size;
>>     2MB erase block size;
>>     64MB cache.
>>
>> And the sector size reported to Linux 3.0 is the default 512 bytes!
[...]
>> Is there any control possible over the btrfs filesystem structure to map
>> metadata and data structures to the underlying device boundaries?
>>
>> For example to maximise performance, can the data chunks and the data
>> chunk size be aligned to be sympathetic to the SSD logical mapping chunk
>> size and the erase block size?
>>
> 
> The metadata buffer size will support size larger than 4K at least, it is on development.

And also for the data? Also pack smaller data chunks in with the
metadata as is done already but with all the present parameters
proportioned according to the "sector size"?

(For my example, the filesystem may as well use 16kByte sectors because
the SSD firmware will do a read-modify-write for anything smaller.)


>> What features other than the trim function does btrfs employ to optimise
>> for SSD operation?
>>
> 
> e.g COW(avoid writing to one place multi-times),
> delayed allocation(intend to reduce the write frequency)

I'm using ext4 on a SSD web server and have formatted with (for ext4):

mke2fs -v -T ext4 -L fs_label_name -b 4096 -E
stride=4,stripe-width=4,lazy_itable_init=0 -O
none,dir_index,extent,filetype,flex_bg,has_journal,sparse_super,uninit_bg /dev/sdX

and mounted with the mount options:
journal_checksum,barrier,stripe=4,delalloc,commit=300,max_batch_time=15000,min_batch_time=200,discard,noatime,nouser_xattr,noacl,errors=remount-ro

The main bits for the SSD are the:
"stripe=4,delalloc,commit=300,max_batch_time=15000,min_batch_time=200,discard,noatime"

The "-b 4096" is the maximum value allowed. The stride and stripe-width
then take that up to 16kBytes (hopefully...).

(Make sure you're on a good UPS with a reliable shutdown mechanism for
power fail!)


A further thought is:

For my one SSD example, the erase state appears to be all "0xFF"... Can
the fs easily check the erase state value and leave any blank space
unchanged to minimise the bit flipping?

Reasonable to be included?


All unnecessary for HDDs but possibly of use for maintaining the
lifespan of SSDs...

Hope of interest,

Regards,
Martin


