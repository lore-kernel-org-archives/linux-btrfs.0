Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mailout-de.gmx.net ([213.165.64.22]:38489 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752836Ab2HFULp (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 6 Aug 2012 16:11:45 -0400
Message-ID: <50202518.2080704@gmx.net>
Date: Mon, 06 Aug 2012 22:12:08 +0200
From: Arne Jansen <sensille@gmx.net>
MIME-Version: 1.0
To: Chris Mason <chris.mason@fusionio.com>,
        Alexander Block <ablock84@googlemail.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: wait_for_more_refs not waking up
References: <CAB9VWqBANPS9eQ6reVDBsE-cssp_sEPK2aDAXyQHLtHkBXV_BA@mail.gmail.com> <20120806201038.GE8417@shiny>
In-Reply-To: <20120806201038.GE8417@shiny>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 08/06/2012 10:10 PM, Chris Mason wrote:
> On Fri, Aug 03, 2012 at 01:11:31AM -0600, Alexander Block wrote:
>> I got a deadlock happening while creating a snapshot and ordered
>> writes are pending. I can reproduce it 100% using btrfs send/receive.
>> It happens when I receive a set of streams on a freshly created FS. I
>> think I can exclude send/receive as the source of the problem as it
>> happens while receiving, even when rebooting between send and receive.
>> Receive does not depend on any extra kernel support and only uses
>> normal vfs syscalls.
> 
> Are you seeing this one on the git tree I sent to Linus?  I triggered
> this once and then haven't seen it since I put in the barrier before the
> waitqueue active check.

I'll send a patch for this in a moment.

> 
> -chris
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

