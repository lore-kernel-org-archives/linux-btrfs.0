Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:47620 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752178AbbGLDaV (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 11 Jul 2015 23:30:21 -0400
Date: Sat, 11 Jul 2015 18:02:29 -0700
From: Marc MERLIN <marc@merlins.org>
To: dsterba@suse.com, linux-btrfs@vger.kernel.org, clm@fb.com
Subject: Re: Btrfs progs release 4.1.1
Message-ID: <20150712010229.GA5284@merlins.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20150706212156.GY17274@merlins.org>
 <20150710134348.GB15535@suse.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jul 10, 2015 at 03:43:48PM +0200, David Sterba wrote:
> Hi,
> 
> btrfs-progs 4.1.1 have been released, a few bugfixes and enhancements.
> 
> * bugfixes
>   - defrag: threshold overflow fix
>   - fsck:
>     - check if items fit into the leaf space
>     - fix wrong nbytes

Are you interested in crash reports for fsck?

If so, see my recent message:

On Mon, Jul 06, 2015 at 02:21:56PM -0700, Marc MERLIN wrote:
> 
> myth:~# btrfs check --repair /dev/mapper/crypt_sdd1 
> enabling repair mode
> Checking filesystem on /dev/mapper/crypt_sdd1
> UUID: 024ba4d0-dacb-438d-9f1b-eeb34083fe49
> checking extents
> cmds-check.c:4486: add_data_backref: Assertion `back->bytes != max_size` failed.
> btrfs[0x8066a73]
> btrfs[0x8066aa4]
> btrfs[0x8067991]
> btrfs[0x806b4ab]
> btrfs[0x806b9a3]
> btrfs[0x806c5b2]
> btrfs(cmd_check+0x1088)[0x806eddf]
> btrfs(main+0x153)[0x80557c6]
> /lib/i386-linux-gnu/libc.so.6(__libc_start_main+0xf3)[0xb75064d3]
> btrfs[0x80557ec]
> 
> myth:~# btrfs --version
> btrfs-progs v4.0
> 
> Is anyone interested in getting data off this filesystem or having me
> try newer code/a patch?
> 
> filesystem is 10TB-ish, so sending an image isn't going to be easy though.
> 
> I can mount with -o ro without it crashing, but if I drop ro, it then
> tries to do something and crashes, and unfortunately the error doesn't
> make it to syslog
> 
> Screenshot: http://marc.merlins.org/tmp/btrfs_crash.jpg
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/                         | PGP 1024R/763BE901
