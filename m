Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:58096 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751315AbbHYO7o (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 25 Aug 2015 10:59:44 -0400
Date: Tue, 25 Aug 2015 07:59:22 -0700
From: Marc MERLIN <marc@merlins.org>
To: Miguel =?iso-8859-1?Q?Negr=E3o?=
	<miguel.negrao-lists@friendlyvirus.org>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Btrfs tragedy: lack of space for metadata leads to loss of fs.
Message-ID: <20150825145922.GE20179@merlins.org>
References: <loom.20150825T151154-787@post.gmane.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <loom.20150825T151154-787@post.gmane.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Aug 25, 2015 at 01:44:12PM +0000, Miguel Negrão wrote:
> Hi list,
> 
> This weekend had my first btrfs horror story. 
> 
> system: 3.13.0-49-lowlatency, btrfs-progs v4.1.2
 
Sorry to say, but that's a very old kernels with many btrfs bugs, some
did lead to corruption.

> A disclaimer: I know 3.13 is very out of date, but I the requirement of
> keeping kernel up to date clashes with my requirement of keeping a stable
> system. At the moment I can't disturb my system as I'm doing important work,

Unfortunately you have conflicting goals.

> upgrading kernel requires upgrading ubuntu, which will upgrade a lot of
> packages and might lead to problems which I don't have time to fix. One

You're doing it wrong :)
Upgrade/compile your own kernel without upgrading the OS.

> block group 32...... flags 36'). This is a OCZ vertex 3, a quite fast SSD.

I've had 5 (yes 5, I replaced my drive 4 times) OCZ Vertex 4 drives, and
they all gave me corruption with btrfs on unclean power down. The last
one didn't work any better, I just gave up and went to Samsung EVO 840
and those have been fine.

Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/                         | PGP 1024R/763BE901
