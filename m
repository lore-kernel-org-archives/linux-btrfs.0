Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:38638 "EHLO
	relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754946Ab3C1LvW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 28 Mar 2013 07:51:22 -0400
Received: from mfilter25-d.gandi.net (mfilter25-d.gandi.net [217.70.178.153])
	by relay4-d.mail.gandi.net (Postfix) with ESMTP id 9E38617208B
	for <linux-btrfs@vger.kernel.org>; Thu, 28 Mar 2013 12:51:20 +0100 (CET)
Received: from relay4-d.mail.gandi.net ([217.70.183.196])
	by mfilter25-d.gandi.net (mfilter25-d.gandi.net [10.0.15.180]) (amavisd-new, port 10024)
	with ESMTP id qtSDBB6X+66L for <linux-btrfs@vger.kernel.org>;
	Thu, 28 Mar 2013 12:51:19 +0100 (CET)
Received: from [192.168.1.66] (AMontpellier-256-1-45-60.w90-28.abo.wanadoo.fr [90.28.12.60])
	(Authenticated sender: swami@petaramesh.org)
	by relay4-d.mail.gandi.net (Postfix) with ESMTPSA id 3F34F1720AC
	for <linux-btrfs@vger.kernel.org>; Thu, 28 Mar 2013 12:51:19 +0100 (CET)
Message-ID: <51542EB6.7030403@petaramesh.org>
Date: Thu, 28 Mar 2013 12:51:18 +0100
From: =?ISO-8859-1?Q?Sw=E2mi_Petaramesh?= <swami@petaramesh.org>
MIME-Version: 1.0
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: This time HD LED doesn't come up at all :-(
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

(Resending without the attachment which didn't seem to make it thru...)

Hi folks,

This time, at reboot, one of my machines won't come up.

Starting it in "single and verbose" mode shows that BTRFS looks dead (or
at least seriously wounded) :

Kernel seems to mount BTRFS, then swap, then sits there doing nothing
for quite a while (HD LED is OFF).

Then it starts spitting ugly messages about init being blocked for more
than 120 seconds, btrfs-cleaner (the same) etc. - please see attached
screenshot.

Any clue for getting out of this annoying situation without resorting to
reinstall from backups ?

TIA.

-- 
Swâmi Petaramesh <swami@petaramesh.org> http://petaramesh.org PGP 9076E32E



