Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from 220-245-31-42.static.tpgi.com.au ([220.245.31.42]:43623 "EHLO
	smtp.sws.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752010AbaJWHej (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 23 Oct 2014 03:34:39 -0400
In-Reply-To: <20141022202519.GC18164@carfax.org.uk>
References: <54480ED0.9070703@pobox.com> <20141022202519.GC18164@carfax.org.uk>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Subject: Re: NOCOW and Swap Files?
From: Russell Coker <russell@coker.com.au>
Date: Thu, 23 Oct 2014 18:34:32 +1100
To: Hugo Mills <hugo@carfax.org.uk>, Robert White <rwhite@pobox.com>
CC: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Message-ID: <EEAA8577-23BD-4126-9EC6-CB3BA96775EF@coker.com.au>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Also it would be nice to have checksums on the swap data. It's a bit of a waste to pay for ECC RAM and then lose the ECC benefits as soon as data is paged out.
-- 
Sent from my Samsung Galaxy Note 3 with K-9 Mail.
