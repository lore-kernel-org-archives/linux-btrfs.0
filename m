From: David Sterba <dave@jikos.cz>
Subject: Re: kernel BUG at fs/btrfs/transaction.c:1337!
Date: Sun, 11 Mar 2012 00:10:09 +0100
Message-ID: <20120310231009.GM4334@twin.jikos.cz>
References: <CAMtaSwQUG2ovM8Yv_2+kLNMQbtMzwDq1pgd9PsMC3xYn2b6xmw@mail.gmail.com>
Reply-To: dave@jikos.cz
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: btrfs <linux-btrfs@vger.kernel.org>
To: qasdfgtyuiop <qasdfgtyuiop@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <CAMtaSwQUG2ovM8Yv_2+kLNMQbtMzwDq1pgd9PsMC3xYn2b6xmw@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

This is an IO error during transaction commit. Did you see any disk
error messages before the oops?


david

On Sat, Mar 10, 2012 at 06:26:02PM +0800, qasdfgtyuiop wrote:
> [11558.528460] RAX: 00000000fffffffb

0xFB == -EIO
