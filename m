From: Jan Engelhardt <jengelh@medozas.de>
Subject: AGs in btrfs
Date: Sat, 2 Aug 2008 20:20:40 -0400 (EDT)
Message-ID: <alpine.LNX.1.10.0808022018190.21001@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi,


I was wondering whether btrfs has a concept similar to xfs's "allocation 
groups", which, as far as I understand, means that the filesystem has 
multiple B-tree roots to allow for more finegrained locking and desaster 
containment (losing only 1/16th of the fs in a medium-worst case).
