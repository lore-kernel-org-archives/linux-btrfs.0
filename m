Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from csamuel.org ([74.50.50.137]:51191 "EHLO csamuel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757248Ab2HHLgT (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 8 Aug 2012 07:36:19 -0400
Received: from localhost (localhost [127.0.0.1])
	by csamuel.org (Postfix) with ESMTP id 2DCA44086A
	for <linux-btrfs@vger.kernel.org>; Wed,  8 Aug 2012 21:36:19 +1000 (EST)
Received: from csamuel.org ([127.0.0.1])
 by localhost (csamuel.org [127.0.0.1]) (amavisd-maia, port 10024) with LMTP
 id 01508-01 for <linux-btrfs@vger.kernel.org>;
 Wed,  8 Aug 2012 21:36:19 +1000 (EST)
Received: from [IPv6:2001:44b8:41b4:e400:211:50ff:fe0a:f395] (2001-44b8-41b4-e400-0211-50ff-fe0a-f395.static.ipv6.internode.on.net [IPv6:2001:44b8:41b4:e400:211:50ff:fe0a:f395])
	by csamuel.org (Postfix) with ESMTPSA id B78DE40869
	for <linux-btrfs@vger.kernel.org>; Wed,  8 Aug 2012 21:36:17 +1000 (EST)
Message-ID: <50224F1F.3030801@csamuel.org>
Date: Wed, 08 Aug 2012 21:35:59 +1000
From: Chris Samuel <chris@csamuel.org>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: Re: severe hardlink bug
References: <20100124015138.092c4959@simplux> <201001240909.44753.kreijack@libero.it> <20100124140837.5efcd526@simplux> <201001241415.47519.kreijack@inwind.it> <20100124142711.4afe8a81@simplux> <loom.20120729T205902-38@post.gmane.org> <501649E3.6010600@jan-o-sch.net> <loom.20120808T083450-852@post.gmane.org>
In-Reply-To: <loom.20120808T083450-852@post.gmane.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 08/08/2012 04:37 PM, Konstantin Dmitriev wrote:

> Unfortunately I cannot afford to have unstable patched kernel on the production
> server.

I'd suggest that using btrfs for production servers is probably a bit 
brave (no matter what Oracle say), and what you've found illustrates the 
point rather well I'm afraid..

cheers,
Chris
-- 
  Chris Samuel  :  http://www.csamuel.org/  :  Melbourne, VIC
