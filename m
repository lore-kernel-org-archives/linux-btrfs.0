From: Alexander Block <ablock84@googlemail.com>
Subject: Re: Details about compression and extents
Date: Thu, 12 Apr 2012 10:31:49 +0200
Message-ID: <CAB9VWqDY-y9C7jV+nR_7q1zsHtjETx6=qjqnvi_tzW9xnCxpbw@mail.gmail.com>
References: <CAB9VWqCV2A9=nbbV59gPb9N_xBF_eivGE1rD7==qx0GSKe02og@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <CAB9VWqCV2A9=nbbV59gPb9N_xBF_eivGE1rD7==qx0GSKe02og@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

One question that I forgot.

5. Does the offset in btrfs_file_extent_item point to the compressed
or uncompressed offset inside the extent? I would expect uncompressed
but I could also imagine that it's compressed in case extents are
compressed block wise.

On Thu, Apr 12, 2012 at 10:27 AM, Alexander Block
<ablock84@googlemail.com> wrote:
> Hello,
>
> I'm currently trying to understand how compression in btrfs works. I
> could not find any detailed description about it. So here are my
> questions.
>
> 1. How is decided what to compress and what not? After a fast test
> with a 2g image file, I've looked into the extents of that file with
> find-new and it turned out that only some of the first extents were
> compressed. The file was simply copied with cp.
> 2. I compared the extents of that mentioned file from a non-compressed
> fs and from a compressed fs and see much more and much smaller extents
> in the compressed fs. Does compression affect extent allocation or is
> this just a coincidence? The source file was in use (VirtualBox was
> running) while I was copying it...if this has too much influence on
> extent allocation then please ignore the whole question.
> 3. How large are the blocks that get compressed? If it's dynamic, how
> is decided which size to use?
> 4. If there is no maximum on compressed extents size, is the whole
> extent compressed at once or in blocks?
>
> More questions may follow...
>
> Alex.
