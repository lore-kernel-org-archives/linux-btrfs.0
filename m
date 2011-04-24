From: Jamie Lokier <jamie@shareable.org>
Subject: Re: [PATCH 1/2] fs: add SEEK_HOLE and SEEK_DATA flags
Date: Sun, 24 Apr 2011 18:49:02 +0100
Message-ID: <20110424174902.GA20461@shareable.org>
References: <1303414954-3315-1-git-send-email-josef@redhat.com> <loom.20110422T001650-760@post.gmane.org> <BANLkTiknb+hzFAjpwESwMcqMVtkFc0HFQQ@mail.gmail.com> <20110422045054.GB17795@infradead.org> <20110422112852.GB1627@x4.trippels.de> <4DB16B72.1050702@redhat.com> <4DB1AC9D.3010706@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Eric Blake <eblake@redhat.com>,
	Markus Trippelsdorf <markus@trippelsdorf.de>,
	Christoph Hellwig <hch@infradead.org>,
	Josef Bacik <josef@toxicpanda.com>,
	linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
To: Sunil Mushran <sunil.mushran@oracle.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <4DB1AC9D.3010706@oracle.com>
List-ID: <linux-btrfs.vger.kernel.org>

Sunil Mushran wrote:
> On 04/22/2011 04:50 AM, Eric Blake wrote:
> >That blog also mentioned the useful idea of adding FIND_HOLE and
> >FIND_DATA, not implemented in Solaris, but which could easily be
> >provided as additional lseek constants in Linux to locate the start of
> >the next chunk without repositioning and which could ease application
> >programmer's life a bit.  After all, cp wants to know where data ends
> >without repositioning (FIND_HOLE), read() that much data which
> >repositions in the process, then skip to the next chunk of data
> >(SEEK_DATA) - two lseek() calls per iteration if we have 4 constants,
> >but 3 per iteration if we only have SEEK_HOLE and have to manually rewind.
> 
> while(1) {
>     read(block);
>     if (block_all_zeroes)
>         lseek(SEEK_DATA);
> }
> 
> What's wrong with the above? If this is the case, even SEEK_HOLE
> is not needed but should be added as it is already in Solaris.

Apart from the obvious waste of effort (scanning *all* data for zeros
is cheap but not free if the file is mostly non-hole zeros), you can't
do a pread() version of the above in parallel over different parts of
the same file/device.

> My problem with FIND_* is that we are messing with the well understood
> semantics of lseek().

fcntl() looks a better fit for FIND_HOLE/DATA anyway.

-- Jamie
