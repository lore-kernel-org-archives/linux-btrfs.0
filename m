Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.servus.at ([193.170.194.20]:33413 "EHLO mail.servus.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755763Ab2HNKKl (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 14 Aug 2012 06:10:41 -0400
Message-ID: <502A241A.8000301@oberhumer.com>
Date: Tue, 14 Aug 2012 12:10:34 +0200
From: "Markus F.X.J. Oberhumer" <markus@oberhumer.com>
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: linux-kernel@vger.kernel.org, chris.mason@fusionio.com,
        linux-btrfs@vger.kernel.org, Nitin Gupta <ngupta@vflare.org>,
        Richard Purdie <rpurdie@openedhand.com>,
        richard -rw- weinberger <richard.weinberger@gmail.com>
Subject: Re: [GIT PULL] Update LZO compression
References: <50299142.2030504@oberhumer.com> <20120814031540.GG11413@one.firstfloor.org>
In-Reply-To: <20120814031540.GG11413@one.firstfloor.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2012-08-14 05:15, Andi Kleen wrote:
> On Tue, Aug 14, 2012 at 01:44:02AM +0200, Markus F.X.J. Oberhumer wrote:
>> Hi all,
>>
>> as suggested on the mailing list I have converted the updated LZO
>> code into git, so please pull my "lzo-update" branch from
>>
>>   git://github.com/markus-oberhumer/linux.git lzo-update
>>
>> You can browse the branch at
>>
>>   https://github.com/markus-oberhumer/linux/compare/lzo-update
> 
> Looks ok to me from a quick look.
> 
> Since kernel lzo is security relevant, I assume the new version
> has been fuzz tested?

Of course!

> I couldn't tell from the github view, but I assume you follow
> standard coding style.

I've tried my best to follow the style guidelines.

Cheers,
Markus

> 
> -Andi
> 

-- 
Markus Oberhumer, <markus@oberhumer.com>, http://www.oberhumer.com/
