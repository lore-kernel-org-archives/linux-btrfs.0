Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:38815 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755316AbaEGLal (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 7 May 2014 07:30:41 -0400
Date: Wed, 7 May 2014 04:30:30 -0700
From: Marc MERLIN <marc@merlins.org>
To: Brendan Hide <brendan@swiftspirit.co.za>
Cc: Duncan <1i5t5.duncan@cox.net>, linux-btrfs@vger.kernel.org
Subject: Re: How does "btrfs fi show" show full?
Message-ID: <20140507113030.GU10159@merlins.org>
References: <20140505005412.GS9061@merlins.org>
 <53670F70.1010509@swiftspirit.co.za>
 <20140505055029.GM10159@merlins.org>
 <pan$1f225$3bfd5829$2b5ac65b$4bb85dc6@cox.net>
 <20140507075902.GL10159@merlins.org>
 <536A1097.2020508@swiftspirit.co.za>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <536A1097.2020508@swiftspirit.co.za>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, May 07, 2014 at 12:53:11PM +0200, Brendan Hide wrote:
> On 2014/05/07 09:59 AM, Marc MERLIN wrote:
> >[snip]
> >
> >Did I get this right?
> >I'm not sure I did, since it seems the bigger the -dusage number, the
> >more work balance has to do.
> >
> >If I asked -dsuage=85, it would do all chunks that are more than 15%
> >full?
> 
> -dusage=85 balances all chunks that up to 85% full. The higher the
> number, the more work that needs to be done.

Aah, right. I see why it's more work.
=20 only makes is process the few chunks that are up to 20% full which
won't be many if your FS is almost full.


> Doing a simulation with randomly-semi-filled chunks, "df" at 55%,
> and chunk utilisation at 86%, -dusage=55 balances 30% of the chunks,
> almost perfectly bringing chunk utilisation down to 56%. In my

Oh good, so my guess of using the same number for FS used and dusage=
was good, glad to know it worked well for you too.

> Pathological use-cases still apply however (for example if all
> chunks except one are exactly 54% full). The up-side is that if the
> algorithm is applied regularly (as in scripted and scheduled) then
> the situation will always be that the majority of chunks are going
> to be relatively full, avoiding the pathological use-case.

Sounds good. Also, the filesystem itself should ideally do this in the
background soon. What we're doing here is just a stopgap.

Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/                         | PGP 1024R/763BE901
