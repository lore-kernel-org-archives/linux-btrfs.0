Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from zaphod.cobb.me.uk ([213.138.97.131]:53938 "EHLO
	zaphod.cobb.me.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750783AbcFUNZ2 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 21 Jun 2016 09:25:28 -0400
Received: from black.home.cobb.me.uk (unknown [192.168.0.205])
	by zaphod.cobb.me.uk (Postfix) with ESMTP id 7D65F9B8FE
	for <linux-btrfs@vger.kernel.org>; Tue, 21 Jun 2016 14:17:38 +0100 (BST)
Received: from [192.168.0.211] (novatech.home.cobb.me.uk [192.168.0.211])
	by black.home.cobb.me.uk (Postfix) with ESMTPS id 55ABC5FB8A
	for <linux-btrfs@vger.kernel.org>; Tue, 21 Jun 2016 14:17:38 +0100 (BST)
Subject: Re: Is "btrfs balance start" truly asynchronous?
To: linux-btrfs@vger.kernel.org
References: <f68639e5a41343c04fa4d76f3fb14370@www.centurion.link>
 <pan$7df97$9174e96e$7848d28b$295d4358@cox.net>
 <bc9cdbdf-060b-e903-0c74-c2b6f1f92077@gmail.com>
 <20160621113339.GA3325@carfax.org.uk>
 <176a9733-ade2-d3a6-a9aa-1476d6afb3e1@gmail.com>
From: Graham Cobb <g.btrfs@cobb.uk.net>
Message-ID: <57693E72.1090706@cobb.uk.net>
Date: Tue, 21 Jun 2016 14:17:38 +0100
MIME-Version: 1.0
In-Reply-To: <176a9733-ade2-d3a6-a9aa-1476d6afb3e1@gmail.com>
Content-Type: text/plain; charset=windows-1252
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 21/06/16 12:51, Austin S. Hemmelgarn wrote:
> The scrub design works, but the whole state file thing has some rather
> irritating side effects and other implications, and developed out of
> requirements that aren't present for balance (it might be nice to check
> how many chunks actually got balanced after the fact, but it's not
> absolutely necessary).

Actually, that would be **really** useful.  I have been experimenting
with cancelling balances after a certain time (as part of my
"balance-slowly" script).  I have got it working, just using bash
scripting, but it means my script does not know whether any work has
actually been done by the balance run which was cancelled (if no work
was done, but it timed out anyway, there is probably no point trying
again with the same timeout later!).

Graham



