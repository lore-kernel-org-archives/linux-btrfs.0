Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:41403 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751727AbbCUTvK (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 21 Mar 2015 15:51:10 -0400
Date: Sat, 21 Mar 2015 12:27:44 -0700
From: Marc MERLIN <marc@merlins.org>
To: Petr Bena <benapetr@gmail.com>
Cc: Roman Mamedov <rm@romanrm.net>, linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: New tool to recursive compress / decompress of files
Message-ID: <20150321192744.GO31311@merlins.org>
References: <CA+4EQ5cL53dS5k8fPNauT1fPGaYXjKBSzo7jTt1nz5p=w+c_SQ@mail.gmail.com> <20150321232225.5f7e997e@natsu> <CA+4EQ5fmYejgGf5yN0Qw7O9O43jPb6-f-RCVGXRopjA6-p2_2Q@mail.gmail.com> <CA+4EQ5cO3hR17RYTdHB8ZYn+OQHd9fEnyTWLgNPNcqRnzkRNOQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CA+4EQ5cO3hR17RYTdHB8ZYn+OQHd9fEnyTWLgNPNcqRnzkRNOQ@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Mar 21, 2015 at 07:26:41PM +0100, Petr Bena wrote:
> There is a dozen of cases where you want to just compress some folders
> in your system, but you don't want to compress whole device, would you
> create a subvolume for each of them?
 
Actually with the previous reply you got, I'm not sure there is any case at
all.

Compression makes your filesystem faster and is transparent to you.

Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/  
