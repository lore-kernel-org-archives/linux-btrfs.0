Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from relay1.sgi.com ([192.48.179.29]:39632 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752822Ab3HPOL3 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 16 Aug 2013 10:11:29 -0400
Message-ID: <520E3339.7020508@sgi.com>
Date: Fri, 16 Aug 2013 09:12:09 -0500
From: Rich Johnston <rjohnston@sgi.com>
MIME-Version: 1.0
To: Josef Bacik <jbacik@fusionio.com>
CC: <linux-btrfs@vger.kernel.org>, <xfs@oss.sgi.com>
Subject: Re: xfstests: make the scratch device for generic/256 slightly larger
References: <1372792638-23957-1-git-send-email-jbacik@fusionio.com>
In-Reply-To: <1372792638-23957-1-git-send-email-jbacik@fusionio.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hey Josef,

Sorry this took so long to commit, I did not see it had been reviewed.

Thanks again for the patch
--Rich

commit 617491caf44d5e93006d774da95f532e9d7de4c4
Author: Josef Bacik <jbacik@fusionio.com>
Date:   Tue Jul 2 19:17:18 2013 +0000

