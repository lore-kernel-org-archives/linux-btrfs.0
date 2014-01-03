Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:53639 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753187AbaACTxl (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 3 Jan 2014 14:53:41 -0500
Date: Fri, 3 Jan 2014 04:33:11 -0800
From: Marc MERLIN <marc@merlins.org>
To: Chris Murphy <lists@colorremedies.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>,
        Oliver Mangold <o.mangold@gmail.com>
Subject: Re: coredump in btrfsck
Message-ID: <20140103123311.GH10886@merlins.org>
References: <52C4884F.6040000@gmail.com>
 <45E0985F-4F75-47D1-BD6E-2286D5844AE3@colorremedies.com>
 <52C4982C.1040606@gmail.com>
 <4656C292-30C5-4D72-AB46-654EC7C4FBD3@colorremedies.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <4656C292-30C5-4D72-AB46-654EC7C4FBD3@colorremedies.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jan 02, 2014 at 10:37:28AM -0700, Chris Murphy wrote:
> 
> On Jan 1, 2014, at 3:35 PM, Oliver Mangold <o.mangold@gmail.com> wrote:
> 
> > On 01.01.2014 22:58, Chris Murphy wrote:
> >> On Jan 1, 2014, at 2:27 PM, Oliver Mangold <o.mangold@gmail.com> wrote:
> >> 
> >>> I fear, I broke my FS by running btrfsck. I tried 'btrfsck --repair' and it fixed several problems but finally crashed with some debug message from 'extent-tree.c', so I also tried 'btrfsck --repair --init-extent-tree'.
> >> It is sort of a (near) last restort, you know this right? What did you try before btrfsck? Did you set dmesg -n7, then mount -o recovery and if so what was recorded in dmesg?
> > Ehm, actually, no.
> 
> https://btrfs.wiki.kernel.org/index.php/FAQ#When_will_Btrfs_have_a_fsck_like_tool.3F
> 
> This is a bit dated, but the general idea is to not use repair except on advice of a developer, and also there are still some risks. Just a week or so ago, one said it was a little dangerous still. So yeah, -o recovery should be the first choice.
 
I was thinking about this:
Considering that everyone out there has been conditioned/used to running
fsck on any filesystem if thre is a problem, and considering btrfs has
been different and likely will be for the forseable future, I'd like to
suggest the following:

In order to accomodate more users trying btrfs, the documentation for
btrfsck really needs to be changed. Neither the tool help nor the man
page say anything about 'this is not the fsck you're looking for', nor
point to the wiki above.

See:
gandalfthegreat:~# btrfsck 
usage: btrfs check [options] <device>

    Check an unmounted btrfs filesystem.
(...)
and
man btrfsck

Would it be possible for whoever maintains btrfs-tools to change both
the man page and the help included in the tool to clearly state that
running the fsck tool is unlikely to be the right course of action
and talk about btrfs-zero-log as well as mount -o recovery?

Cheers,
Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/                         | PGP 1024R/763BE901
