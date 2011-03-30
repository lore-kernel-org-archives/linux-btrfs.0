From: Josef Bacik <josef@redhat.com>
Subject: Do not use free space caching!
Date: Wed, 30 Mar 2011 17:19:50 -0400
Message-ID: <4D939E76.1060801@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

Just found a big bug in the free space caching stuff that will result in 
early ENOSPC.  I'm working on fixing this bug, but it won't be until 
tomorrow that I'll have it completely working, so for now make sure to 
mount -o clear_cache so that it just clears the cache and doesn't use it.

NOTE: It doesn't cause problems other than early ENOSPC, you won't get 
corruption or anything like that, tho you could possibly panic.

Sorry for the inconvenience.  Thanks,

Josef
