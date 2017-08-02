Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from caracal.ash.relay.mailchannels.net ([23.83.222.30]:54323 "EHLO
        caracal.ash.relay.mailchannels.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752486AbdHBIpg (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 2 Aug 2017 04:45:36 -0400
Received: from relay.mailchannels.net (localhost [127.0.0.1])
        by relay.mailchannels.net (Postfix) with ESMTP id 2CDEA8A841F
        for <linux-btrfs@vger.kernel.org>; Wed,  2 Aug 2017 08:38:13 +0000 (UTC)
Received: from lnxwebr13.cpt.wa.co.za (unknown [100.96.142.242])
        (Authenticated sender: webafrica)
        by relay.mailchannels.net (Postfix) with ESMTPA id 474BC8A8E98
        for <linux-btrfs@vger.kernel.org>; Wed,  2 Aug 2017 08:38:11 +0000 (UTC)
Received: from [41.74.182.178] (port=54920 helo=tricky-laptop.valid.co.za)
        by lnxwebr13.cpt.wa.co.za with esmtpsa (TLSv1.2:ECDHE-RSA-AES128-GCM-SHA256:128)
        (Exim 4.89)
        (envelope-from <brendan@swiftspirit.co.za>)
        id 1dcpAN-003V9h-OB
        for linux-btrfs@vger.kernel.org; Wed, 02 Aug 2017 10:38:07 +0200
To: linux-btrfs@vger.kernel.org
From: Brendan Hide <brendan@swiftspirit.co.za>
Subject: RedHat 7.4 Release Notes: "Btrfs has been deprecated" - wut?
Message-ID: <84806456-eed9-00b9-b3f6-99e46cefba33@swiftspirit.co.za>
Date: Wed, 2 Aug 2017 10:38:07 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The title seems alarmist to me - and I suspect it is going to be 
misconstrued. :-/

 From the release notes at 
https://access.redhat.com/documentation/en-US/Red_Hat_Enterprise_Linux/7/html/7.4_Release_Notes/chap-Red_Hat_Enterprise_Linux-7.4_Release_Notes-Deprecated_Functionality.html

"Btrfs has been deprecated

The Btrfs file system has been in Technology Preview state since the 
initial release of Red Hat Enterprise Linux 6. Red Hat will not be 
moving Btrfs to a fully supported feature and it will be removed in a 
future major release of Red Hat Enterprise Linux.

The Btrfs file system did receive numerous updates from the upstream in 
Red Hat Enterprise Linux 7.4 and will remain available in the Red Hat 
Enterprise Linux 7 series. However, this is the last planned update to 
this feature.

Red Hat will continue to invest in future technologies to address the 
use cases of our customers, specifically those related to snapshots, 
compression, NVRAM, and ease of use. We encourage feedback through your 
Red Hat representative on features and requirements you have for file 
systems and storage technology."


