Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mailgw-02.dd24.net ([193.46.215.43]:43659 "EHLO
        mailgw-02.dd24.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753326AbeFGDAc (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 6 Jun 2018 23:00:32 -0400
Received: from mailpolicy-01.live.igb.homer.key-systems.net (mailpolicy-02.live.igb.homer.key-systems.net [192.168.1.27])
        by mailgw-02.dd24.net (Postfix) with ESMTP id 7C8055FD3C
        for <linux-btrfs@vger.kernel.org>; Thu,  7 Jun 2018 02:50:35 +0000 (UTC)
Received: from mailgw-02.dd24.net ([192.168.1.36])
        by mailpolicy-01.live.igb.homer.key-systems.net (mailpolicy-02.live.igb.homer.key-systems.net [192.168.1.25]) (amavisd-new, port 10236)
        with ESMTP id ah9g50JCFs9z for <linux-btrfs@vger.kernel.org>;
        Thu,  7 Jun 2018 02:50:33 +0000 (UTC)
Received: from heisenberg-old.fritz.box (ppp-82-135-88-134.dynamic.mnet-online.de [82.135.88.134])
        (using TLSv1.2 with cipher DHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mailgw-02.dd24.net (Postfix) with ESMTPSA
        for <linux-btrfs@vger.kernel.org>; Thu,  7 Jun 2018 02:50:33 +0000 (UTC)
Message-ID: <5fff45c2188e6a73c48c7fed95f297e7f0af0dc3.camel@scientia.net>
Subject: in which directions does btrfs send -p | btrfs receive work
From: Christoph Anton Mitterer <calestyo@scientia.net>
To: linux-btrfs@vger.kernel.org
Date: Thu, 07 Jun 2018 04:50:33 +0200
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hey.

Just wondered about the following:

When I have a btrfs which acts as a master and from which I make copies
 of snapshots on it via send/receive (with using -p at send) to other
btrfs which acts as copies like this:
master +--> copy1
       +--> copy2
       \--> copy3
and if now e.g. the device of master breaks, can I move *with
incremential send -p / receive backups from one of the copies?

Which of the following two would work (or both?):

A) Redesignating a copy to be a new master, e.g.:
   old-copy1/new-master +--> new-disk/new-copy1
                    
   +--> copy2
                        \--> copy3
   Obviously at least
send/receiving to new-copy1 shoud work,
   but would that work as well
to copy2/copy3 (with -p), since they're
   based on (and probably using
UUIDs) from the snapshot on the old
   broken master?

B) Let a new device be the master and move on from that (kinda creating
   a "send/receive cycle":
   1st:
   copy1 +--> new-disk/new-master

   from then on (when new snapshots should be incrementally sent):
   new-master +--> copy1
              +--> copy2
              \--> copy3
   Again, not sure whether send/receiving to copy2/3 would work, since
   they're based on snapshots/parents from the old broken master.
   And I'm even more unsure, whether this back&forth send/receiving,
   from copy1->new-master->copy1 would work.


Any expert having some definite idea? :-)

Thanks,
Chris.
