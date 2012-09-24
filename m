Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from eu1sys200aog103.obsmtp.com ([207.126.144.115]:55511 "HELO
	eu1sys200aog103.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753909Ab2IXN2b (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 24 Sep 2012 09:28:31 -0400
Received: by weyt9 with SMTP id t9so208122wey.19
        for <linux-btrfs@vger.kernel.org>; Mon, 24 Sep 2012 06:28:29 -0700 (PDT)
MIME-Version: 1.0
From: Sami Haahtinen <sami@haahtinen.name>
Date: Mon, 24 Sep 2012 16:28:08 +0300
Message-ID: <CA+nK0aON8yROCGwetiXdEphUf+Ju-BVJ54ooeMOZyUpHy9KDGA@mail.gmail.com>
Subject: Rebuilding chunk root?
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

Due to certain unfortunate chain of events, I managed to overwrite a
small portion of my btrfs array which had only single redundancy for
metadata. The data itself is present and only a small portion (2.5%)
of the array was overwritten.

After quite a bit of debugging and tinkering, I realized that my chunk
root was in the portion that was overwritten. After reading through
the documentation I was able to pull together it's still unclear to me
whether chunk root is something that can be rebuilt.

A transcript of btrfsck trying to recover with superblock 2 which is
uncorrupted by itself:

root@sysresccd /root/btrfs-progs % ./btrfsck --super 2 /dev/patience/home
using SB copy 2, bytenr 274877906944
Check tree block failed, want=139264, have=0
Check tree block failed, want=139264, have=0
Check tree block failed, want=139264, have=0
read block failed check_tree_block
Couldn't read chunk root

If I'm interpreting the output correctly, it's trying to read bytes
from address 139264, which would fall into the corrupted area.

Regards,
--
Sami Haahtinen
Bad Wolf Oy
+358443302775
