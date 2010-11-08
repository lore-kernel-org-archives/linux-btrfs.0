From: Mike Fedyk <mfedyk@mikefedyk.com>
Subject: Re: [patch 0/2] Control filesystem balances (kernel side)
Date: Mon, 8 Nov 2010 10:01:28 -0800
Message-ID: <AANLkTimeYFN-iZ9sNNJTJT7HsdeyFsio0P_AAO7sRU70@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

[ sorry for breaking the thread, I'm replying from the archives, I was
unsubbed after a mail server issue and didn't notice till now... ]

On Sat, Oct 30, 2010 at 07:44:35PM +0200, Goffredo Baroncelli wrote:
> >                              balance	-> info on balancing

Hugo Mills wrote:
> For the one-value-per-file rule of sysfs, this should probably be
> balance_expected and balance_completed, each holding a count of block
> groups.

I'd name it balance_chunks_expected and balance_chunks_completed
