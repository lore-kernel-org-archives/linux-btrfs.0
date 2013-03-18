Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim1.fusionio.com ([66.114.96.53]:44902 "EHLO
	dkim1.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753436Ab3CRUAi (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 18 Mar 2013 16:00:38 -0400
Received: from mx2.fusionio.com (unknown [10.101.1.160])
	by dkim1.fusionio.com (Postfix) with ESMTP id A76787C04D8
	for <linux-btrfs@vger.kernel.org>; Mon, 18 Mar 2013 14:00:37 -0600 (MDT)
Date: Mon, 18 Mar 2013 16:00:35 -0400
From: Josef Bacik <jbacik@fusionio.com>
To: Stefan Priebe <s.priebe@profihost.ag>
CC: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: vanilla 3.8.3: btrfs: block rsv returned -28
Message-ID: <20130318200035.GA25655@localhost.localdomain>
References: <51476EA7.9060607@profihost.ag>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <51476EA7.9060607@profihost.ag>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Mar 18, 2013 at 01:44:39PM -0600, Stefan Priebe wrote:
> Hello list,
> 
> while testing btrfs with 3.8.3 i'm seeing this one several times. Is it 
> known?
> 

Yup, it's fine, I'm fixing it for 3.10.  Thanks,

Josef
