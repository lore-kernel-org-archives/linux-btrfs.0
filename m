Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from torres.zugschlus.de ([85.214.131.164]:45902 "EHLO
	torres.zugschlus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752807AbcCGR1T (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 7 Mar 2016 12:27:19 -0500
Received: from mh by torres.zugschlus.de with local (Exim 4.84)
	(envelope-from <mh+linux-btrfs@zugschlus.de>)
	id 1acywA-0008U9-39
	for linux-btrfs@vger.kernel.org; Mon, 07 Mar 2016 18:27:18 +0100
Date: Mon, 7 Mar 2016 18:27:17 +0100
From: Marc Haber <mh+linux-btrfs@zugschlus.de>
To: linux-btrfs@vger.kernel.org
Subject: btrfs-image run time
Message-ID: <20160307172717.GJ6939@torres.zugschlus.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

how long is btrfs-image taking to run on a 400 GiB filesystem?

I have /bin/btrfs-image -s -t 8 -s /dev/mapper/mydevice - | pixz -9 >
file.on.other.fs running for four hours now, and it's constantly
taking a single core, but is neither reading from the disk nor writing
to its output.

Is that expeced behavior?

Greetings
Marc

-- 
-----------------------------------------------------------------------------
Marc Haber         | "I don't trust Computers. They | Mailadresse im Header
Leimen, Germany    |  lose things."    Winona Ryder | Fon: *49 6224 1600402
Nordisch by Nature |  How to make an American Quilt | Fax: *49 6224 1600421
