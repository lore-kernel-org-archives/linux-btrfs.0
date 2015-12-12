Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from vwp7940.webpack.hosteurope.de ([178.77.87.119]:46026 "EHLO
	vwp7940.webpack.hosteurope.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754546AbbLLBe5 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 11 Dec 2015 20:34:57 -0500
Message-ID: <566B79BC.30104@anonym.com>
Date: Sat, 12 Dec 2015 02:34:52 +0100
From: "S.J." <sorry@anonym.com>
MIME-Version: 1.0
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: attacking btrfs filesystems via UUID collisions?
References: <20151204120529.37E47D5A28@emkei.cz>	<20151204130758.GR8775@carfax.org.uk>	<1449286104.18841.14.camel@scientia.net>	<pan$7e229$ce87d3b$b8d75c44$337e15c7@cox.net>	<1449366680.3183.37.camel@scientia.net>	<56644785.4090702@gmx.com>	<1449639588.7835.2.camel@scientia.net>	<5668A1CB.1020007@anonym.com>	<CAJCQCtQCoi52o2REWZGObq-19EpgCv+7QmKvP=Gvk1myVq-+_g@mail.gmail.com>	<1449872498.31388.74.camel@fo> <CAJCQCtSXkXs0jQ=zaP6FJvRZS0yvz5CrjP8a06K0+htG5H8LTg@mail.gmail.com>
In-Reply-To: <CAJCQCtSXkXs0jQ=zaP6FJvRZS0yvz5CrjP8a06K0+htG5H8LTg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

A bit more about the dd-is-bad-topic:

IMHO it doesn't matter at all.

a) For this specific problem here, fixing a security problem automatically
fixes the risk of data corruption because careless cloning+mounting
(without UUID adjustments) too.
So, if the user likes to use dd with its disadvantages, like waiting 
hours to
copy lots of free space, and bad practice, etc.etc., why should it concern
the Btrfs developers and/or us here?

b) At wider scope; while Btrfs is more complex than Xfs etc., currently
there is no other reason why things could go bad when dd'ing something.
As long as this holds, is there really a place in the official Btrfs 
documentation
for telling the users "dd is bad [practice]"?
...


