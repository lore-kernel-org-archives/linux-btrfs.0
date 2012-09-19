Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:42947 "EHLO
	relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751100Ab2ISIGB (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 19 Sep 2012 04:06:01 -0400
Received: from mfilter13-d.gandi.net (mfilter13-d.gandi.net [217.70.178.141])
	by relay3-d.mail.gandi.net (Postfix) with ESMTP id 4180BA80D5
	for <linux-btrfs@vger.kernel.org>; Wed, 19 Sep 2012 10:05:59 +0200 (CEST)
Received: from relay3-d.mail.gandi.net ([217.70.183.195])
	by mfilter13-d.gandi.net (mfilter13-d.gandi.net [10.0.15.180]) (amavisd-new, port 10024)
	with ESMTP id tKb30jKn+j5N for <linux-btrfs@vger.kernel.org>;
	Wed, 19 Sep 2012 10:05:57 +0200 (CEST)
Received: from [192.168.1.66] (AMontpellier-156-1-36-171.w90-0.abo.wanadoo.fr [90.0.67.171])
	(Authenticated sender: swami@petaramesh.org)
	by relay3-d.mail.gandi.net (Postfix) with ESMTPSA id 49541A807A
	for <linux-btrfs@vger.kernel.org>; Wed, 19 Sep 2012 10:05:52 +0200 (CEST)
Message-ID: <50597CD5.5060001@petaramesh.org>
Date: Wed, 19 Sep 2012 10:05:41 +0200
From: =?ISO-8859-1?Q?Sw=E2mi_Petaramesh?= <swami@petaramesh.org>
MIME-Version: 1.0
To: Linux Btrfs <linux-btrfs@vger.kernel.org>
Subject: "free space cache generation" ?
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi there,

I noticed my syslog is filling up with tons of:

btrfs: free space inode generation (0) did not match free space cache 
generation (25326)

...any clue ?

TIA.
