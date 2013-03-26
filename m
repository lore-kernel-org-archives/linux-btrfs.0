Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim2.fusionio.com ([66.114.96.54]:33414 "EHLO
	dkim2.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759406Ab3CZMxW (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 26 Mar 2013 08:53:22 -0400
Received: from mx2.fusionio.com (unknown [10.101.1.160])
	by dkim2.fusionio.com (Postfix) with ESMTP id 119AD9A0680
	for <linux-btrfs@vger.kernel.org>; Tue, 26 Mar 2013 06:53:22 -0600 (MDT)
Date: Tue, 26 Mar 2013 08:53:19 -0400
From: Josef Bacik <jbacik@fusionio.com>
To: Stefan Priebe <s.priebe@profihost.ag>
CC: Josef Bacik <JBacik@fusionio.com>, Chris Mason <clmason@fusionio.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: No space left on device (28)
Message-ID: <20130326125319.GH1955@localhost.localdomain>
References: <5F36F35C-39BE-4244-B8FB-A80EC2B06D48@profihost.ag>
 <514C4A8C.90607@profihost.ag>
 <20130322135322.GB1955@localhost.localdomain>
 <514C6319.7030400@profihost.ag>
 <20130322155453.GD1955@localhost.localdomain>
 <514CAC8D.7010409@profihost.ag>
 <20130322204932.GE1955@localhost.localdomain>
 <514CC52B.1000201@profihost.ag>
 <20130325201426.GG1955@localhost.localdomain>
 <51515226.9010509@profihost.ag>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <51515226.9010509@profihost.ag>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Mar 26, 2013 at 01:45:42AM -0600, Stefan Priebe wrote:
> Hi,
> 
> output here:
> [  590.546162] returning enospc, space_info 3, size 0 reserved 0, flush 
> 2, flush_state 7  dumping space info
> [  590.548280] space_info 4 has 6439292928 free, is full
> [  590.548283] space_info total=25748307968, used=19308916736, pinned=0, 
> reserved=32768, may_use=6438354944, readonly=65536
> [  590.550147] returning enospc, space_info 3, size 0 reserved 0, flush 
> 2, flush_state 7  dumping space info
> [  590.552264] space_info 4 has 6439284736 free, is full
> [  590.552267] space_info total=25748307968, used=19308916736, pinned=0, 
> reserved=40960, may_use=6438354944, readonly=65536
> [  590.554141] returning enospc, space_info 3, size 0 reserved 0, flush 
> 2, flush_state 7  dumping space info
> [  590.556258] space_info 4 has 6439284736 free, is full
> [  590.556261] space_info total=25748307968, used=19308916736, pinned=0, 
> reserved=40960, may_use=6438354944, readonly=65536
> [  591.145255] returning enospc, space_info 3, size 0 reserved 0, flush 
> 2, flush_state 7  dumping space info
> [  591.147373] space_info 4 has 6439235584 free, is full
> [  591.147375] space_info total=25748307968, used=19308916736, pinned=0, 
> reserved=90112, may_use=6438354944, readonly=65536
> [  595.560257] returning enospc, space_info 3, size 0 reserved 0, flush 
> 2, flush_state 7  dumping space info
> [  595.562390] space_info 4 has 6439120896 free, is full
> [  595.562393] space_info total=25748307968, used=19309047808, pinned=0, 
> reserved=73728, may_use=6438297600, readonly=65536
> 

Weird, we have all the flushing stuff set and yet there is still a whole lot of
outstanding reservations.  Do you have compression enabled?  Thanks,

Josef
