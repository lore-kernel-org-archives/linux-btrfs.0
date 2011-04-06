From: Stephane Chazelas <stephane.chazelas@gmail.com>
Subject: Re: cloning single-device btrfs file system onto multi-device one
Date: Wed, 6 Apr 2011 12:57:32 +0100
Message-ID: <chaz20110406115732.GB20568@seebyte.com>
References: <chaz20110321162450.GB918@seebyte.com> <chaz20110322092259.GA4861@seebyte.com> <AANLkTin1++vPq904tkPOAf3ZxwWTZaQYL+=WJHetEr9h@mail.gmail.com> <chaz20110328131748.GA18131@seebyte.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: cwillu <cwillu@cwillu.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <chaz20110328131748.GA18131@seebyte.com>
List-ID: <linux-btrfs.vger.kernel.org>

2011-03-28 14:17:48 +0100, Stephane Chazelas:
[...]
> So here is how I transferred a 6TB btrfs on one 6TB raid5 device
> (on host src) over the network onto a btrfs on 3 3TB hard drives
[...]
> I then did a btrfs fi balance again and let it run through. However here is
> what I get:
[...]

Sorry, it didn't run through and it is still running (after 9
days) and there are indications it  could still be running 8 years from
now (see other thread). There hasn't been any change in the
amount of free space reported by df since the beginning of  the
balance (there still are 2TB missing).

Cheers,
Stephane
