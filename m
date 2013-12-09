Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from nm7-vm5.access.bullet.mail.gq1.yahoo.com ([216.39.63.125]:20744
	"HELO nm7-vm5.access.bullet.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753229Ab3LIUCE convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 9 Dec 2013 15:02:04 -0500
References: <1386615086.1044.YahooMailNeo@web180901.mail.ne1.yahoo.com>
Message-ID: <1386619322.61331.YahooMailNeo@web180902.mail.ne1.yahoo.com>
Date: Mon, 9 Dec 2013 12:02:02 -0800 (PST)
From: Cirillo Costantino <linoc@pacbell.net>
Reply-To: Cirillo Costantino <linoc@pacbell.net>
Subject: Btrfs questions
To: "\"linux-btrfs@vger.kernel.org\"" <linux-btrfs@vger.kernel.org>
In-Reply-To: <1386615086.1044.YahooMailNeo@web180901.mail.ne1.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



i am looking at using btrfs for a new project and i have a few questions:

    * i have heard that as it currently stands Btrfs has some issues to be used as a Lustre file system; is he aware of the issues and any plans to address these and integrate Btrfs in to Lustre
    * any plans to support native clustering on Btrfs
    * on ZFS the ZIL is a separate device, any plans to implement a the B-Tree log on a separate device?
    * any plans to allow to have a file system metadata be placed on a separate device
thanks
lino
