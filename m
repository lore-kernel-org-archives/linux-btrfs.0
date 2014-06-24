Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.17.24]:57279 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751242AbaFXHuz (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 24 Jun 2014 03:50:55 -0400
Message-ID: <1403596252.4221.9.camel@hsew-frn.HIPERSCAN>
Subject: cancel btrfs delete job
From: Franziska =?ISO-8859-1?Q?N=E4pelt?=
	<franziska.naepelt@hiperscan.com>
Reply-To: franziska.naepelt@hiperscan.com
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Date: Tue, 24 Jun 2014 09:50:52 +0200
Content-Type: text/plain; charset="ISO-8859-15"
Mime-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

i want to expand a btrfs filesystem. In the moment I have four 2 TB HDDs
for one btrfs pool.
I want to replace two of the HDDs with 3 TB devices. For this reason i
added as first one 3 TB device. After that, i do the btrfs delete job.
This job lasts since 4 days and it seems, that it hangs.

Is it possible to cancel a btrfs delete job?
And when so, how can i do that?

Best regards,
Franziska



