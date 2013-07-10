Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from csamuel.org ([74.50.50.137]:34993 "EHLO csamuel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751196Ab3GJEYb (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 10 Jul 2013 00:24:31 -0400
Received: from localhost (localhost [127.0.0.1])
	by csamuel.org (Postfix) with ESMTP id 7F85540AB1
	for <linux-btrfs@vger.kernel.org>; Wed, 10 Jul 2013 14:18:20 +1000 (EST)
Received: from csamuel.org ([127.0.0.1])
 by localhost (csamuel.org [127.0.0.1]) (amavisd-maia, port 10024) with LMTP
 id 19323-01 for <linux-btrfs@vger.kernel.org>;
 Wed, 10 Jul 2013 14:18:20 +1000 (EST)
Received: from [128.250.103.226] (eris.vlsci.unimelb.edu.au [128.250.103.226])
	by csamuel.org (Postfix) with ESMTPSA id EFFAE40AB0
	for <linux-btrfs@vger.kernel.org>; Wed, 10 Jul 2013 14:18:19 +1000 (EST)
Message-ID: <51DCE08A.8060008@csamuel.org>
Date: Wed, 10 Jul 2013 14:18:18 +1000
From: Chris Samuel <chris@csamuel.org>
MIME-Version: 1.0
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: performance loss with lots of snapshots
References: <201307101254.44583.russell@coker.com.au>
In-Reply-To: <201307101254.44583.russell@coker.com.au>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hiya Russell,

On 10/07/13 12:54, Russell Coker wrote:

> This has happened to me often enough that I can probably reproduce it on a VM.  
> What kernel should I use for such tests?

I'd suggest at least 3.10, and perhaps also Chris Mason's git tree here:

https://git.kernel.org/cgit/linux/kernel/git/mason/linux-btrfs.git/

which is 3.10 plus the latest btrfs code that was merged by Linus into
his master for 3.11 today.

All the best,
Chris
-- 
 Chris Samuel  :  http://www.csamuel.org/  :  Melbourne, VIC
