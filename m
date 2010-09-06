From: Chris Samuel <chris@csamuel.org>
Subject: Re: [Btrfs-devel] [patch] O_DIRECT: fix the splitting up of contiguous
 I/O
Date: Mon, 06 Sep 2010 16:29:34 +1000
Message-ID: <4C848A4E.9040103@csamuel.org>
References: <x49vd7f368c.fsf@segfault.boston.devel.redhat.com>	<20100902142501.GA14932@infradead.org>	<201009052256.12386.chris@csamuel.org> <20100905093620.d2eeb539.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs@vger.kernel.org, Christoph Hellwig <hch@infradead.org>,
	Jeff Moyer <jmoyer@redhat.com>,
	btrfs-devel <btrfs-devel@oss.oracle.com>,
	Andrew Morton <akpm@linuxfoundation.org>,
	linux-kernel@vger.kernel.org, Josef Bacik <josef@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20100905093620.d2eeb539.akpm@linux-foundation.org>
List-ID: <linux-btrfs.vger.kernel.org>

On 06/09/10 02:36, Andrew Morton wrote:

> On Sun, 5 Sep 2010 22:56:08 +1000 Chris Samuel <chris@csamuel.org> wrote:
> 
>> > Did this patch get dropped ? 
>
> Nope.  I have it queued for 2.6.36 and -stable, will send it in soon. 
> Everything is a bit lagged at present due to conferences, summer,
> encroaching senility, etc.

Mea culpa - I mixed up the date of the original email with the
date of Christoph's email and so thought he'd sent that back
in August.  Looks like I'm the one with senility issues.. ;-)

cheers,
Chris
-- 
 Chris Samuel  :  http://www.csamuel.org/  :  Melbourne, VIC
