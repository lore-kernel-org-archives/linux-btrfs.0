Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.fusionio.com ([66.114.96.30]:35761 "EHLO mx1.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756595Ab3ANO7H (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 14 Jan 2013 09:59:07 -0500
Date: Mon, 14 Jan 2013 09:59:04 -0500
From: Chris Mason <chris.mason@fusionio.com>
To: Tomasz Kusmierz <tom.kusmierz@gmail.com>
CC: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: btrfs for files > 10GB = random spontaneous CRC failure.
Message-ID: <20130114145904.GA1387@shiny>
References: <50F3E77B.2030901@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <50F3E77B.2030901@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jan 14, 2013 at 04:09:47AM -0700, Tomasz Kusmierz wrote:
> Hi,
> 
> Since I had some free time over Christmas, I decided to conduct few 
> tests over btrFS to se how it will cope with "real life storage" for 
> normal "gray users" and I've found that filesystem will always mess up 
> your files that are larger than 10GB.

Hi Tom,

I'd like to nail down the test case a little better.

1) Create on one drive, fill with data
2) Add a second drive, convert to raid1
3) find corruptions?

What happens if you start with two drives in raid1?  In other words, I'm
trying to see if this is a problem with the conversion code.

-chris
