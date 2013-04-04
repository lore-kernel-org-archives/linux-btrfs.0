Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:49550 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764658Ab3DDTu0 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 4 Apr 2013 15:50:26 -0400
Received: from int-mx02.intmail.prod.int.phx2.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r34JoPTT008698
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Thu, 4 Apr 2013 15:50:25 -0400
Date: Thu, 4 Apr 2013 12:50:21 -0700
From: Zach Brown <zab@redhat.com>
To: Eric Sandeen <sandeen@redhat.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>,
        Jan Safranek <jsafrane@redhat.com>
Subject: Re: [PATCH V2] btrfs: close any open devices if btrfs_mount fails
Message-ID: <20130404195021.GB23636@lenny.home.zabbo.net>
References: <515D9DDE.5040306@redhat.com>
 <515DAB1F.2050308@redhat.com>
 <20130404184632.GA23636@lenny.home.zabbo.net>
 <515DD858.4000102@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <515DD858.4000102@redhat.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

> I guess I had a feeling that in something like a degraded mount scenario
> you might live with failures.  But I guess that is initiated on the mount
> commandline, i.e. "mount this subset; it's degraded" not "mount these devices,
> and if some fail that's cool."
> 
> Right?

Maybe?  Who knows.

- z
