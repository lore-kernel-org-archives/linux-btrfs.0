Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-by2nam03on0077.outbound.protection.outlook.com ([104.47.42.77]:19773
        "EHLO NAM03-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729501AbeIRXaH (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 18 Sep 2018 19:30:07 -0400
From: "Gervais, Francois" <FGervais@distech-controls.com>
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: btrfs receive incremental stream on another uuid
Date: Tue, 18 Sep 2018 17:56:21 +0000
Message-ID: <BN6PR01MB2531F06B0557C31005C5E6E7F31D0@BN6PR01MB2531.prod.exchangelabs.com>
Content-Type: text/plain; charset="iso-8859-1"
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


Hi,

I'm trying to apply a btrfs send diff (done through -p) to another subvolume with the same content as the proper parent but with a different uuid.

I looked through btrfs receive and I get the feeling that this is not possible right now.

I'm thinking of adding a -p option to btrfs receive which could override the parent information from the stream.

Would that make sense?
