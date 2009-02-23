From: Dongjun Shin <djshin90@gmail.com>
Subject: Re: SSDs and filesystem alignment...
Date: Mon, 23 Feb 2009 21:20:16 +0900
Message-ID: <7fe698080902230420m6bbb8635td09e9fc252c320b0@mail.gmail.com>
References: <6278d2220902220631r3d89fbcbgc3eef9570c452df3@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Chris Mason <chris.mason@oracle.com>, linux-btrfs@vger.kernel.org
To: Daniel J Blueman <daniel.blueman@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <6278d2220902220631r3d89fbcbgc3eef9570c452df3@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Feb 22, 2009 at 11:31 PM, Daniel J Blueman
<daniel.blueman@gmail.com> wrote:
> Does BTRFS perform any journal and/or filesystem structure alignment
> (for benefit to SSD longevity and SSD, RAID array and large-sector
> device performance) at present?
>
> ext4's Ted Tso will deliver 128KB alignment with the next release of
> e2fsprogs (ie 1.41.4) [1], so perhaps it's a good idea for btrfsprogs
> also, if not already available?
>
> Daniel
>
> ---
> [1] http://thunk.org/tytso/blog/2009/02/20/aligning-filesystems-to-an-ssds-erase-block-size/
>

I think the partition alignment is more important because it has been
traditionally
hard-coded as 63 sectors. However, the misalignment by filesystem or *fsprogs
are of block-sized granularity (usually 4KB).

Ted mentioned that the Vista changed the default CHS to 240 heads and
62 sectors.
However, AFAIK, what Vista does for that alignment is to change the
relative sectors
of the MBR [1]

-- 
Dongjun

[1] http://www.multibooters.co.uk/partitions.html
