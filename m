Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cloud1-vm154.de-nserver.de ([178.250.10.56]:50669 "EHLO
        cloud1-vm154.de-nserver.de" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752300AbcI1LPd (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 28 Sep 2016 07:15:33 -0400
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
From: Stefan Priebe - Profihost AG <s.priebe@profihost.ag>
Subject: BTRFS: space_info 4 has 18446742286429913088 free, is not full
Message-ID: <1c94f3b1-b238-6668-7976-c0594f170dfe@profihost.ag>
Date: Wed, 28 Sep 2016 13:15:29 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Dear list,

is there any chance anybody wants to work with me on the following issue?

BTRFS: space_info 4 has 18446742286429913088 free, is not full
BTRFS: space_info total=98247376896, used=77036814336, pinned=0,
reserved=0, may_use=1808490201088, readonly=0

i get this nearly every day.

Here are some msg collected from today and yesterday from different servers:
| BTRFS: space_info 4 has 18446742182612910080 free, is not full |
| BTRFS: space_info 4 has 18446742254739439616 free, is not full |
| BTRFS: space_info 4 has 18446743980225085440 free, is not full |
| BTRFS: space_info 4 has 18446743619906420736 free, is not full |
| BTRFS: space_info 4 has 18446743647369576448 free, is not full |
| BTRFS: space_info 4 has 18446742286429913088 free, is not full

What i tried so far without success:
- use vanilla 4.8-rc8 kernel
- use latest vanilla 4.4 kernel
- use latest 4.4 kernel + patches from holger hoffstaette
- use clear_cache,space_cache=v2
- use clear_cache,space_cache=v1

But all tries result in ENOSPC after a short period of time doing backups.

Greets,
Stefan
