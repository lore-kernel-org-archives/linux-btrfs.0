Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:58130 "EHLO
	relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752986Ab3B1Ofc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 28 Feb 2013 09:35:32 -0500
Received: from mfilter11-d.gandi.net (mfilter11-d.gandi.net [217.70.178.131])
	by relay4-d.mail.gandi.net (Postfix) with ESMTP id AEC14172085
	for <linux-btrfs@vger.kernel.org>; Thu, 28 Feb 2013 15:35:30 +0100 (CET)
Received: from relay4-d.mail.gandi.net ([217.70.183.196])
	by mfilter11-d.gandi.net (mfilter11-d.gandi.net [10.0.15.180]) (amavisd-new, port 10024)
	with ESMTP id j08sW9pgIvAx for <linux-btrfs@vger.kernel.org>;
	Thu, 28 Feb 2013 15:35:29 +0100 (CET)
Received: from [192.168.1.66] (AMontpellier-256-1-187-75.w92-143.abo.wanadoo.fr [92.143.82.75])
	(Authenticated sender: swami@petaramesh.org)
	by relay4-d.mail.gandi.net (Postfix) with ESMTPSA id 4D4201720AF
	for <linux-btrfs@vger.kernel.org>; Thu, 28 Feb 2013 15:35:29 +0100 (CET)
Message-ID: <512F6B30.1060409@petaramesh.org>
Date: Thu, 28 Feb 2013 15:35:28 +0100
From: =?ISO-8859-1?Q?Sw=E2mi_Petaramesh?= <swami@petaramesh.org>
MIME-Version: 1.0
To: "BTRFS, Linux" <linux-btrfs@vger.kernel.org>
Subject: Does defragmenting even work
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

BTW...

I'm not even sure that "btrfs filesystem defrag <somefile>" actually
does anything...

If I run "filefrag <somefile>" afterwards, it typically shows the same
number of fragments that it did prior to running defrag...

I'm not sure about how it actually works and what I should expect...

-- 
Swâmi Petaramesh <swami@petaramesh.org> http://petaramesh.org PGP 9076E32E
Ne cherchez pas : Je ne suis pas sur Facebook.

