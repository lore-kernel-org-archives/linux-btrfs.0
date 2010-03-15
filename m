From: Phillip Michael <oopsicrappe@gmail.com>
Subject: Re: [BUG] scheduling while atomic: init/1/0x00000002
Date: Mon, 15 Mar 2010 15:20:23 -0700
Message-ID: <45e1b66a1003151520k2be08f2drb976abdad1ef9006@mail.gmail.com>
References: <45e1b66a1003131549k28173905r85ab74cd870db36e@mail.gmail.com>
	 <93cdabd21003132226s2201c067vfdbcaad56ecffd81@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs@vger.kernel.org
To: Mike Fedyk <mfedyk@mikefedyk.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <93cdabd21003132226s2201c067vfdbcaad56ecffd81@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

>> BUG: scheduling while atomic: init/1/0x00000002
>> Modules linked in:
>> Pid: 1, comm: init Not tainted 2.6.33-zen2-20100307-stable #6
>
> Can you reproduce this error on stock 2.6.33 without the zen patches?
>

I get the same bug on a stock archlinux 2.6.33 kernel. I have to
finish reinstalling before I can build a vanilla kernel to try.
