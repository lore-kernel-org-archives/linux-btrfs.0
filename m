Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from ch1ehsobe001.messaging.microsoft.com ([216.32.181.181]:34511
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757173Ab3BZNJB (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 26 Feb 2013 08:09:01 -0500
Message-ID: <512CB3E4.9040203@itu.dk>
Date: Tue, 26 Feb 2013 14:08:52 +0100
From: =?ISO-8859-1?Q?Matias_Bj=F8rling?= <mabj@itu.dk>
MIME-Version: 1.0
To: Zhi Yong Wu <zwu.kernel@gmail.com>
CC: <jmad@itu.dk>, <linux-btrfs@vger.kernel.org>, <chris.mason@fusionio.com>,
        <dsterba@suse.cz>
Subject: Re: [POSSIBLE SPAM]  Re: Hybrid Storage proposal
References: <20130220164605.GA13504@uflip.org> <CAEH94Liiy3ftSrkpiKyr68LHwQw55od4LY6hzZwzBKtCixxg+w@mail.gmail.com>
In-Reply-To: <CAEH94Liiy3ftSrkpiKyr68LHwQw55od4LY6hzZwzBKtCixxg+w@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 02/26/2013 12:04 PM, Zhi Yong Wu wrote:
> HI,
>
> It's a bit long so that i haven't read its whole, but i want to know
> if it has any collision with my ongoing feature "btrfs hot
> relocation/migration"?

It will utilize the hot track patch set you're been creating for VFS. I 
think the methods are complementary. Do you have a description of the 
relocation/migration approach?


