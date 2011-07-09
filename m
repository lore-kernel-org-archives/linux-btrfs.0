From: Evert Vorster <evorster@gmail.com>
Subject: Raid root filesystem?
Date: Fri, 8 Jul 2011 21:45:05 -0700
Message-ID: <CAER78vQwkSv1-bgKSRN2_ULRN7fG5mJDf6ZNkBKxYyO_jjuNAw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi there...

A year ago a btrfs raid needs to be scanned before it can be mounted.
Is this still the case?

I would like to have a btrfs raid as root, but so far this was not
possible due to the scanning thing, and thus I still need a /boot
filesystem.

It would be awesome to be able to just boot a btrfs raid without the
need for pesky partitions, as this would allow a system to be "grown"
later when space gets scarce...

-- 
-Evert-
