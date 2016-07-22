Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from tartarus.angband.pl ([89.206.35.136]:55071 "EHLO
	tartarus.angband.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751951AbcGVAxd (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 21 Jul 2016 20:53:33 -0400
Date: Fri, 22 Jul 2016 02:53:18 +0200
From: Adam Borowski <kilobyte@angband.pl>
To: Gabriel C <nix.or.die@gmail.com>
Cc: Chris Mason <clm@fb.com>, Chandan Rajendra <chandan@linux.vnet.ibm.com>,
        linux-btrfs@vger.kernel.org, quwenruo@cn.fujitsu.com
Subject: Re: A lot warnings in dmesg while running thunderbird
Message-ID: <20160722005318.GA12929@angband.pl>
References: <CAEJqkghMZDOJoyRkf_-HTfuKLnj0eaAGmtjVAPY2UftV7TxbvA@mail.gmail.com>
 <47ff1ea1-d4a9-55d9-f65d-60e94be93146@gmail.com>
 <73545420-2ce5-c4d3-d59a-98d2114bafd2@fb.com>
 <35812568.Zn4Yz0rfXf@localhost.localdomain>
 <20160719110534.GA96833@clm-mbp.thefacebook.com>
 <5d481869-b442-121c-8741-d5ff11e48de4@gmail.com>
 <5f1dc52b-11cb-8977-3410-e71e0b2d0c00@fb.com>
 <2ce1eb99-2e9f-f9cb-7601-6e67301979cd@gmail.com>
 <7de268a1-c7d2-b819-d15c-c26416996c94@fb.com>
 <2cf60d0b-1d80-ae27-4d37-fa07681afb77@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <2cf60d0b-1d80-ae27-4d37-fa07681afb77@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jul 21, 2016 at 11:25:02PM +0200, Gabriel C wrote:
> On 21.07.2016 14:56, Chris Mason wrote:
> > On 07/20/2016 01:50 PM, Gabriel C wrote:
> >> After 24h of running the program and thundirbird all is still fine here.
> >>
> >> I let it run one more day.. But looks very good.
> >>
> > 
> > Thanks for your time in helping to track this down.  It'll go into the 
> > next merge window and be cc'd to stable.
> > 
> 
> You are welcome :)
> 
> Test program was running without problems for 52h.. I think your fix is fine :)

AOL.
I haven't tested it for as long, but had it running concurrently with some
big compiles (kernel, sbuild ie snapshot+dpkg+subv delete), cleanup of
several tens of daily snapshots, etc.

No problems.

-- 
An imaginary friend squared is a real enemy.
