From: David Woodhouse <dwmw2@infradead.org>
Subject: Re: raild[56] again
Date: Tue, 04 May 2010 16:09:09 +0100
Message-ID: <1272985749.31892.5621.camel@macbook.infradead.org>
References: <14154949.31.1272916930325.JavaMail.root@zimbra>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
To: Roy Sigurd Karlsbakk <roy@karlsbakk.net>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <14154949.31.1272916930325.JavaMail.root@zimbra>
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, 2010-05-03 at 22:02 +0200, Roy Sigurd Karlsbakk wrote:
> Is raid[56] coming to btrfs? There was some talk about it a year back
> or so, but I haven't seen anything yet....

Um, there was some talk about it about four days ago. You even
participated in that thread!

As it stands, it has the traditional 'write hole' problem -- when you
overwrite _part_ of a stripe, you have to update the parity block(s) too
and you have a short period of time where the parity doesn't match the
actual data. If you get a crash followed by a disk failure during that
period of time, you get data loss.

The solution is always to write a full stripe (across all the disks in
the set). Chris said he'd sort that out in the upper layers of btrfs,
about which I know little. We've been waiting a while for that.

I poked him recently and we realised that I hadn't actually made my part
_cope_ with being given a full stripe at a time, which was a bit of an
oversight. I had done it once as a test, but had never actually
committed and pushed that support. The patch I posted last week attempts
to fix that. There are one or two details I wanted some feedback on but
in the absence of that, I think I'll just tidy it up and push it using
the existing approach.

-- 
dwmw2

