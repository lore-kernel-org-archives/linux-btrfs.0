Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from 220-245-31-42.static.tpgi.com.au ([220.245.31.42]:43666 "EHLO
	smtp.sws.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751051AbbJBEVP (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 2 Oct 2015 00:21:15 -0400
From: Russell Coker <russell@coker.com.au>
To: Austin S Hemmelgarn <ahferroin7@gmail.com>
Subject: Re: BTRFS as image store for KVM?
Date: Fri, 2 Oct 2015 14:21:09 +1000
Cc: Timofey Titovets <nefelim4ag@gmail.com>, Jim Salter <jim@jrs-s.net>,
        Rich Freeman <r-btrfs@thefreemanclan.net>, Gert Menke <gert@menke.ac>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
References: <55F88ECC.1040604@menke.ac> <CAGqmi75-Wc-YOwCJhRD1ahgKhEM5tPPBVjCYmvgjMZNhEnk77w@mail.gmail.com> <56055839.9000904@gmail.com>
In-Reply-To: <56055839.9000904@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201510021421.09558.russell@coker.com.au>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, 26 Sep 2015 12:20:41 AM Austin S Hemmelgarn wrote:
> > FYI:
> > Linux pagecache use LRU cache algo, and in general case it's working good
> > enough
> 
> I'd argue that 'general usage' should be better defined in this 
> statement.  Obviously, ZFS's ARC implementation provides better 
> performance in a significant number of common use cases for Linux, 
> otherwise people wouldn't be using it to the degree they are.

No-one gets a free choice about this.  I have a number of servers running ZFS 
because I needed the data consistency features and BTRFS wasn't ready.  There 
is no choice of LRU vs ARC once you've made the BTRFS vs ZFS decision.

ARC presumably worked better than the other Solaris caching options.  It was 
ported to Linux with zfsonlinux because that was the easy way of doing it.

Some people here have reported that ARC worked well for them on Linux.  My 
experience was that the zfsonlinux kernel modules wouldn't respect the module 
load options to reduce the size of the ARC and the default size would cause 
smaller servers to have kernel panics due to lack of RAM.  My solution to that 
problem was to get more RAM for all ZFS servers as buying RAM is cheaper for 
my clients than paying me to diagnose the problems with ZFS.

-- 
My Main Blog         http://etbe.coker.com.au/
My Documents Blog    http://doc.coker.com.au/
