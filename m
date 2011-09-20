From: David Sterba <dave@jikos.cz>
Subject: Re: Inefficient storing of ISO images with compress=lzo
Date: Tue, 20 Sep 2011 16:29:38 +0200
Message-ID: <20110920142937.GM22205@twin.jikos.cz>
References: <1316388769.2499.4.camel@picard> <4E76AEB9.4080109@cn.fujitsu.com>
Reply-To: dave@jikos.cz
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: uzytkownik2@gmail.com, linux-btrfs@vger.kernel.org
To: Li Zefan <lizf@cn.fujitsu.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4E76AEB9.4080109@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Sep 19, 2011 at 10:53:45AM +0800, Li Zefan wrote:
> With compress option specified, btrfs will try to compress the file, at most
> 128K at one time, and if the compressed result is not smaller, the file will
> be marked as uncompressable.
> 
> I just tried with Fedora-14-i386-DVD.iso, and the first 896K is compressed,
> with a compress ratio about 71.7%, and the remaining data is not compressed.

I'm curious how did you obtain that number and if it's a rough estimate
(ie. some rounding up to 4k or such), or the % comes from exact numbers.

AFAIK there are two possibilities to read compressed sizes:

rough:
* traverse extents, look for compressed extens and sum up
  extent_map->block_len, or just extent_map->len for uncompressed

* block_len is rounded up to 4k
* compressed inline size is not stored in any structur member, at most 4k


exact:
as you know, the only place where exact size of compressed data is
stored are first 4 bytes of every compressed extent, counting exact size
of compressed extent means to read those bytes, naturally.


Touching non-metadata just to read compressed size does not look nice. I
did some research in that area and my conclusion is that it there's a
missing structure member "compressed_length" in extent_map (in-memory
structure, no problem to add it there) which is filled from
strcut btrfs_file_extent_item (on-disk structure, eg. holding
compression type) -- disk format change :( Other members could not be
used to calculate the compressed size, being either estimates by
definition (ram_size) or contain size depending on other data
(disk_num_bytes, depend on checksum size).

Although there are 2 bytes spare for other compression types, there are
none to hold the actual compression or encryption or whateverencoding
length.

So until there's going to be format change, there are the two ways,
rough or slow, to read compressed size.  (Unless I've missed something
obvious etc.)

Looking forward to your input or patches :)


Thanks,
david
