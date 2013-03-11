Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:42129 "EHLO
	relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752501Ab3CKK0t convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 11 Mar 2013 06:26:49 -0400
Received: from mfilter18-d.gandi.net (mfilter18-d.gandi.net [217.70.178.146])
	by relay3-d.mail.gandi.net (Postfix) with ESMTP id E1A7DA80C6
	for <linux-btrfs@vger.kernel.org>; Mon, 11 Mar 2013 11:26:47 +0100 (CET)
Received: from relay3-d.mail.gandi.net ([217.70.183.195])
	by mfilter18-d.gandi.net (mfilter18-d.gandi.net [10.0.15.180]) (amavisd-new, port 10024)
	with ESMTP id 4sRLcxLqzXcp for <linux-btrfs@vger.kernel.org>;
	Mon, 11 Mar 2013 11:26:46 +0100 (CET)
Received: from [192.168.1.66] (AMontpellier-256-1-185-24.w92-143.abo.wanadoo.fr [92.143.80.24])
	(Authenticated sender: swami@petaramesh.org)
	by relay3-d.mail.gandi.net (Postfix) with ESMTPSA id 754F4A8125
	for <linux-btrfs@vger.kernel.org>; Mon, 11 Mar 2013 11:26:46 +0100 (CET)
Message-ID: <513DB161.4050205@petaramesh.org>
Date: Mon, 11 Mar 2013 11:26:41 +0100
From: =?ISO-8859-1?Q?Sw=E2mi_Petaramesh?= <swami@petaramesh.org>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: BTRFS and "ionice"
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

I use "ionice -c 3 <command>" to run some low-priority background tasks
(i.e. tar, big file copies, or performing checksums sur very big files)
using the disk "only when idle", which would be supposed to have very
little impact on my system performance meanwhile.

I can be pretty sure that those tasks are I/O-bound and use very little
CPU (and they are niced as well, anyway).

However, when such tasks are running my BTRFS system slows down to a
crawl, becomes very very unresponsive, and it seems to me that disk I/O
is completely saturated (LED is fixed lit...)

So I wonder if BTRFS correctly support ionice, or if it's plain useless ?

TIA

Kind regards.

-- 
Swâmi Petaramesh <swami@petaramesh.org> http://petaramesh.org PGP 9076E32E
Ne cherchez pas : Je ne suis pas sur Facebook.

