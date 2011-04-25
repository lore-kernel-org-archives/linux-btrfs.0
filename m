From: Jamie Lokier <jamie@shareable.org>
Subject: Re: [PATCH 1/2] fs: add SEEK_HOLE and SEEK_DATA flags
Date: Mon, 25 Apr 2011 15:15:40 +0100
Message-ID: <20110425141540.GB20461@shareable.org>
References: <1303414954-3315-1-git-send-email-josef@redhat.com> <loom.20110422T001650-760@post.gmane.org> <BANLkTiknb+hzFAjpwESwMcqMVtkFc0HFQQ@mail.gmail.com> <20110422045054.GB17795@infradead.org> <20110422112852.GB1627@x4.trippels.de> <4DB16B72.1050702@redhat.com> <4DB1AC9D.3010706@oracle.com> <20110424174902.GA20461@shareable.org> <4DB56B11.5090505@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Sunil Mushran <sunil.mushran@oracle.com>,
	Markus Trippelsdorf <markus@trippelsdorf.de>,
	Christoph Hellwig <hch@infradead.org>,
	Josef Bacik <josef@toxicpanda.com>,
	linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
To: Eric Blake <eblake@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <4DB56B11.5090505@redhat.com>
List-ID: <linux-btrfs.vger.kernel.org>

Eric Blake wrote:
> On 04/24/2011 11:49 AM, Jamie Lokier wrote:
> >> My problem with FIND_* is that we are messing with the well understood
> >> semantics of lseek().
> > 
> > fcntl() looks a better fit for FIND_HOLE/DATA anyway.
> 
> With fcntl(), it would have to be something like:
> 
> off_t offset = start;
> if (fcntl (fd, F_FIND_HOLE, &offset) != 0)
>     ; // find failed
> // offset is now set to the next location after start

Yes that, or a pointer-to-struct in the style of other fcntl()
operations.

A struct offers more flexibiliy such as a limit on search distance
(may be useful on filesystems where searching reads a lot of metadata
and you don't really want to scan all of a large file), and whether to
include unwritten prealloc space or written-known-zeros space.

I thought of fcntl() because historically it's often how you get quirky
information about files and how to read them, on many OSes.

-- Jamie
