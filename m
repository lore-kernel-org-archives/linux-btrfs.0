Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:39865 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752418AbbFQRsG (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 17 Jun 2015 13:48:06 -0400
Date: Wed, 17 Jun 2015 10:48:02 -0700
From: Marc MERLIN <marc@merlins.org>
To: crocket <crockabiscuit@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Message-ID: <20150617174802.GN16468@merlins.org>
References: <CAL0=0H19M7JG4o4p55Li3tF4PeA-UXb8mURcSOdPLwxfL0c1DQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAL0=0H19M7JG4o4p55Li3tF4PeA-UXb8mURcSOdPLwxfL0c1DQ@mail.gmail.com>
Subject: Re: How do I make 'btrfs scrub' report errors via email?
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Jun 13, 2015 at 10:48:35PM +0900, crocket wrote:
> I can check the result of 'btrfs scrub' later, but I don't want to
> take time to actually check it.
> Does anyone know how to make 'btrfs scrub' report errors via email?
> It seems google doesn't know.

See the bottom of:
http://marc.merlins.org/perso/btrfs/2014-03.html#Btrfs-Tips_-Btrfs-Scrub-and-Btrfs-Filesystem-Repair

You can remove shlock from the script if you don't have it (or use
another lock script).

Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/                         | PGP 1024R/763BE901
