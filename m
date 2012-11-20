Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:44779 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752017Ab2KTNUW (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 20 Nov 2012 08:20:22 -0500
Date: Tue, 20 Nov 2012 21:20:01 +0800
From: Liu Bo <bo.li.liu@oracle.com>
To: Ross Moore <ross@rossmoore.net>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: BTRFS Bug
Message-ID: <20121120131959.GA2620@gmail.com>
Reply-To: bo.li.liu@oracle.com
References: <CAJDbZnThjTHNON46Sb5QWyaJ9VuaKkza=Z6+OE_dh_YqavtDJQ@mail.gmail.com>
 <20121112150847.GD6347@gmail.com>
 <CAJDbZnTMmzMJYR6=qkX1CTQ365MSYeSX7L8LrE_GLsxWAbz58Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAJDbZnTMmzMJYR6=qkX1CTQ365MSYeSX7L8LrE_GLsxWAbz58Q@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Nov 20, 2012 at 05:54:35PM +0800, Ross Moore wrote:
> Hi,
> Any update on this before I wipe the disks and start again?

Hi Ross,

Sorry but I failed to reproduce it locally, although I've tried various
disk operations like balance, dev add/del etc...

So have you also tried the latest btrfs or the last stable one?
Does they show the same 'btrfs fi df' output?

thanks,
liubo
