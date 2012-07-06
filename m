Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from brockman.in8.de ([85.214.220.56]:59828 "EHLO mail.in8.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755809Ab2GFPJC (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 6 Jul 2012 11:09:02 -0400
Received: from [172.24.1.213] (unknown [192.166.201.94])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mail.in8.de (Postfix) with ESMTPSA id 1ADD06AC270
	for <linux-btrfs@vger.kernel.org>; Fri,  6 Jul 2012 17:09:01 +0200 (CEST)
Message-ID: <4FF6FF8C.4010007@jan-o-sch.net>
Date: Fri, 06 Jul 2012 17:09:00 +0200
From: Jan Schmidt <list.btrfs@jan-o-sch.net>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: Re: btrfs GPF in read_extent_buffer() while scrubbing with kernel
 3.4.2
References: <4FF3032D.1010007@jan-o-sch.net> <20120703224756.GA21647@sli.dy.fi> <20120704001713.GA8986@sli.dy.fi> <4FF42876.8010309@jan-o-sch.net> <20120704160340.GA9770@sli.dy.fi> <4FF47168.9010405@jan-o-sch.net> <20120704202452.GA8996@sli.dy.fi> <4FF5998D.8020205@jan-o-sch.net> <20120705234739.GA9736@sli.dy.fi> <4FF6C12A.10305@jan-o-sch.net> <20120706143350.GA10427@sli.dy.fi>
In-Reply-To: <20120706143350.GA10427@sli.dy.fi>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, July 06, 2012 at 16:33 (+0200), Sami Liedes wrote:
> On Fri, Jul 06, 2012 at 12:42:50PM +0200, Jan Schmidt wrote:
>> I've no good idea at the moment how to go on. It might help to get a feeling if
>> it's shifting around at least a little bit or really constant in the timing of
>> occurrence. So can you please apply the next patch on top of the other two and
>> give it some more failure tries? The "checksum mismatch [1234]" line will be of
>> most interest. I'm also curious what the additional debug variables will say in
>> the extended version of the very first printk. You can leave out the stack
>> traces if you like, they won't matter much anyway.
> 
> Ok. Also turned on CONFIG_DEBUG_PAGEALLOC and CONFIG_SLUB_DEBUG_ON as
> suggested by Chris Mason.
> 
> With those and the latest patch, there's an oops already at boot. I
> don't have netconsole yet at that point, but here's the important
> parts (sure I can capture it fully if you need).

Oh I see. root->node can be NULL during mount. Please add this on top:

--
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index df0b347..22838a3 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -578,7 +578,8 @@ static noinline int check_node(struct btrfs_root *root,
	}
	node->debug[5] = node->start;
	node->debug[6] = btrfs_header_level(node);
-	node->debug[6] |= btrfs_header_level(root->node) << 16;
+	if (root->node)
+		node->debug[6] |= btrfs_header_level(root->node) << 16;
	node->debug[7] = 0xb22f50b22f5;

	return 0;
--


> By the way, something seems to be untabifying your patches. I don't
> know if it's on my side or yours, but at least some other patches I
> receive via linux-btrfs contain tabs. Doing a M-x tabify in emacs
> mostly makes them apply cleanly for me.

Oh, I'm sorry. Should have been on my side. I hope it's better with the current
diff?

-Jan
