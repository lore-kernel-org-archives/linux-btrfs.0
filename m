Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.22]:62571 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751732AbaKDLny (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 4 Nov 2014 06:43:54 -0500
MIME-Version: 1.0
Message-ID: <trinity-cc1b2a23-4887-4c5c-8007-327e2a9d3a60-1415101432282@msvc024>
From: stephan008@gmx.com
To: linux-btrfs@vger.kernel.org
Subject: BTRFS Quota Display Tool
Content-Type: text/plain; charset=UTF-8
Date: Tue, 4 Nov 2014 12:43:52 +0100
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello

I looking for a web based tool for displaying quotas for btrfs volumes. Something which get's it's data from btrfsQuota.py and displays nice bars on a webfrontend so we can see how much space a user is consuming right now. 

Although btrfs is not supporting per user based quotas, we made a workaround for this to separate 1 users files into 1 subvolume. This way his quota can be determined.

A lot of additional features would come handy, such as email notification when a user gets near to his Quota limit or another notification when he hits it. 
On some of our hosting deployments, this is taken care of nicely by ISPconfig (Hard/Soft limits can be easily configured on the controlpanel), repquota (Display quota usage statistics from command line) and warnquota (Able to generate the email alerts what I have mentioned).

Please if you know any existing (preferrably PHP based) framework for this let me know, so I wouldn't have to develop it from scratch.

Thanks
