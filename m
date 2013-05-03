Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from relay3.sgi.com ([192.48.152.1]:48622 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752315Ab3ECSVx (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 3 May 2013 14:21:53 -0400
Message-ID: <51840047.4020908@sgi.com>
Date: Fri, 3 May 2013 13:21:59 -0500
From: Rich Johnston <rjohnston@sgi.com>
MIME-Version: 1.0
To: Josef Bacik <jbacik@fusionio.com>
CC: <linux-btrfs@vger.kernel.org>, <xfs@oss.sgi.com>
Subject: Re: [PATCH] xfstests 311: test fsync with dm flakey V3
References: <1367003639-17621-1-git-send-email-jbacik@fusionio.com>
In-Reply-To: <1367003639-17621-1-git-send-email-jbacik@fusionio.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Thanks for another patch Josef, it has been committed with the change 
discussed.

--Rich

commit 2ca254dfddbbab8def35472b6ca39140400aff76
Author: Josef Bacik <jbacik@fusionio.com>
Date:   Fri Apr 26 19:13:59 2013 +0000

     xfstests 311: test fsync with dm flakey V3


