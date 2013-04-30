Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:50714 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752043Ab3D3FxN (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 30 Apr 2013 01:53:13 -0400
Message-ID: <517F5CD0.7050804@oracle.com>
Date: Tue, 30 Apr 2013 13:55:28 +0800
From: Anand Jain <Anand.Jain@oracle.com>
MIME-Version: 1.0
To: Josef Bacik <jbacik@fusionio.com>
CC: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] btrfs: device delete to get errors from the kernel
References: <517A4B44.5060608@oracle.com> <1366969275-3036-1-git-send-email-anand.jain@oracle.com> <1366969275-3036-2-git-send-email-anand.jain@oracle.com> <20130429191213.GB2580@localhost.localdomain>
In-Reply-To: <20130429191213.GB2580@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


>  If you want to make this give you more
> specific errors then adjust the errno's we send back and make the userspace util
> translate those to their appropriate error.  Thanks,

  Thats the approach #1 as listed before in this mail thread,
  let me give a try.

Anand

