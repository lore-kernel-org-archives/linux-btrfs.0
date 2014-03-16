Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:51743 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753833AbaCPQHQ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 16 Mar 2014 12:07:16 -0400
To: Chris Samuel <chris@csamuel.org>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: discard synchronous on most SSDs?
From: "Martin K. Petersen" <martin.petersen@oracle.com>
References: <531C1CC4.701@gmail.com> <20140314051750.GY6143@merlins.org>
	<5289248.oqpgSKG6td@quad> <1908923.tvpl1fFKJ5@quad>
Date: Sun, 16 Mar 2014 12:07:10 -0400
In-Reply-To: <1908923.tvpl1fFKJ5@quad> (Chris Samuel's message of "Sat, 15 Mar
	2014 15:06:25 +1100")
Message-ID: <yq1eh22w2j5.fsf@sermon.lab.mkp.net>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

>>>>> "Chris" == Chris Samuel <chris@csamuel.org> writes:

Chris> SATA Version is: SATA 3.0, 6.0 Gb/s (current: 6.0 Gb/s)

Chris> Of course that's what the drive is reporting it supports, I'm not
Chris> sure whether that's the result of what has been negotiated
Chris> between the controller and drive or purely what the drive
Chris> supports.

It just what the drive reports. Often drives will implement features
before they are ratified in the spec and thus before they can claim
compliance with a specific version.

-- 
Martin K. Petersen	Oracle Linux Engineering
