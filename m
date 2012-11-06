Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from loup.kjorling.se ([87.237.208.114]:47178 "EHLO loup.kjorling.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750846Ab2KFMdf (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 6 Nov 2012 07:33:35 -0500
Received: from yeono.kjorling.se (c-1717e655.6036809--62697410.cust.bredbandsbolaget.se [85.230.23.23])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(Client CN "yeono", Issuer "yeono" (not verified))
	by loup.kjorling.se (Postfix) with ESMTPS id 960E810A5C00A
	for <linux-btrfs@vger.kernel.org>; Tue,  6 Nov 2012 12:33:09 +0000 (UTC)
Received: from yeono.kjorling.se (localhost [127.0.0.1])
	(using TLSv1 with cipher DHE-RSA-AES128-SHA (128/128 bits))
	(Client did not present a certificate)
	by yeono (Postfix) with ESMTPS id 316BF47E24B
	for <linux-btrfs@vger.kernel.org>; Tue,  6 Nov 2012 13:33:09 +0100 (CET)
Date: Tue, 6 Nov 2012 12:33:08 +0000
From: Michael =?utf-8?B?S2rDtnJsaW5n?= <michael@kjorling.se>
To: linux-btrfs@vger.kernel.org
Subject: How does btrfs handle sudden shutdowns?
Message-ID: <20121106123308.GA2676@yeono.kjorling.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Can btrfs deal reasonably gracefully with sudden shutdowns? (I'm
mainly thinking of power outages which lead to logical structure
damage but not physical media damage.)

What would be the risk points, file-system-wise?

Can for example a rotating snapshot schedule mitigate some or all
issues relating to sudden shutdowns, if any? (_For example_, take a
snapshot every minute, keeping the last five; if the main file system
fails to mount, then could the most recent usable snapshot be used as
a fallback, or is it likely to be equally damaged or inconsistent?)

Obviously a UPS or other form of fallback power is preferable to no
UPS if power outages are a concern, so as to allow a controlled system
shutdown (or fail-over to a more long-term backup power supply) in the
event of a prolonged power outage, but I'm wondering about situations
where such don't exist or even fail.

-- 
Michael Kjörling • http://michael.kjorling.se • michael@kjorling.se
                “People who think they know everything really annoy
                those of us who know we don’t.” (Bjarne Stroustrup)
