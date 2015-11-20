Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from vs2.lukas-pirl.de ([5.45.100.90]:52644 "EHLO pim.lukas-pirl.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934126AbbKTAGe (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 19 Nov 2015 19:06:34 -0500
Subject: Re: anything wrong with `balance -dusage -musage` together?
To: Hugo Mills <hugo@carfax.org.uk>
References: <564E60FD.1010801@lukas-pirl.de>
 <20151119235931.GH24333@carfax.org.uk>
Cc: linux-btrfs@vger.kernel.org
From: Lukas Pirl <btrfs@lukas-pirl.de>
Message-ID: <564E6404.7050100@lukas-pirl.de>
Date: Fri, 20 Nov 2015 13:06:28 +1300
MIME-Version: 1.0
In-Reply-To: <20151119235931.GH24333@carfax.org.uk>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 11/20/2015 12:59 PM, Hugo Mills wrote as excerpted:
>    Nothing actively wrong with that, no. It certainly won't break
> anything. It's just rarely actually useful. The usual situation is
> that you run out of one kind of storage before the other (data vs
> metadata, that is), and you need to free up some allocation of one of
> them so it can go to the other. This is typically too much data
> allocation, and metadata has run out (so -d is more often used than
> -m).
>
>    For the "usual" case of running out of metadata allocation, you
> don't actually need much space to reclaim, so -dlimit=X for small X is
> an easier approach to use.

Thanks Hugo for your quick reply.

Alright, the look at https://github.com/kdave/btrfsmaintenance
just made me think over regular balances using -*usage before one or the
other space runs out (as suggested there).

Best,

Lukas
