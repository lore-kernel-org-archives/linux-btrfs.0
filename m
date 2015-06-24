Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wi0-f172.google.com ([209.85.212.172]:35230 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751203AbbFXMGS (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 24 Jun 2015 08:06:18 -0400
Received: by wiga1 with SMTP id a1so133594357wig.0
        for <linux-btrfs@vger.kernel.org>; Wed, 24 Jun 2015 05:06:16 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <pan$5335b$94315604$8405c6ac$de90de30@cox.net>
References: <20150604084245.GR23272@merlins.org> <20150624032008.GF20517@merlins.org>
 <CAA7pwKOA1yyA8kyB+a3iTOp8TnkRzAErF1Mo=2t5M3pFn2tjUw@mail.gmail.com> <pan$5335b$94315604$8405c6ac$de90de30@cox.net>
From: Patrik Lundquist <patrik.lundquist@gmail.com>
Date: Wed, 24 Jun 2015 14:05:57 +0200
Message-ID: <CAA7pwKPQfkns_rO0wWkvJsNM3yxHA7neyCH=_jeEY1nHA4Ysfw@mail.gmail.com>
Subject: Re: counting fragments takes more time than defragmenting
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 24 June 2015 at 12:46, Duncan <1i5t5.duncan@cox.net> wrote:
> Patrik Lundquist posted on Wed, 24 Jun 2015 10:28:09 +0200 as excerpted:
>
> AFAIK, it's set huge to defrag everything,

It's set to 256K by default.


> Assuming "set a huge -t to defrag to the maximum extent possible" is
> correct, that means -t 1G should be exactly as effective as -t 1T...

1G is actually more effective because 1T overflows the uint32
extent_thresh field, so 1T, 0, and 256K are currently the same.

3G is the largest value that works with -t as expected (disregarding
the man page) and is easy to type.


> But btrfs or ext4, 31 extents ideal or a single extent ideal, 150 extents
> still indicates at least some remaining fragmentation.

I gave it another shot but I've now got 154 extents instead. :-)
