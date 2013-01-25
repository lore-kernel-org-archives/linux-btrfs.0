Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:28066 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754683Ab3AYJPS (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 25 Jan 2013 04:15:18 -0500
Message-ID: <51024E9D.4070402@oracle.com>
Date: Fri, 25 Jan 2013 17:21:33 +0800
From: Anand Jain <Anand.Jain@oracle.com>
MIME-Version: 1.0
To: Eric Sandeen <sandeen@redhat.com>
CC: linux-btrfs@vger.kernel.org, dsterba@suse.cz, gene@czarc.net
Subject: Re: [PATCH 01/10] Btrfs-progs: move open_file_or_dir() to utils.c
References: <1358928771-31960-1-git-send-email-anand.jain@oracle.com> <1358928771-31960-2-git-send-email-anand.jain@oracle.com> <5100BB01.3030408@redhat.com>
In-Reply-To: <5100BB01.3030408@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



> Cool, I had this on my stack too.  But can you maybe remove the
> nonsensical return values, and instead of renaming & keeping the btrfsctl.c
> copy, why not just use a common copy in utils.c?  It'd just be 2 checks
> for fd < 0 in the btrfsctl callers.

  Thanks for the comments Eric. Though I agree, but it deviates
  from the purpose of this patch-set. It could be taken as a
  separate patch.

Anand
