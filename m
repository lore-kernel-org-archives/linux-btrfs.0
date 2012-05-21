Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from csamuel.org ([74.50.50.137]:60110 "EHLO csamuel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751144Ab2EUGA3 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 21 May 2012 02:00:29 -0400
Message-ID: <4FB9D9F9.5040907@csamuel.org>
Date: Mon, 21 May 2012 16:00:25 +1000
From: Chris Samuel <chris@csamuel.org>
MIME-Version: 1.0
To: Marc MERLIN <marc@merlins.org>
CC: linux-btrfs@vger.kernel.org
Subject: Re: Which kernel is safe to upgrade to for btrfs?
References: <20120521052220.GD15765@merlins.org>
In-Reply-To: <20120521052220.GD15765@merlins.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 21/05/12 15:22, Marc MERLIN wrote:

> Have the free space problems been fixed in 3.3.x or is the 3.4.x branch
> better or should I stay with 3.2.x for safety?

There have been some fixes pushed back from the development tree into
the stable tree for 3.3.x (for the first time in btrfs's history I
believe) but there's a lot more work been happening in 3.4.

I'm happily sat on 3.2 and I would suggest sticking there too for a
while and watch what user reports come back for the 3.4 kernel (just out).

Just my 2p's worth..

cheers,
Chris
-- 
 Chris Samuel  :  http://www.csamuel.org/  :  Melbourne, VIC
