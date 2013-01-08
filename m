Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:5871 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756140Ab3AHTvm (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 8 Jan 2013 14:51:42 -0500
Received: from int-mx01.intmail.prod.int.phx2.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r08Jpg5Q024352
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Tue, 8 Jan 2013 14:51:42 -0500
Date: Tue, 8 Jan 2013 11:51:41 -0800
From: Zach Brown <zab@redhat.com>
To: Eric Sandeen <sandeen@redhat.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: fix btrfs_cont_expand() freeing IS_ERR em
Message-ID: <20130108195141.GC12288@lenny.home.zabbo.net>
References: <1357673878-25591-1-git-send-email-zab@redhat.com>
 <50EC77B0.3050400@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <50EC77B0.3050400@redhat.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

> Looks good (maybe IS_ERR_OR_NULL would be more future-proof, but *shrug*)

Yeah.  I don't feel strongly about it.  I'm happy to do that, and dance
around the tree pulling out redundant 'em = NULL' bits that wouldn't be
needed, if anyone feels strongly about it.

- z
(*shrug*)
