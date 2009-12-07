From: Ahmed Kamal <email.ahmedkamal@googlemail.com>
Subject: Re: kernel .32, btrfs-vol -b, why is metadata=data
Date: Mon, 7 Dec 2009 22:26:43 +0200
Message-ID: <3da3b5b40912071226t793bf96avad30b2b62737b0a0@mail.gmail.com>
References: <3da3b5b40912060050s752b2ff1if19799c1e5d281da@mail.gmail.com>
	 <20091207153849.GA2859@think>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20091207153849.GA2859@think>
List-ID: <linux-btrfs.vger.kernel.org>

> In other words, btrfs-show could tell you that 19GB has been used, but
> df could say that 0 bytes are in use in the FS.

Thanks Chris for the clarification. So despite saying 19G are used, I
shouldn't be worried about running out of disk space, since these are
just pre-allocated areas. Perhaps btrfs-show should show how much
areas are really used, besides how much are just pre-allocated. The
thing is, I keep monitoring that number to avoid ENOSPC and now I know
that number is not accurate.

Thanks for the stellar work
Regards
