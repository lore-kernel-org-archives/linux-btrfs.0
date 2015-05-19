Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:13443 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751411AbbESUfR (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 19 May 2015 16:35:17 -0400
Message-ID: <555B9E7B.8070109@fb.com>
Date: Tue, 19 May 2015 16:35:07 -0400
From: Josef Bacik <jbacik@fb.com>
MIME-Version: 1.0
To: Mark Fasheh <mfasheh@suse.de>, <linux-btrfs@vger.kernel.org>
CC: Chris Mason <clm@fb.com>
Subject: Re: [PATCH][RESEND] btrfs: clear 'ret' in btrfs_check_shared() loop
References: <20150519194950.GE18148@wotan.suse.de>
In-Reply-To: <20150519194950.GE18148@wotan.suse.de>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 05/19/2015 03:49 PM, Mark Fasheh wrote:
> btrfs_check_shared() is leaking a return value of '1' from
> find_parent_nodes(). As a result, callers (in this case, extent_fiemap())
> are told extents are shared when they are not. This in turn broke fiemap on
> btrfs for kernels v3.18 and up.
>
> The fix is simple - we just have to clear 'ret' after we are done processing
> the results of find_parent_nodes().
>
> It wasn't clear to me at first what was happening with return values in
> btrfs_check_shared() and find_parent_nodes() - thanks to Josef for the help
> on irc. I added documentation to both functions to make things more clear
> for the next hacker who might come across them.
>
> If we could queue this up for -stable too that would be great.
>
> Signed-off-by: Mark Fasheh <mfasheh@suse.de>

Reviewed-by: Josef Bacik <jbacik@fb.com>

Thanks,

Josef
