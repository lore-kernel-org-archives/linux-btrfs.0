Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:36893 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755700AbcBVVLn (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 22 Feb 2016 16:11:43 -0500
Date: Mon, 22 Feb 2016 13:11:42 -0800
From: Marc MERLIN <marc@merlins.org>
To: Terrance Harris <tharrisone@polarismail.net>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Fun BTRFS Stuff:
Message-ID: <20160222211142.GD4913@merlins.org>
References: <56CB737D.1020403@polarismail.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <56CB737D.1020403@polarismail.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Feb 22, 2016 at 02:45:49PM -0600, Terrance Harris wrote:
> Hello,
> 
> I'm a btrfs novice, but i've been using it for a few years now on 
> openSUSE Tumblweed.

Howdy.

First, please use the linux-btrfs@vger.kernel.org mailing list

> Is there a way to convert snaBpshots into mountable files using btrfs send?
 
I am not sure I'm parsing your question.
btrfs send/receive copy read only snapshots between 2 btrfs volumes

If you mean using a non differential btrfs send to a file, and then using
that file to act as if it were a filesystem you can read data from, I don't
believe this is easily possible currently (it's possible, just no tool
exists to do that). You're supposed to send it to btrfs receive, have it
saved on a filesystem, and then use that.

> I'm looking make it easy to copy off btrfs files even if my btrfs system 
> is in total fubar mode.

you need to send that btrfs send stream to btrfs receive onto another
filesystem, and use that for restores.

Hope this helps
Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/  
