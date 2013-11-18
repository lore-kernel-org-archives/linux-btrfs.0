Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from terminus.zytor.com ([198.137.202.10]:39778 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751363Ab3KRXZq (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 18 Nov 2013 18:25:46 -0500
Message-ID: <528AA1EB.3010909@zytor.com>
Date: Mon, 18 Nov 2013 15:25:31 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
MIME-Version: 1.0
To: Andrea Mazzoleni <amadvance@gmail.com>
CC: linux-raid@vger.kernel.org, linux-btrfs@vger.kernel.org,
        david.brown@hesbynett.no, creamyfish@gmail.com
Subject: Re: Triple parity and beyond
References: <CAGKKSfWO4qTZsbd-=10cKc7=O7hTCVceMVQvCTJcUh1Z_gW04Q@mail.gmail.com>	<528A90B7.5010905@zytor.com> <CAGKKSfWXv4vzVDz-wOm=wC=oU3uM3t7hnp39CoXFkOjyjN_knA@mail.gmail.com>
In-Reply-To: <CAGKKSfWXv4vzVDz-wOm=wC=oU3uM3t7hnp39CoXFkOjyjN_knA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 11/18/2013 02:35 PM, Andrea Mazzoleni wrote:
> Hi Peter,
> 
> The Cauchy matrix has the mathematical property to always have itself
> and all submatrices not singular. So, we are sure that we can always
> solve the equations to recover the data disks.
> 
> Besides the mathematical proof, I've also inverted all the
> 377,342,351,231 possible submatrices for up to 6 parities and 251 data
> disks, and got an experimental confirmation of this.
> 

Nice.

>
> The only limit is coming from the GF(2^8). You have a maximum number
> of disk = 2^8 + 1 - number_of_parities. For example, with 6 parities,
> you can have no more of 251 data disks. Over this limit it's not
> possible to build a Cauchy matrix.
> 

251?  Not 255?

> Note that instead with a Vandermonde matrix you don't have the
> guarantee to always have all the submatrices not singular. This is the
> reason because using power coefficients, before or late, it happens to
> have unsolvable equations.
> 
> You can find the code that generate the Cauchy matrix with some
> explanation in the comments at (see the set_cauchy() function) :
> 
> http://sourceforge.net/p/snapraid/code/ci/master/tree/mktables.c

OK, need to read up on the theoretical aspects of this, but it sounds
promising.

	-hpa


