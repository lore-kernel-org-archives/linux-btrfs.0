Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:23791 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758603Ab3CDV5h (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 4 Mar 2013 16:57:37 -0500
Received: from int-mx10.intmail.prod.int.phx2.redhat.com (int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r24LvaEH008099
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Mon, 4 Mar 2013 16:57:37 -0500
Date: Mon, 4 Mar 2013 13:57:36 -0800
From: Zach Brown <zab@redhat.com>
To: Eric Sandeen <sandeen@redhat.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 12/14] btrfs-progs: Issue warnings if ioctls fail in
 sigint handlers
Message-ID: <20130304215736.GB1658@lenny.home.zabbo.net>
References: <1362436804-16766-1-git-send-email-sandeen@redhat.com>
 <1362436804-16766-13-git-send-email-sandeen@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1362436804-16766-13-git-send-email-sandeen@redhat.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

> +	ret = ioctl(cancel_fd, BTRFS_IOC_SCRUB_CANCEL, NULL);
> +	if (ret < 0)
> +		perror("Scrub cancel failed\n");

Probably don't want the extra newline.

- z
