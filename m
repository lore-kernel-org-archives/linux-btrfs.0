Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:30953 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752137Ab3DPFBC (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 16 Apr 2013 01:01:02 -0400
Message-ID: <516CDB4B.9080609@oracle.com>
Date: Tue, 16 Apr 2013 13:02:03 +0800
From: Anand Jain <Anand.Jain@oracle.com>
MIME-Version: 1.0
To: dsterba@suse.cz
CC: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH 02/11, RESEND] btrfs-progs: no pending balance is not
 an error
References: <1365141303-10571-1-git-send-email-anand.jain@oracle.com> <1366007897-26567-1-git-send-email-anand.jain@oracle.com> <1366007897-26567-3-git-send-email-anand.jain@oracle.com> <20130415162127.GE18193@twin.jikos.cz>
In-Reply-To: <20130415162127.GE18193@twin.jikos.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>




On 04/16/2013 12:21 AM, David Sterba wrote:
> On Mon, Apr 15, 2013 at 02:38:08PM +0800, Anand Jain wrote:
>> +/* Checks the status of the balance if any
>> + * return codes:
>> + *  -1 : Error failed to know if there is any pending balance
>> + *   1 : Successful to know status of a pending balance
>> + *   0 : When there is no pending balance or completed
>
> The error code will become the return code of the 'btrfs balance status'
> command in the end:
>
> btrfs.c:main()
>
> 295         exit(cmd->fn(argc, argv));
>
> and that's why I've suggested to return 1 or 2, though -1 matches shell
> error code 255 but I'd rathe avoid using it.

   makes sense.  v3 is out.
