Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:29371 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751973Ab3HTGL1 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 20 Aug 2013 02:11:27 -0400
Message-ID: <52130A07.1000001@oracle.com>
Date: Tue, 20 Aug 2013 14:17:43 +0800
From: Anand Jain <Anand.Jain@oracle.com>
MIME-Version: 1.0
To: Zach Brown <zab@redhat.com>
CC: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 1/3] btrfs-progs: move out print in cmd_df to another
 function
In-Reply-To: <20130819192052.GA1829@lenny.home.zabbo.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>
References: <1376657303-14931-1-git-send-email-anand.jain@oracle.com>
 <1376657303-14931-2-git-send-email-anand.jain@oracle.com>
 <20130819192052.GA1829@lenny.home.zabbo.net>



> This seems to be a whole lot of code for a simple iterating printf:
>
> 	struct space_type_thingy_whatver *sp = sargs->spaces;
>
> 	for (i = 0; i < sargs->total_spaces; i++, sp++) {
> 		printf("%s, %s: total=%s, used=%s\n",
> 			group_type_str(sp->flags),
> 			group_profile_str(sp->flags),
> 			pretty_size(sp->total_bytes),
> 			pretty_size(sp->used_bytes));
> 	}
>
> - z


  Thanks for the review. Sent v3 for this.

Anand
