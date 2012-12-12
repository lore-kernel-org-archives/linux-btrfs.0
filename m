Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:48154 "EHLO
	out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754555Ab2LLRMU (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 12 Dec 2012 12:12:20 -0500
Received: from compute3.internal (compute3.nyi.mail.srv.osa [10.202.2.43])
	by gateway1.nyi.mail.srv.osa (Postfix) with ESMTP id 5C27B207D2
	for <linux-btrfs@vger.kernel.org>; Wed, 12 Dec 2012 12:12:20 -0500 (EST)
Message-Id: <1355332339.17999.140661165184497.5BC0F72B@webmail.messagingengine.com>
From: merc1984@f-m.fm
To: linux-btrfs@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain
In-Reply-To: <1354896969.6088.140661163160337.103F13F1@webmail.messagingengine.com>
References: <1354896969.6088.140661163160337.103F13F1@webmail.messagingengine.com>
Subject: Re: Encryption
Date: Wed, 12 Dec 2012 09:12:19 -0800
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


So there is no way to have filesystem encryption, while keeping
snapshots?


On Fri, Dec 7, 2012, at 8:16, [2]merc1984@f-m.fm wrote:

> We're using a backups server to back up all machines in a LAN.  Four 2TB disks are assembled in a BTRFS RAID array and mounted as /media/backups.  Under this are subvolumes droog, hex, etc, and snapshots droog_snap-{date1}, hex_snap-{date1}, etc.

> Goal is to encrypt backups, but the concern is with snapshots.  Won't piping rsync through encryption with GPG or somesuch, play havoc with BTRFS snapshot accounting?

> Is there any way to encrypt an array so it is inaccesible while umounted?

> I've already asked on the ecryptfs listserv and it resulted in mass confusion.

--


-- 
http://www.fastmail.fm - Or how I learned to stop worrying and
                          love email again

