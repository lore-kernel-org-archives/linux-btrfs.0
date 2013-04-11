Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from xp-ob.rzone.de ([81.169.146.138]:55396 "EHLO xp-ob.rzone.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752713Ab3DKQWK (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 11 Apr 2013 12:22:10 -0400
Received: from pizpot.store ([192.168.43.236])
	by josoe.store (josoe xp2) (RZmta 31.26 OK)
	with ESMTP id g02892p3BDH0WP for <linux-btrfs@vger.kernel.org>;
	Thu, 11 Apr 2013 18:22:08 +0200 (CEST)
From: Stefan Behrens <sbehrens@giantdisaster.de>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v2 0/4] Btrfs-progs: add --fields option to subvol list
Date: Thu, 11 Apr 2013 18:22:04 +0200
Message-Id: <cover.1365696891.git.sbehrens@giantdisaster.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

"btrfs subvolume list" gets a new option "--fields=..." which allows
to specify which pieces of information about subvolumes shall be
printed. This is necessary because this commit also adds all the so
far missing items from the root_item like the received UUID, all
generation values and all time values.

The parameters to the "--fields" option is a list of items to print:
--fields=gen,dirid,uuid,puuid,ruuid,cgen,ogen,sgen,rgen,ctime,otime,
         stime,rtime,path,rootid,parent,topid,all

v1 -> v2:
- On request of Wang Shilong, the commit is now splitted into several
  small commits.

Stefan Behrens (4):
  Btrfs-progs: cleanup in btrfs-list.c
  Btrfs-progs: make the btrfs-list output more compact
  Btrfs-progs: add more subvol fields to btrfs-list
  Btrfs-progs: enhance 'btrfs subvolume list'

 btrfs-list.c     | 422 +++++++++++++++++++++++++++++++++++--------------------
 btrfs-list.h     |  40 +++++-
 cmds-subvolume.c |  57 +++-----
 man/btrfs.8.in   |  19 +--
 4 files changed, 332 insertions(+), 206 deletions(-)

-- 
1.8.2.1

