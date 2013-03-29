Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:35886 "EHLO
	relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751167Ab3C2JuU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 29 Mar 2013 05:50:20 -0400
Received: from mfilter12-d.gandi.net (mfilter12-d.gandi.net [217.70.178.129])
	by relay3-d.mail.gandi.net (Postfix) with ESMTP id 75718A80FF
	for <linux-btrfs@vger.kernel.org>; Fri, 29 Mar 2013 10:50:18 +0100 (CET)
Received: from relay3-d.mail.gandi.net ([217.70.183.195])
	by mfilter12-d.gandi.net (mfilter12-d.gandi.net [10.0.15.180]) (amavisd-new, port 10024)
	with ESMTP id ZmNNwASx3jeF for <linux-btrfs@vger.kernel.org>;
	Fri, 29 Mar 2013 10:50:17 +0100 (CET)
Received: from [192.168.1.66] (AMontpellier-256-1-45-60.w90-28.abo.wanadoo.fr [90.28.12.60])
	(Authenticated sender: swami@petaramesh.org)
	by relay3-d.mail.gandi.net (Postfix) with ESMTPSA id BB873A80D7
	for <linux-btrfs@vger.kernel.org>; Fri, 29 Mar 2013 10:50:16 +0100 (CET)
Message-ID: <515563D7.3020706@petaramesh.org>
Date: Fri, 29 Mar 2013 10:50:15 +0100
From: =?ISO-8859-1?Q?Sw=E2mi_Petaramesh?= <swami@petaramesh.org>
MIME-Version: 1.0
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: scrub "correcting" tons of errors ?
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi there,

I've started "btrfs scrub start /" on one of my machines (Kernel
3.8.0-15 Ubuntu AMD64), which typically "behaves well" so I wasn't
suspected any disk issue.

After having ran for only 165 seconds, "scrub status" shows it pretends
having found and corrected 22926 CSUM errors ??!?!?!?!!???

This is a rather new HDD, in perfect shape (SMART all OK, never
reallocated a single sector, less than 200 hours total runtime...)

WTF ?!?

I've cancelled scrub for now, until I get further understanding of what
can be happening...

-- 
Swâmi Petaramesh <swami@petaramesh.org> http://petaramesh.org PGP 9076E32E
Ne cherchez pas : Je ne suis pas sur Facebook.

