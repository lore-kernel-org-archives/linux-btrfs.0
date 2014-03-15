Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from csamuel.org ([74.50.50.137]:40146 "EHLO csamuel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756186AbaCOWsq (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 15 Mar 2014 18:48:46 -0400
Received: from localhost (localhost [127.0.0.1])
	by csamuel.org (Postfix) with ESMTP id 6F23BCD271
	for <linux-btrfs@vger.kernel.org>; Sun, 16 Mar 2014 09:48:46 +1100 (EST)
Received: from csamuel.org ([127.0.0.1])
 by localhost (csamuel.org [127.0.0.1]) (amavisd-maia, port 10024) with LMTP
 id 29676-05 for <linux-btrfs@vger.kernel.org>;
 Sun, 16 Mar 2014 09:48:46 +1100 (EST)
Received: from [IPv6:2001:44b8:41dd:d500:6a5d:43ff:fe40:f7e] (2001-44b8-41dd-d500-6a5d-43ff-fe40-0f7e.static.ipv6.internode.on.net [IPv6:2001:44b8:41dd:d500:6a5d:43ff:fe40:f7e])
	by csamuel.org (Postfix) with ESMTPSA id AAF65CD26F
	for <linux-btrfs@vger.kernel.org>; Sun, 16 Mar 2014 09:48:45 +1100 (EST)
Message-ID: <5324D8CA.1080407@csamuel.org>
Date: Sun, 16 Mar 2014 09:48:42 +1100
From: Chris Samuel <chris@csamuel.org>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: Re: discard synchronous on most SSDs?
References: <1756989.4ep0Vdupld@tethys>	<yq1bnx8y2mi.fsf@sermon.lab.mkp.net> <4448214.x9oPWjPhdL@quad>	<1566234.HjNzCBAKa5@quad> <pan$86f37$20eb1911$444fa726$8400b046@cox.net>
In-Reply-To: <pan$86f37$20eb1911$444fa726$8400b046@cox.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 15/03/14 22:26, Duncan wrote:

> Either that or that feature bit simply indicates trim support, not NCQ
> trim support.

You're quite right, I outsmarted myself by noticing at the fact that the 
kernel tests for ATA_LOG_NCQ_SEND_RECV_DSM_TRIM and unsets that for 
drives that don't support NCQ DSM TRIM and then seeing DSM TRIM in the 
SATA 3.1 spec and inferred they were the same thing.

Looking closer at the kernel code that tests for what trim to use with 
ATA_LOG_NCQ_SEND_RECV_DSM_TRIM it falls back to ATA_DSM_TRIM if it can't 
do the NCQ version.

Mea culpa!

-- 
  Chris Samuel  :  http://www.csamuel.org/  :  Melbourne, VIC
