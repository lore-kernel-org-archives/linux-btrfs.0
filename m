Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:43409 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751432AbbFRBX3 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 17 Jun 2015 21:23:29 -0400
Date: Wed, 17 Jun 2015 18:23:04 -0700
From: Marc MERLIN <marc@merlins.org>
To: crocket <crockabiscuit@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Message-ID: <20150618012304.GU16468@merlins.org>
References: <CAL0=0H19M7JG4o4p55Li3tF4PeA-UXb8mURcSOdPLwxfL0c1DQ@mail.gmail.com>
 <20150617174802.GN16468@merlins.org>
 <CAL0=0H0OtLOY0toMcLGtmj1s1TywuO2MDmfOcpR2vNzp_czoQQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAL0=0H0OtLOY0toMcLGtmj1s1TywuO2MDmfOcpR2vNzp_czoQQ@mail.gmail.com>
Subject: Re: How do I make 'btrfs scrub' report errors via email?
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jun 18, 2015 at 09:56:09AM +0900, crocket wrote:
> I think that's not going to report only errors.

Outside of saying how long the scrub took, that's all it does.

If you're not quite happy with the output, grep -v is your friend :)

Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/                         | PGP 1024R/763BE901
