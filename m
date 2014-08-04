Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from csamuel.org ([74.50.50.137]:57018 "EHLO csamuel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751950AbaHDKYu (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 4 Aug 2014 06:24:50 -0400
Received: from localhost (localhost [127.0.0.1])
	by csamuel.org (Postfix) with ESMTP id DD9FA4003F
	for <linux-btrfs@vger.kernel.org>; Mon,  4 Aug 2014 20:24:49 +1000 (EST)
Received: from csamuel.org ([127.0.0.1])
 by localhost (csamuel.org [127.0.0.1]) (amavisd-maia, port 10024) with LMTP
 id 16047-04 for <linux-btrfs@vger.kernel.org>;
 Mon,  4 Aug 2014 20:24:49 +1000 (EST)
Received: from quad.localnet (2001-44b8-41dd-d500-9ddd-740d-de8b-0d3a.static.ipv6.internode.on.net [IPv6:2001:44b8:41dd:d500:9ddd:740d:de8b:d3a])
	by csamuel.org (Postfix) with ESMTPSA id 60B6640030
	for <linux-btrfs@vger.kernel.org>; Mon,  4 Aug 2014 20:24:49 +1000 (EST)
From: Chris Samuel <chris@csamuel.org>
To: linux-btrfs@vger.kernel.org
Subject: Re: ENOSPC with mkdir and rename
Date: Mon, 04 Aug 2014 20:24:46 +1000
Message-ID: <1875052.8GFlAMfPzL@quad>
In-Reply-To: <CAFvQSYRtZZz00u5fg8h0bjT-W67URtNMqh6F7SZxgZVYXNyR8Q@mail.gmail.com>
References: <CAFChkqtpb+xMhFk+7RBux-o-FOO0oaxx28Wz-LZZZVpvq2nRFQ@mail.gmail.com> <17833067.mzxAL4oqZq@quad> <CAFvQSYRtZZz00u5fg8h0bjT-W67URtNMqh6F7SZxgZVYXNyR8Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, 4 Aug 2014 11:56:46 AM Clemens Eisserer wrote:

> Which doesn't protect the *average* user from running into issues like this.

No, but they need to be aware of it.

> Just because it has been discussed, doesn't mean nothing can/should be done
> about it

Indeed, and a lot of work has been done over the years on it and it's a lot 
better than it used to be. :-)

cheers,
Chris
-- 
 Chris Samuel  :  http://www.csamuel.org/  :  Melbourne, VIC


