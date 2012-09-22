Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx194.callplus.net.nz ([202.180.66.194]:55072 "EHLO
	mxi2.callplus.net.nz" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752176Ab2IVDs5 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 21 Sep 2012 23:48:57 -0400
Received: from [192.168.1.106] (125-239-118-176.jetstream.xtra.co.nz [125.239.118.176])
	(authenticated bits=0)
	by mx.theflat.net.nz (8.14.4/8.14.4) with ESMTP id q8M3cgsB016016
	(version=TLSv1/SSLv3 cipher=DHE-RSA-CAMELLIA256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Sat, 22 Sep 2012 15:38:48 +1200
Message-ID: <505D32C2.8070105@theflat.net.nz>
Date: Sat, 22 Sep 2012 15:38:42 +1200
From: Jp Wise <jpwise@theflat.net.nz>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: Identifying reflink / CoW files
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Good morning, I'm working on an offline deduplication script intended to 
work around the copy-on-write functionality of BTRFS.

Simply put - is there any existing utility to compare two files (or 
dirs) and output if the files share the same physical extents / data 
blocks on disk?
- aka - they're CoW copies.

I'm not actively working with BTRFS yet, but for the project i'm working 
on it's looking to the be most suitable candidate, and the CoW 
functionality avoids issues with file changes that hardlinks would create.
 From reading other posts, aware the information could be pulled out via 
btrfs-debug-tree, but it would then involve parsing the entire output to 
locate the required files inodes and their extents which seems like 
quite a roundabout way to retrieve the information.

Also my programming skills aren't  up to the task of trying to pull the 
tree data directly from the filesystem to do it, and I'd like to avoid 
doing byte-by-byte comparisons on all files as it's inefficient if the 
file can instead be identified as a CoW copy.

Open to suggestions of other tools that could be used to acheive the 
desired result.

Thanks.
Jp.
