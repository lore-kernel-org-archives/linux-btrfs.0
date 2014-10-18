Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from csamuel.org ([74.50.50.137]:60966 "EHLO csamuel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750860AbaJRHj2 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 18 Oct 2014 03:39:28 -0400
Received: from localhost (localhost [127.0.0.1])
	by csamuel.org (Postfix) with ESMTP id 4E9AF405B1
	for <linux-btrfs@vger.kernel.org>; Sat, 18 Oct 2014 18:32:48 +1100 (EST)
Received: from csamuel.org ([127.0.0.1])
 by localhost (csamuel.org [127.0.0.1]) (amavisd-maia, port 10024) with LMTP
 id 10771-03 for <linux-btrfs@vger.kernel.org>;
 Sat, 18 Oct 2014 18:32:48 +1100 (EST)
Received: from quad.localnet (2001-44b8-41dd-d500-7973-2f82-a172-c2bc.static.ipv6.internode.on.net [IPv6:2001:44b8:41dd:d500:7973:2f82:a172:c2bc])
	by csamuel.org (Postfix) with ESMTPSA id DF9EA40572
	for <linux-btrfs@vger.kernel.org>; Sat, 18 Oct 2014 18:32:47 +1100 (EST)
From: Chris Samuel <chris@csamuel.org>
To: linux-btrfs@vger.kernel.org
Subject: Re: unexplainable corruptions 3.17.0
Date: Sat, 18 Oct 2014 18:32:49 +1100
Message-ID: <1798492.UPHDTB8iYW@quad>
In-Reply-To: <CAGfcS_muumP4VQTUkTTGqg=RpjWrU1A5cC+g4=dKMbdMoQvmXg@mail.gmail.com>
References: <20141017085448.GA1050018@mother.pipebreaker.pl> <1413550386.755.1@mail.thefacebook.com> <CAGfcS_muumP4VQTUkTTGqg=RpjWrU1A5cC+g4=dKMbdMoQvmXg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, 17 Oct 2014 02:09:30 PM Rich Freeman wrote:

> Just for clarity - when can we expect to see these in the kernel?

The stable kernel rules say:

https://www.kernel.org/doc/Documentation/stable_kernel_rules.txt

#  - It or an equivalent fix must already exist in Linus' tree (upstream).

So until Linus merges the revert into the mainline kernel it cannot go into a 
stable release, and he's not merged it yet.

cheers,
Chris
-- 
 Chris Samuel  :  http://www.csamuel.org/  :  Melbourne, VIC


