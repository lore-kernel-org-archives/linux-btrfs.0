From: darrin hodges <darrin.hodges@gmail.com>
Subject: mount btrfs by name?
Date: Wed, 14 Jul 2010 16:23:19 +1000
Message-ID: <AANLkTimAKgsy1ORdDB50dJfRkqPJ6OZHyfIDE2oqDCTe@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Will it be possible in the future to mount a [ multi-device] btrfs via
its volume name [ or UUID] as opposed to just using one of the device
names in the group?

Something like "btrfs-mount 'myData' /mnt" or "btrfs-mount
'2f0c9c70-820f-4978-af5a-93bc9f7d89da' /mnt".  I find using one of the
devices names in a multi-device btrfs a bit disconcerting.

cheers
Darrin
