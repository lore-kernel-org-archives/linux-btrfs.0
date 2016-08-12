Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp.sws.net.au ([203.15.120.15]:41780 "EHLO smtp.sws.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751268AbcHLDKe (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 11 Aug 2016 23:10:34 -0400
In-Reply-To: <alpine.DEB.2.20.14.1608091420150.8131@trent.utfs.org>
References: <CAMG9ccwK93opLn=qOcceDjExwDHHRaxO=juvcXz4TuWKt_qXeg@mail.gmail.com> <alpine.DEB.2.20.14.1608091420150.8131@trent.utfs.org>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Subject: Re: Strange behavior after "rm -rf //"
From: Russell Coker <russell@coker.com.au>
Date: Fri, 12 Aug 2016 13:08:58 +1000
To: Christian Kujau <lists@nerdbynature.de>, Ivan Sizov <sivan606@gmail.com>
CC: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Message-ID: <A0E51DF2-D230-4847-A541-581A8A9C36DB@coker.com.au>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

http://selinux.coker.com.au/play.html

There are a variety of ways of giving the same result that rm doesn't reject. "/*" Wasn't caught last time I checked. See the above URL if you want to test out various rm operations as root. ;)

On 10 August 2016 9:24:23 AM AEST, Christian Kujau <lists@nerdbynature.de> wrote:
>On Mon, 8 Aug 2016, Ivan Sizov wrote:
>> I'd ran "rm -rf //" by mistake two days ago. I'd stopped it after
>five
>
>Out of curiosity, what version of coreutils is this? The
>--preserve-root 
>option is the default for quite some time now:
>
>> Don't include dirname.h, since system.h does it now.
>> (usage, main): --preserve-root is now the default.
>> 2006-09-03 02:53:58 +0000
>http://git.savannah.gnu.org/cgit/coreutils.git/commit/src/rm.c?id=89ffaa19909d31dffbcf12fb4498afb72666f6c9
>
>Even coreutils-6.10 from Debian/5 refuses to remove "/":
>
>$ sudo rm -rf /
>rm: cannot remove root directory `/'
>
>Christian.

-- 
Sent from my Nexus 6P with K-9 Mail.
