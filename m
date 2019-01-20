Return-Path: <SRS0=8/Zd=P4=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C22C8C61CE4
	for <linux-btrfs@archiver.kernel.org>; Sun, 20 Jan 2019 10:34:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8D0082087E
	for <linux-btrfs@archiver.kernel.org>; Sun, 20 Jan 2019 10:34:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728826AbfATKeL (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sun, 20 Jan 2019 05:34:11 -0500
Received: from icp-osb-irony-out4.external.iinet.net.au ([203.59.1.220]:6151
        "EHLO icp-osb-irony-out4.external.iinet.net.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728353AbfATKeD (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 20 Jan 2019 05:34:03 -0500
X-Greylist: delayed 557 seconds by postgrey-1.27 at vger.kernel.org; Sun, 20 Jan 2019 05:34:02 EST
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: =?us-ascii?q?A2DTLgCpS0Rc/5vN77ZjHQEBBQEHBQG?=
 =?us-ascii?q?BZQKCAoE1M4QoiHmMZ2IBg0yUAIF6IBgBhDoEgl8jOgQMAQMBAQEBAQECbSi?=
 =?us-ascii?q?FdDNYAiYCOzEIAQGDHoIBqwuBL4VDhF6BC4tNgUA/gTiCPQEBhXqCPII1IgK?=
 =?us-ascii?q?JQYcSkU0JDYFjQohJhxoegWaIZoZlY5x9DBKBVmwZgyiBbwGOfy6BMwGJEgE?=
 =?us-ascii?q?B?=
X-IPAS-Result: =?us-ascii?q?A2DTLgCpS0Rc/5vN77ZjHQEBBQEHBQGBZQKCAoE1M4Qoi?=
 =?us-ascii?q?HmMZ2IBg0yUAIF6IBgBhDoEgl8jOgQMAQMBAQEBAQECbSiFdDNYAiYCOzEIA?=
 =?us-ascii?q?QGDHoIBqwuBL4VDhF6BC4tNgUA/gTiCPQEBhXqCPII1IgKJQYcSkU0JDYFjQ?=
 =?us-ascii?q?ohJhxoegWaIZoZlY5x9DBKBVmwZgyiBbwGOfy6BMwGJEgEB?=
X-IronPort-AV: E=Sophos;i="5.56,499,1539619200"; 
   d="scan'208";a="138199761"
Received: from 182-239-205-155.ip.adam.com.au (HELO Oberon.Underworld) ([182.239.205.155])
  by icp-osb-irony-out4.iinet.net.au with ESMTP; 20 Jan 2019 18:24:43 +0800
To:     linux-btrfs@vger.kernel.org
From:   Dennis K <dennisk@netspace.net.au>
Openpgp: preference=signencrypt
Subject: Incremental receive completes succesfully despite missing files
Message-ID: <110c46c8-6fe9-84ea-0f4e-8269fd8000ed@netspace.net.au>
Date:   Sun, 20 Jan 2019 21:25:22 +1100
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:60.0) Gecko/20100101
 Thunderbird/60.3.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Apologies in advance, if the issue I put forward is actually the
intended behavior of BTRFS.

I have noted while playing with sub-volumes, and trying to determine
what exactly are the requirements for a subvolume to act as a legitimate
parent during a receive operation, that modification of one subvolume,
can affect children subvolumes that are received.

It's possible I have noted this before when directories which I though
should have existed in the destination volume, where not present,
despite being present in the snapshot at the sending end.  (ie, a
subvolume is sent incrementally, but the received subvolume is missing
files that exist on the sent side).

I can replicate this as follows

Create the subvolumes and put some files in them.
# btrfs sub create 1
# btrfs sub create 2
# cd 1
# dd if=/dev/urandom bs=1M count=10 of=test
# cd ..
# btrfs sub snap 1 2
# dd if=/dev/urandom bs=1M count=1 of=test2
# cd ..

Now set as read-only to send.  Subvolume 1 has the file "test, and
subvolume 2 has the files "test" and "test2".
# btrfs prop set 1 ro true
# btrfs prop set 2 ro true

Send, snapshot 2 is an incremental send.  The files created are the
expected sizes.
# btrfs send 1 -f /tmp/1
# btrfs send -p 1 2 -f /tmp 2

Now we make subvolume one read-write
# btrfs prop set 1 ro false
# rm 1/test

Delete subvolume 2 and then recreate it be receiving it.
# btrfs sub del 2
# btrfs receive -f /tmp/2 .

What happens, is that subvolume 2 is created, but it is missing the file
'test' which was present in subvolume 1 at the time it was created as a
snapshot and sent.  It now only contains the file "test2", which is NOT
the state that it was sent.


Note the same results are obtained, if you also delete subvolume 1 and
then recreate it with btrfs-receive.

This may explain why previously I found a send operation resulted in the
receiving end missing files previously.

I understand that during send/receive, a snapshot is taken of the parent
subvolume, then it is modified.  The problem is that if that snapshot is
modified, then these modifications will affect the received subvolumes,
including, in this case, silent data loss.


It would be better for the receive operation to fail, or at least put
out a warning if the parent subvolume it is using has changed or is
different from the reference subvolume used during send.  I'm not sure
whether BTRFS can check this via generation number or some other data,
orbut at the moment, there is no such check and this appears to be a bug.

Is this correct behaviour?  Does BTRFS rely on the user, and user-space
tools, never changing any subvolume in order to avoid silent data loss?
