From: Nick Bowler <nbowler@elliptictech.com>
Subject: Re: [PATCH 1/2] fs: add SEEK_HOLE and SEEK_DATA flags
Date: Mon, 25 Apr 2011 11:02:27 -0400
Message-ID: <20110425150227.GA10653@elliptictech.com>
References: <1303414954-3315-1-git-send-email-josef@redhat.com>
 <loom.20110422T001650-760@post.gmane.org>
 <BANLkTiknb+hzFAjpwESwMcqMVtkFc0HFQQ@mail.gmail.com>
 <20110422045054.GB17795@infradead.org>
 <20110422112852.GB1627@x4.trippels.de>
 <4DB17D5B.2090303@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Markus Trippelsdorf <markus@trippelsdorf.de>,
	Christoph Hellwig <hch@infradead.org>,
	Josef Bacik <josef@toxicpanda.com>,
	linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, Coreutils <coreutils@gnu.org>
To: Eric Blake <eblake@redhat.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <4DB17D5B.2090303@redhat.com>
List-ID: <linux-btrfs.vger.kernel.org>

Hi Eric,

On 2011-04-22 07:06 -0600, Eric Blake wrote:
> I've created a request to standardize SEEK_HOLE and SEEK_DATA in the
> next revision of POSIX; comments are welcome to make sure that everyone
> is happy with wording:
> http://austingroupbugs.net/view.php?id=415

Reading through your proposal, I think there is one thing that could be
clarified: the meaning of "the last hole" in the file.  Consider the
following two file layouts -- in the "diagrams", a bar (|) indicates a
boundary between holes and non-hole data, and a double bar (||)
indicates end-of-file.

* File A (sparse file created by lseek/write beyond end-of-file):

    data | hole 0 | data || hole 1 (virtual)

* File B (sparse file created by truncate beyond end-of-file):

    data | hole 0 || hole 1 (virtual)

Excluding the error description, the term "the last hole" is used in
two places in your proposal:

  * (for SEEK_HOLE): if offset falls within "the last hole", then the
    file offset may be set to the file size instead.

  * (for SEEK_DATA): it shall be an error ... if offset falls within the
    last hole.

I imagine that both of these conditions are intended to address the
case where the offset falls within hole 0 in File B, that is, when
there is no non-hole data beyond the specified offset but the offset
is nevertheless less than the file size.  However, this looks (to me)
like the penultimate hole in the file, not the last hole.  Furthermore,
these conditions are presumably *not* intended to apply to the
penultimate hole in File A, which has data after it.

I think my confusion can be avoided by talking about the last non-hole
data byte in the file (which is unambigious), instead of by talking
about the last hole.  For instance, the SEEK_HOLE/SEEK_DATA descriptions
could be written as follows:

  If whence is SEEK_HOLE, the file offset shall be set to the smallest
  location of a byte within a hole and not less than offset, except that
  if offset falls beyond the last byte not within a hole, then the file
  offset may be set to the file size instead.  It shall be an error if
  offset is greater or equal to the size of the file.

  If whence is SEEK_DATA, the file offset shall be set to the smallest
  location of a byte not within a hole and not less than offset.  It shall
  be an error if no such byte exists.

plus a corresponding update to the ENXIO description:

  ... or the whence argument is SEEK_DATA and the offset falls beyond
  the last byte not within a hole.

-- 
Nick Bowler, Elliptic Technologies (http://www.elliptictech.com/)
