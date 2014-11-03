Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:49771 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751660AbaKCVLU convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 3 Nov 2014 16:11:20 -0500
Content-Type: text/plain; charset=windows-1252
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: Can't mount: open_ctree failed!
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <m38m68$m5j$1@ger.gmane.org>
Date: Mon, 3 Nov 2014 14:11:20 -0700
Cc: linux-btrfs@vger.kernel.org
Message-Id: <26CFDABA-43E0-4A1C-A5A2-0765C8102DA8@colorremedies.com>
References: <m35i04$u5p$1@ger.gmane.org> <55F19B93-4AF2-4A43-82D5-425433DF006B@colorremedies.com> <m38m68$m5j$1@ger.gmane.org>
To: Florian Lindner <mailinglists@xgm.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Nov 3, 2014, at 12:48 PM, Florian Lindner <mailinglists@xgm.de> wrote:
> 
> Ok, problem is that I need to organise another hard disk for that. ;-)
> 
> I tried restore for a test run, it gave a lot of messages about wrong 
> compression length. I found some discussion about that, but I don't know if 
> its indicates an actual error or not? I did use compression on the drive.

This is btrfs-progs 3.17? I know there were compression problems with kernel code but that was fixed in 3.16. I can't tell you why it happens on 3.17 or whether it's a bogus error.

> Is there some guarantee that the data restore restores are correct or is it 
> just a I try what I can do…

No guarantee as far as I know, it's file scraping. There is a recent email from Duncan on this topic about two ways to do restore and he was doing both to make sure he got everything. I vaguely recall things like links aren't restored. Files themselves should be. There's a wiki entry on how to use restore that's worth looking at. In conjunction with btrfs-debug-tree -R you should be able to find a state where you can restore important files.


Chris Murphy