Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:24028 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754063AbaEIUXB (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 9 May 2014 16:23:01 -0400
Message-ID: <536D3922.4080102@redhat.com>
Date: Fri, 09 May 2014 15:22:58 -0500
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
To: Josef Bacik <jbacik@fb.com>, linux-btrfs@vger.kernel.org, xfs@oss.sgi.com
Subject: Re: [PATCH] xfstests: filter out selinux xattrs for generic/062
References: <1399664668-719-1-git-send-email-jbacik@fb.com> <536D37F6.90603@redhat.com> <536D38A6.9030107@fb.com>
In-Reply-To: <536D38A6.9030107@fb.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 5/9/14, 3:20 PM, Josef Bacik wrote:
> I have MOUNT_OPTIONS set to something else so I lose the context bit. Thanks,

Seems like we need to add to them, then, not overwrite them, for selinux?

Otherwise I imagine many other tests will fail.

-Eric
