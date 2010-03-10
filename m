From: Mike Fedyk <mfedyk@mikefedyk.com>
Subject: Re: SSD Optimizations
Date: Wed, 10 Mar 2010 15:12:42 -0800
Message-ID: <93cdabd21003101512n6d773084hcf5e4a85aa180480@mail.gmail.com>
References: <4B97F7CE.4030405@bobich.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-btrfs@vger.kernel.org
To: Gordan Bobic <gordan@bobich.net>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4B97F7CE.4030405@bobich.net>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Mar 10, 2010 at 11:49 AM, Gordan Bobic <gordan@bobich.net> wrote:
> I'm looking to try BTRFS on a SSD, and I would like to know what SSD
> optimizations it applies. Is there a comprehensive list of what ssd mount
> option does? How are the blocks and metadata arranged? Are there options
> available comparable to ext2/ext3 to help reduce wear and improve
> performance?
>
> Specifically, on ext2 (journal means more writes, so I don't use ext3 on
> SSDs, since fsck typically only takes a few seconds when access time is <
> 100us), I usually apply the
> -b 4096 -E stripe-width = (erase_block/4096)
> parameters to mkfs in order to reduce the multiple erase cycles on the same
> underlying block.
>
> Are there similar optimizations available in BTRFS?

I think you'll get more out of btrfs, but another thing you can look
into is ext4 without the journal.  Support was added for that recently
(thanks to google).
