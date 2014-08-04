Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from csamuel.org ([74.50.50.137]:49049 "EHLO csamuel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751373AbaHDJjd (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 4 Aug 2014 05:39:33 -0400
Received: from localhost (localhost [127.0.0.1])
	by csamuel.org (Postfix) with ESMTP id 32F744003F
	for <linux-btrfs@vger.kernel.org>; Mon,  4 Aug 2014 19:39:33 +1000 (EST)
Received: from csamuel.org ([127.0.0.1])
 by localhost (csamuel.org [127.0.0.1]) (amavisd-maia, port 10024) with LMTP
 id 15725-05 for <linux-btrfs@vger.kernel.org>;
 Mon,  4 Aug 2014 19:39:33 +1000 (EST)
Received: from quad.localnet (2001-44b8-41dd-d500-9ddd-740d-de8b-0d3a.static.ipv6.internode.on.net [IPv6:2001:44b8:41dd:d500:9ddd:740d:de8b:d3a])
	by csamuel.org (Postfix) with ESMTPSA id C81EB40030
	for <linux-btrfs@vger.kernel.org>; Mon,  4 Aug 2014 19:39:32 +1000 (EST)
From: Chris Samuel <chris@csamuel.org>
To: linux-btrfs@vger.kernel.org
Subject: Re: ENOSPC with mkdir and rename
Date: Mon, 04 Aug 2014 19:39:32 +1000
Message-ID: <17833067.mzxAL4oqZq@quad>
In-Reply-To: <CAFChkqttiPWQ+FquT2FfKE54US7vkeEyQsUT8fuD1BWNhS3k=w@mail.gmail.com>
References: <CAFChkqtpb+xMhFk+7RBux-o-FOO0oaxx28Wz-LZZZVpvq2nRFQ@mail.gmail.com> <53DEE40C.6020403@cn.fujitsu.com> <CAFChkqttiPWQ+FquT2FfKE54US7vkeEyQsUT8fuD1BWNhS3k=w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, 4 Aug 2014 09:14:19 AM Peter Waller wrote:

> All of this is *very* surprising.

Hmm, it shouldn't be, the ENOSPC issues are well known and have been discussed 
here for years.

cheers,
Chris
-- 
 Chris Samuel  :  http://www.csamuel.org/  :  Melbourne, VIC


