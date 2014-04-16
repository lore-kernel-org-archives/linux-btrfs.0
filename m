Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:43278 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756400AbaDPQTv convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 16 Apr 2014 12:19:51 -0400
Content-Type: text/plain; charset=US-ASCII
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: Lost /home subvolume after btrfs crash
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <534E8B6A.9060209@arcor.de>
Date: Wed, 16 Apr 2014 10:19:51 -0600
Message-Id: <7C3AD7C7-44A4-45F3-9634-3E92618DCD15@colorremedies.com>
References: <534E8B6A.9060209@arcor.de>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>, Martin Wilck <mwilck@arcor.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Apr 16, 2014, at 7:53 AM, Martin Wilck <mwilck@arcor.de> wrote:
> 
> The crash happened with a rather old OpenSUSE 12.2 kernel (3.4.11-2.16).
> The user says she was just surfing the web normally when the crash
> occured (no screenshot of the original crash, unfortunately). On the
> next boot,  the btrfs root file system couldn't be mounted any more.
> After that I booted an OpenSUSE 12.3 rescue DVD and created the debug
> material shown above.

OpenSUSE 12.3 is using kernel 3.7 which is also old for this sort of recovery attempt. Even openSUSE 13.1 is at 3.11.6 which might work in a bind, but if it doesn't, inevitably someone will suggest you use something even newer. 

Current stable is 3.14.1, I suggest giving 3.13 or 3.14 a shot at this with -o ro,recovery as a first step and see if it at least mounts.

And an old kernel implies old btrfs-progs too, which is where the code for btrfsck and btrfs restore is contained. So that needs to be at least v 3.12. And hopefully you didn't use --repair with btrfsck yet.


Chris Murphy