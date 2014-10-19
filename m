Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from csamuel.org ([74.50.50.137]:42869 "EHLO csamuel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751295AbaJSKq5 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 19 Oct 2014 06:46:57 -0400
Received: from localhost (localhost [127.0.0.1])
	by csamuel.org (Postfix) with ESMTP id 0D71120C1B0
	for <linux-btrfs@vger.kernel.org>; Sun, 19 Oct 2014 21:46:57 +1100 (EST)
Received: from csamuel.org ([127.0.0.1])
 by localhost (csamuel.org [127.0.0.1]) (amavisd-maia, port 10024) with LMTP
 id 21244-02 for <linux-btrfs@vger.kernel.org>;
 Sun, 19 Oct 2014 21:46:56 +1100 (EST)
Received: from quad.localnet (2001-44b8-41dd-d500-f0b6-f2cf-b299-3076.static.ipv6.internode.on.net [IPv6:2001:44b8:41dd:d500:f0b6:f2cf:b299:3076])
	by csamuel.org (Postfix) with ESMTPSA id A2B8F20C1AC
	for <linux-btrfs@vger.kernel.org>; Sun, 19 Oct 2014 21:46:56 +1100 (EST)
From: Chris Samuel <chris@csamuel.org>
To: linux-btrfs@vger.kernel.org
Subject: Re: strange 3.16.3 problem
Date: Sun, 19 Oct 2014 21:46:59 +1100
Message-ID: <6991158.lQd06JG7rD@quad>
In-Reply-To: <201410181454.19375.russell@coker.com.au>
References: <201410181454.19375.russell@coker.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hiya Russell,

On Sat, 18 Oct 2014 02:54:19 PM Russell Coker wrote:

> # find . -name "*546"
> ./1412233213.M638209P10546
> # ls -l ./1412233213.M638209P10546
> ls: cannot access ./1412233213.M638209P10546: No such file or directory

Does:

find . -name "*546" -ls

work at all?

-- 
 Chris Samuel  :  http://www.csamuel.org/  :  Melbourne, VIC


