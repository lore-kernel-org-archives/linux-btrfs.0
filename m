Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp-32-i6.italiaonline.it ([212.48.14.166]:41938 "EHLO
        libero.it" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1750990AbdHMOQi (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 13 Aug 2017 10:16:38 -0400
Reply-To: kreijack@inwind.it
To: linux-btrfs <linux-btrfs@vger.kernel.org>
From: Goffredo Baroncelli <kreijack@inwind.it>
Subject: [RFC] Checksum of the parity
Message-ID: <5d703b4c-e8ac-21dc-e327-ff1d8e232ee9@inwind.it>
Date: Sun, 13 Aug 2017 16:16:37 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi all,

in the BTRFS wiki, in the status page, in the "line" RAID5/6 it is reported that the parity is not checksummed. This was reported several time in the ML and also on other site (e.g. phoronix) as a BTRFS defect.

However I was unable to understand it, and I am supposing that this is a false mith. 

So my question is: the fact that in the BTRFS5/6 the parity is not checksummed could be considered a defect ? 

My goal is to verify if there is a rationale to require the parity checksummed, and if no I would like to remove this from the wiki.

BR
G.Baroncelli


-- 
gpg @keyserver.linux.it: Goffredo Baroncelli <kreijackATinwind.it>
Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5
