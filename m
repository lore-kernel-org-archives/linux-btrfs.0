Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:4256 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757802Ab3DCQET (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 3 Apr 2013 12:04:19 -0400
Received: from int-mx10.intmail.prod.int.phx2.redhat.com (int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r33G4JxD012884
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Wed, 3 Apr 2013 12:04:19 -0400
Date: Wed, 3 Apr 2013 09:04:18 -0700
From: Zach Brown <zab@redhat.com>
To: Eric Sandeen <sandeen@redhat.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: abort unlink trans in missed error case
Message-ID: <20130403160418.GG2850@lenny.home.zabbo.net>
References: <1364936536-13130-1-git-send-email-zab@redhat.com>
 <515C3E50.60807@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <515C3E50.60807@redhat.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

> 
> I was wondering if the transaction support should just be in the
> err: goto case, and went looking.

Yeah, it's tempting. In the end I decided against it because this
shouldn't be so willing to freak out and make the file system read only.
It should try and undo the partial unlink and if *that* fails it should
go read only. I went for the minimal fix for now.

> I'm not familiar enough with this stuff yet, but what if i.e.
> btrfs_delete_one_dir_name fails, should that also abort the
> transaction?

It doesn't abort because its the first thing that can fail.  It can
cleanly return an error without leaving partial state around.

- z
