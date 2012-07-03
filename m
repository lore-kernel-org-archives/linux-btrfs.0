Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from brockman.in8.de ([85.214.220.56]:41522 "EHLO mail.in8.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755009Ab2GCOf0 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 3 Jul 2012 10:35:26 -0400
Received: from [172.24.1.213] (unknown [192.166.201.94])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mail.in8.de (Postfix) with ESMTPSA id 499866AC26F
	for <linux-btrfs@vger.kernel.org>; Tue,  3 Jul 2012 16:35:25 +0200 (CEST)
Message-ID: <4FF3032D.1010007@jan-o-sch.net>
Date: Tue, 03 Jul 2012 16:35:25 +0200
From: Jan Schmidt <list.btrfs@jan-o-sch.net>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: Re: btrfs GPF in read_extent_buffer() while scrubbing with kernel
 3.4.2
References: <20120702230121.GD12755@sli.dy.fi> <4FF2EF68.6090401@jan-o-sch.net> <20120703135824.GA8908@sli.dy.fi>
In-Reply-To: <20120703135824.GA8908@sli.dy.fi>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 03.07.2012 15:58, Sami Liedes wrote:
> I think I might try setting up that netconsole to see if there are any
> interesting console messages before the oops... As I said, I also was
> able to reproduce this on 3.4.4, so ATM I assume I'm able to reproduce
> this at will.

That would be helpful. It's good that it's reproducible. Please paste the entire
output if possible.

If there's nothing immediately useful in there, I'll try to make up some
debugging patches for that problem.

Thanks!
-Jan
