Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:48432 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756392AbbIUOgi (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 21 Sep 2015 10:36:38 -0400
Date: Mon, 21 Sep 2015 07:36:15 -0700
From: Marc MERLIN <marc@merlins.org>
To: Incorporeal Waffle <0isavalidnumber@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Btrfs partition gets remounted as read only
Message-ID: <20150921143615.GL28677@merlins.org>
References: <CAOTVeoEVxAMHJ8Rw-YfAUmuvNUs3pAcEGgA7bXgOC1fToW9HYQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAOTVeoEVxAMHJ8Rw-YfAUmuvNUs3pAcEGgA7bXgOC1fToW9HYQ@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Sep 21, 2015 at 02:30:21PM +0000, Incorporeal Waffle wrote:
> I tried converting my root partition (originally ext4) to btrfs.
> 
> When I booted, I discovered that my root partition is getting
> remounted as read only.

I'm afraid, last I heard, the ext4 convertion stuff was broken, and had been
for a quite a while.
https://btrfs.wiki.kernel.org/index.php/Conversion_from_Ext3

The comment says 4.0, but I've had it fail with older versions of the
kernel.

Try the rollback explained in the wiki
btrfs-convert -r /dev/xxx

If that fails (hopefully not), you'll have to go back to backups.

Sorry,
Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/  
