Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from acsinet15.oracle.com ([141.146.126.227]:38232 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753465Ab2IXC5C (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 23 Sep 2012 22:57:02 -0400
Message-ID: <505FCC96.8030703@oracle.com>
Date: Mon, 24 Sep 2012 10:59:34 +0800
From: Anand Jain <Anand.Jain@oracle.com>
MIME-Version: 1.0
To: dave@jikos.cz
CC: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs-progs: btrfs subvolume delete could delete subvolumes
References: <1348210448-29616-1-git-send-email-Anand.Jain@oracle.com> <20120921152051.GU17430@twin.jikos.cz>
In-Reply-To: <20120921152051.GU17430@twin.jikos.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


David,

  Thanks for the comments.

 > Yes, this is useful, thanks. I'm thinking if it's ok to stop on
 > first error, ie. when the subvolume does not exist or is a directory.

  I am fine with either ways. I shall just keep it as it is as of now.

-Anand
