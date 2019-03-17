Return-Path: <SRS0=swP/=RU=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0E4A5C43381
	for <linux-btrfs@archiver.kernel.org>; Sun, 17 Mar 2019 03:42:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C1F74218D0
	for <linux-btrfs@archiver.kernel.org>; Sun, 17 Mar 2019 03:42:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726684AbfCQDmr (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sat, 16 Mar 2019 23:42:47 -0400
Received: from mailgw-02.dd24.net ([193.46.215.43]:46700 "EHLO
        mailgw-02.dd24.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726599AbfCQDmr (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 16 Mar 2019 23:42:47 -0400
Received: from mailpolicy-01.live.igb.homer.key-systems.net (mailpolicy-02.live.igb.homer.key-systems.net [192.168.1.27])
        by mailgw-02.dd24.net (Postfix) with ESMTP id 5A1085FD52
        for <linux-btrfs@vger.kernel.org>; Sun, 17 Mar 2019 03:42:44 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at
        mailpolicy-02.live.igb.homer.key-systems.net
Received: from smtp.dd24.net ([192.168.1.36])
        by mailpolicy-01.live.igb.homer.key-systems.net (mailpolicy-02.live.igb.homer.key-systems.net [192.168.1.25]) (amavisd-new, port 10236)
        with ESMTP id Ws5T0qEXiBud for <linux-btrfs@vger.kernel.org>;
        Sun, 17 Mar 2019 03:42:42 +0000 (UTC)
Received: from heisenberg.fritz.box (ppp-82-135-82-31.dynamic.mnet-online.de [82.135.82.31])
        (using TLSv1.2 with cipher DHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by smtp.dd24.net (Postfix) with ESMTPSA
        for <linux-btrfs@vger.kernel.org>; Sun, 17 Mar 2019 03:42:42 +0000 (UTC)
Message-ID: <b2a668d7124f1d3e410367f587926f622b3f03a4.camel@scientia.net>
Subject: delayed_refs has NO entry / btrfs_update_root:136: Aborting unused
 transaction(No space left).
From:   Christoph Anton Mitterer <calestyo@scientia.net>
To:     linux-btrfs <linux-btrfs@vger.kernel.org>
Date:   Sun, 17 Mar 2019 04:42:39 +0100
Content-Type: multipart/mixed; boundary="=-oZRqPaTXIB1ZrjdWiMDI"
User-Agent: Evolution 3.30.5-1 
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org


--=-oZRqPaTXIB1ZrjdWiMDI
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit

(resending,... seems this hasn't gotten through to the list, when I've
sent it the first time)


Hi.

On Debian's 4.19.28-2 kernel (which includes the recent read-
corruption 
on compression fix) the following happens:

As a consequence of the bug from the "Reproducer for "compressed data +
hole data corruption bug, 2018 edition" still works on 4.20.7" mail
thread I started (trying) to verify whether any of my data was
affected.

Part of this was looking for files which actually are compressed by the
two methods Zygo mentioned (compsize and filefrag -v).

For this I used two scripts like the attached ones (yes I know, bad
performance) being fed by find path -type f -exec script {} \; .


I've did this already on one of my disks, which I btrfs checked before
(both normal and lowmem mode with no error), blockdev --setro'ed the
device and mounted it ro.

The filefrag seems to cause all kinds of errors and call traces, giving
the dmesg output attached.


Any ideas what causes that?


These days I unfortunately strongly loose trust in the stability and
integrity of btrfs :-(


Cheers,
Chris.

--=-oZRqPaTXIB1ZrjdWiMDI
Content-Type: application/x-shellscript; name="compsize-compressed"
Content-Disposition: attachment; filename="compsize-compressed"
Content-Transfer-Encoding: base64

IyEvYmluL3NoCgp0bXA9IiQoIGNvbXBzaXplIC0tYnl0ZXMgIiQxIiApIgppZiBbICQ/IC1uZSAw
IF07IHRoZW4KCWVjaG8gIkVNUFRZOiAkMSIKCWV4aXQKZmkKCmlmIFsgLXogIiQoIHByaW50ZiAi
JXMiICIkdG1wIiB8IGdyZXAgLXYgIl5UeXBlXHxeVE9UQUxcfF5ub25lIiApIiBdOyB0aGVuCgll
Y2hvICJVTkNPTVBSRVNTRUQ6ICQxIgplbHNlCgllY2hvICJDT01QUkVTU0VEOiAkMSIKZmkK


--=-oZRqPaTXIB1ZrjdWiMDI
Content-Type: application/x-shellscript; name="filefrag-compressed"
Content-Disposition: attachment; filename="filefrag-compressed"
Content-Transfer-Encoding: base64

IyEvYmluL3NoCgp0bXA9IiQoIGZpbGVmcmFnIC12ICIkMSIgKSIKaWYgWyAkPyAtbmUgMCBdOyB0
aGVuCgllY2hvICJFUlJPUjogJDEiCglleGl0CmZpCgppZiBwcmludGYgIiVzIiAiJHRtcCIgfCBo
ZWFkIC1uIC0xIHwgdGFpbCAtbiArNCB8IGdyZXAgLXEgZW5jb2RlZDsgdGhlbgoJZWNobyAiQ09N
UFJFU1NFRDogJDEiCmVsc2UKCWVjaG8gIlVOQ09NUFJFU1NFRDogJDEiCmZpCg==


--=-oZRqPaTXIB1ZrjdWiMDI
Content-Type: application/x-xz; name="dmesg.xz"
Content-Disposition: attachment; filename="dmesg.xz"
Content-Transfer-Encoding: base64

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
+wIAAAAABFla


--=-oZRqPaTXIB1ZrjdWiMDI--

