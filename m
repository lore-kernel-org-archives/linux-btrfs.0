Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from koch.ro ([88.198.2.104]:57750 "EHLO koch.ro"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754502Ab3HXQKJ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 24 Aug 2013 12:10:09 -0400
Received: from 44-25.106-92.cust.bluewin.ch ([92.106.25.44] helo=x121eofhwr1202.localnet)
	by koch.ro with esmtpsa (TLS1.0:DHE_RSA_AES_256_CBC_SHA1:256)
	(Exim 4.80)
	(envelope-from <thomas@koch.ro>)
	id 1VDGPc-0004ui-6L
	for linux-btrfs@vger.kernel.org; Sat, 24 Aug 2013 18:10:04 +0200
From: Thomas Koch <thomas@koch.ro>
To: linux-btrfs@vger.kernel.org
Subject: check for reflink capability and for shared data
Date: Sat, 24 Aug 2013 18:09:58 +0200
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <201308241809.58701.thomas@koch.ro>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

how can I do the following in a shell script:

- check whether my file system supports cp --reflink?
- check whether two files share the same data on disk, i.e. one has been 
created by cp --reflink of the other?

Thank you!

Thomas Koch
