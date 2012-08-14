Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from one.firstfloor.org ([213.235.205.2]:52806 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753649Ab2HNDPr (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 13 Aug 2012 23:15:47 -0400
Date: Tue, 14 Aug 2012 05:15:40 +0200
From: Andi Kleen <andi@firstfloor.org>
To: "Markus F.X.J. Oberhumer" <markus@oberhumer.com>
Cc: linux-kernel@vger.kernel.org, Andi Kleen <andi@firstfloor.org>,
        chris.mason@fusionio.com, linux-btrfs@vger.kernel.org,
        Nitin Gupta <ngupta@vflare.org>,
        Richard Purdie <rpurdie@openedhand.com>,
        richard -rw- weinberger <richard.weinberger@gmail.com>
Subject: Re: [GIT PULL] Update LZO compression
Message-ID: <20120814031540.GG11413@one.firstfloor.org>
References: <50299142.2030504@oberhumer.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <50299142.2030504@oberhumer.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Aug 14, 2012 at 01:44:02AM +0200, Markus F.X.J. Oberhumer wrote:
> Hi all,
> 
> as suggested on the mailing list I have converted the updated LZO
> code into git, so please pull my "lzo-update" branch from
> 
>   git://github.com/markus-oberhumer/linux.git lzo-update
> 
> You can browse the branch at
> 
>   https://github.com/markus-oberhumer/linux/compare/lzo-update

Looks ok to me from a quick look.

Since kernel lzo is security relevant, I assume the new version
has been fuzz tested?

I couldn't tell from the github view, but I assume you follow
standard coding style.

-Andi
