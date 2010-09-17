From: Bostjan Skufca <bostjan@a2o.si>
Subject: Current state of hot data relocation functionality
Date: Sat, 18 Sep 2010 01:33:17 +0200
Message-ID: <AANLkTi=k-ya8X4JU+=XGeK594AYHhye7_=knO_5eRHJS@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi all!

I was looking into some custom fileserver options and noticed two
facts about ZFS - support for L2ARC (albeit not persistant across
reboots, which is a downer) and OpenSolaris being a dead meat. Then I
found out that some patches were already floating around linux
mailinglists, patches about hot data relocation, but unfortunately
nothing definitive. So I would like to ask here: what is the status of
hot data relocation functionality?

I haven't had a chance to try out btrfs myself, but from what I see it
sure looks promising and seems like an option worth waiting on (I mean
this from fileserver with SSD cache point of view). So keep up the
good work, and thanks for an answer, if there will be one :)

Take care,
b.
