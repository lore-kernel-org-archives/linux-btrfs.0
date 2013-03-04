Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:32332 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758903Ab3CDWe4 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 4 Mar 2013 17:34:56 -0500
Received: from int-mx09.intmail.prod.int.phx2.redhat.com (int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r24MYung029603
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Mon, 4 Mar 2013 17:34:56 -0500
Message-ID: <5135218F.40803@redhat.com>
Date: Mon, 04 Mar 2013 16:34:55 -0600
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
To: Zach Brown <zab@redhat.com>
CC: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 12/14] btrfs-progs: Issue warnings if ioctls fail in sigint
 handlers
References: <1362436804-16766-1-git-send-email-sandeen@redhat.com> <1362436804-16766-13-git-send-email-sandeen@redhat.com> <20130304215736.GB1658@lenny.home.zabbo.net>
In-Reply-To: <20130304215736.GB1658@lenny.home.zabbo.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 3/4/13 3:57 PM, Zach Brown wrote:
>> +	ret = ioctl(cancel_fd, BTRFS_IOC_SCRUB_CANCEL, NULL);
>> +	if (ret < 0)
>> +		perror("Scrub cancel failed\n");
> 
> Probably don't want the extra newline.
> 
> - z
> 

Doh, thanks.
