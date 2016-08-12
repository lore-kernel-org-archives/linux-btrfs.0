Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from trent.utfs.org ([94.185.90.103]:40110 "EHLO trent.utfs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751356AbcHLGQE (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 12 Aug 2016 02:16:04 -0400
Date: Thu, 11 Aug 2016 23:15:49 -0700 (PDT)
From: Christian Kujau <lists@nerdbynature.de>
To: Russell Coker <russell@coker.com.au>
cc: Ivan Sizov <sivan606@gmail.com>, Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: Strange behavior after "rm -rf //"
In-Reply-To: <A0E51DF2-D230-4847-A541-581A8A9C36DB@coker.com.au>
Message-ID: <alpine.DEB.2.20.14.1608112315440.8131@trent.utfs.org>
References: <CAMG9ccwK93opLn=qOcceDjExwDHHRaxO=juvcXz4TuWKt_qXeg@mail.gmail.com> <alpine.DEB.2.20.14.1608091420150.8131@trent.utfs.org> <A0E51DF2-D230-4847-A541-581A8A9C36DB@coker.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, 12 Aug 2016, Russell Coker wrote:
> There are a variety of ways of giving the same result that rm
> doesn't reject. "/*" Wasn't caught last time I checked. See the above 
> URL if you want to test out various rm operations as root. ;)

Oh, yes - "rm -r /*" would work, even with a current coreutils version. 
But since the OP stated "rm -rf //" I was curious about the userspace
part on that.

Thanks for the link to the SELinux playground, nice setup!

Christian.
-- 
BOFH excuse #346:

Your/our computer(s) had suffered a memory leak, and we are waiting for them to be topped up.
