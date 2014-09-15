Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from port-92-195-57-70.dynamic.qsc.de ([92.195.57.70]:38160 "EHLO
	richtercloud.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753108AbaIOPHY (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 15 Sep 2014 11:07:24 -0400
Received: from [192.168.178.32] (unknown [192.168.178.32])
	(Authenticated sender: richter)
	by richtercloud.de (Postfix) with ESMTPSA id 815E51FC005F
	for <linux-btrfs@vger.kernel.org>; Mon, 15 Sep 2014 16:59:45 +0200 (CEST)
Message-ID: <5416FECF.5030709@richtercloud.de>
Date: Mon, 15 Sep 2014 16:59:27 +0200
From: Karl-Philipp Richter <richter@richtercloud.de>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: How to deal with "The chunks in memory can not match the metadata
 of the fs. Repair failed."?
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi together,
I'm currently encountering another issue with `btrfs rescue 
chunk-recover`. After some seconds of maximal I/O activity, the program 
is idle for some seconds and then prints

     The chunks in memory can not match the metadata of the fs. Repair 
failed.
     Fail to recover the chunk tree.

I don't find any mention of this output except in the source code (this 
is as well the only thing $SEARCH_ENGINE points me to). What is the 
recommended next step? It would be nice to see the situation (The chunks 
in memory can not match the metadata of the fs) or the output mentioned 
in `man btrfs rescue`.

Any help is appreciated.

-Kalle
