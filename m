Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:49605 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751045Ab3JQW5R (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 17 Oct 2013 18:57:17 -0400
Received: from merlin by mail1.merlins.org with local (Exim 4.80 #2)
	id 1VWwVI-00036W-Px
	for <linux-btrfs@vger.kernel.org>; Thu, 17 Oct 2013 15:57:16 -0700
Date: Thu, 17 Oct 2013 15:57:16 -0700
From: Marc MERLIN <marc@merlins.org>
To: linux-btrfs@vger.kernel.org
Subject: Re: btrfs-zero-log (v 0.20-rc1) corrupted double linked list.
Message-ID: <20131017225716.GG5390@merlins.org>
References: <20131017212924.GE5390@merlins.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <20131017212924.GE5390@merlins.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Oct 17, 2013 at 02:29:24PM -0700, Marc MERLIN wrote:
> I asked the debian maintainer to add btrfs-zero-log to the initramfs since I
> unfortunately have to use it from time to time.
> 
> It still fixes the problem for me when btrfs won't mount, but it errors at
> the end.
> 
> See screenshot

I was able to run it through some OCR which will allow this to get indexed.

BusyBox v1.19.3 (Debian 1:1.19.3—5) built-in shell (ash)
Enter 'help' for a list of built—in commands.
/bin/sh: can't access tty; job control turned off

(initramfs) btrfs—zero—log /dev/mapper/cryptroot
Check tree block failed, want=32927752192, have=11251525731377178129
Check tree block failed, want=32927752192, have=11251525731377178129
Check tree block failed. want=32927752192, have=6210801847113163713
Check tree block failed, want=32927752192, have=62108018171§3163713
Check tree block failed, want=32927752192, have=6210801847113163713
read block failed check_tree_block
*** Error in ‘btrfs—zero—log': corrupted double—linked list: 0x008000008171c6b0 ***
 
(numbers are off, see screenshot for real numbers)

Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/  
