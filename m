Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wi0-f181.google.com ([209.85.212.181]:33019 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751046AbbFYGaZ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 25 Jun 2015 02:30:25 -0400
Received: by wiwl6 with SMTP id l6so8079940wiw.0
        for <linux-btrfs@vger.kernel.org>; Wed, 24 Jun 2015 23:30:24 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <pan$c46c7$e4c53f76$44d37440$be0c7aec@cox.net>
References: <20150604084245.GR23272@merlins.org> <20150624032008.GF20517@merlins.org>
 <CAA7pwKOA1yyA8kyB+a3iTOp8TnkRzAErF1Mo=2t5M3pFn2tjUw@mail.gmail.com>
 <pan$5335b$94315604$8405c6ac$de90de30@cox.net> <CAA7pwKPQfkns_rO0wWkvJsNM3yxHA7neyCH=_jeEY1nHA4Ysfw@mail.gmail.com>
 <pan$c46c7$e4c53f76$44d37440$be0c7aec@cox.net>
From: Patrik Lundquist <patrik.lundquist@gmail.com>
Date: Thu, 25 Jun 2015 08:30:05 +0200
Message-ID: <CAA7pwKPh9b-dWK7FwsgiA0voWV++Avi=Nj7f82NW4KzDVB8Gkg@mail.gmail.com>
Subject: Re: counting fragments takes more time than defragmenting
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 25 June 2015 at 06:01, Duncan <1i5t5.duncan@cox.net> wrote:
>
> Patrik Lundquist posted on Wed, 24 Jun 2015 14:05:57 +0200 as excerpted:
>
> > On 24 June 2015 at 12:46, Duncan <1i5t5.duncan@cox.net> wrote:
>
> If it's uint32 limited, either kill everything above that in both the
> documentation and code, or alias everything above that to 3G (your next
> paragraph) or whatever.

My simple overflow patch yesterday fixes the problem, so 4G or larger
is max instead of 0.


> >> But btrfs or ext4, 31 extents ideal or a single extent ideal, 150
> >> extents still indicates at least some remaining fragmentation.
> >
> > I gave it another shot but I've now got 154 extents instead. :-)
>
> Is it possible there's simply no gig-size free-space holes in the
> filesystem allocation, so it simply /can't/ defrag further than that,
> because there's no place to allocate whole-gig data chunks at a time?

I would guess so, without allocating new chunks. Defrag can probably
be smarter and avoid rewriting extents if it means splitting them
(unless the compression flag is set and it must rewrite everything).
