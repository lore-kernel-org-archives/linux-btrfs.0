Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:27003 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758141AbcCVCPj (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 21 Mar 2016 22:15:39 -0400
Date: Mon, 21 Mar 2016 22:15:33 -0400
From: Chris Mason <clm@fb.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: LKML <linux-kernel@vger.kernel.org>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [GIT PULL] Btrfs
Message-ID: <20160322021533.xqalzzk5itglqu3x@floor.thefacebook.com>
References: <20160322002436.angclbg3eg6c65ik@floor.thefacebook.com>
 <CA+55aFzkbk=EVjqp6cx+OQXPadFGfFvaHHV59+CZFStFB8gGvQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <CA+55aFzkbk=EVjqp6cx+OQXPadFGfFvaHHV59+CZFStFB8gGvQ@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Mar 21, 2016 at 06:16:54PM -0700, Linus Torvalds wrote:
> On Mon, Mar 21, 2016 at 5:24 PM, Chris Mason <clm@fb.com> wrote:
> >
> > I waited an extra day to send this one out because I hit a crash late
> > last week with CONFIG_DEBUG_PAGEALLOC enabled (fixed in the top commit).
> 
> Hmm. If that commit helps, it will spit out a warning.
> 
> So is it actually fixed, or just hacked around to the point where you
> don't get a page fault?
> 
> That WARN_ON_ONCE kind of implies it's a "this happens, but we don't know why".

Hi Linus,

	while (bio_index < bio->bi_vcnt) {
		count = find some crcs
		...
		while (count--) {
			...
			page_bytes_left -= root->sectorsize;
			if (!page_bytes_left) {
				bio_index++;
				/*
				 * make sure we're still inside the
				 * bio before we update page_bytes_left
				 */
				if (bio_index >= bio->bi_vcnt) {
					WARN_ON_ONCE(count);
					goto done;
				}
				bvec++;
				page_bytes_left = bvec->bv_len;
				^^^^^ this was the line that crashed
				      before
			}

		}
	}

done:
	cleanup;
	return;

What should be happening here is we'll goto done when count is zero and
we've walked past the end of the bio.  IOW, both the outer and inner
loops are doing the right tests and the right math, but the inner loop
is improperly accessing a bogus bvec->bv_len because it didn't realize
the outer loop was now completely done.

I don't see a way for it to happen when count != 0, and I ran xfstests
on a few machines to try and triple check that.  If there are new bugs
hiding here, we'll have EIOs returned up to userland because this
function didn't properly fetch the crcs.  If anyone reported the EIOs,
they would send in the WARN_ON output too, so we'd know right away not
to blame their hardware.

I also ran for days with heavy read/write loads without seeing the crc
errors.  I didn't have the WARN_ON, or CONFIG_DEBUG_PAGEALLOC on that
box, but if other things were wrong, we'd have done a lot worse than poke
into bvec->bv_len, and the crc errors would have stopped the test.

-chris

