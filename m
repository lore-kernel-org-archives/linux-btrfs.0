Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from srv2.trombetti.net ([65.254.53.252]:1084 "EHLO
	srv2.trombetti.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751395AbaJJKxl (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 10 Oct 2014 06:53:41 -0400
Received: from localhost (localhost [127.0.0.1])
	(using TLSv1 with cipher DHE-RSA-AES128-SHA (128/128 bits))
	(No client certificate requested)
	(Authenticated sender: SASL)
	by srv2.trombetti.net (Postfix) with ESMTPSA id BF684313AB
	for <linux-btrfs@vger.kernel.org>; Fri, 10 Oct 2014 07:06:28 -0400 (EDT)
Message-ID: <5437BAB2.1040605@shiftmail.org>
Date: Fri, 10 Oct 2014 12:53:38 +0200
From: Bob Marley <bobmarley@shiftmail.org>
MIME-Version: 1.0
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: What is the vision for btrfs fs repair?
References: <54358C77.2070808@redhat.com> <9251D9EB-5B12-4885-8C6B-FFA10B1CDA24@colorremedies.com>
In-Reply-To: <9251D9EB-5B12-4885-8C6B-FFA10B1CDA24@colorremedies.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 10/10/2014 03:58, Chris Murphy wrote:
>
>> * mount -o recovery
>> 	"Enable autorecovery attempts if a bad tree root is found at mount time."
> I'm confused why it's not the default yet. Maybe it's continuing to evolve at a pace that suggests something could sneak in that makes things worse? It is almost an oxymoron in that I'm manually enabling an autorecovery
>
> If true, maybe the closest indication we'd get of btrfs stablity is the default enabling of autorecovery.

No way!
I wouldn't want a default like that.

If you think at distributed transactions: suppose a sync was issued on 
both sides of a distributed transaction, then power was lost on one 
side, than btrfs had corruption. When I remount it, definitely the worst 
thing that can happen is that it auto-rolls-back to a previous 
known-good state.

Now if I can express wishes:

I would like an option that spits out all the usable tree roots (or 
what's the name, superblocks?) and not just the newest one which is 
corrupt. And then another option that lets me mount *readonly* starting 
from the tree root I specify. So I can check how much of the data is 
still there. After I decide that such tree root is good, I need another 
option that lets me mount with such tree root in readwrite mode, and 
obviously eliminating all tree roots newer than that.
Some time ago I read that mounting the filesystem with an earlier tree 
root was possible, but only by manually erasing the disk regions in 
which the newer superblocks are. This is crazy, it's too risky on too 
many levels, and also as I wrote I want to check what data is available 
on a certain tree root before mounting readwrite from that one.


