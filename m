Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:16912 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750911Ab3DOGmj (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 15 Apr 2013 02:42:39 -0400
Received: from ucsinet22.oracle.com (ucsinet22.oracle.com [156.151.31.94])
	by userp1040.oracle.com (Sentrion-MTA-4.3.1/Sentrion-MTA-4.3.1) with ESMTP id r3F6gc5S008035
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Mon, 15 Apr 2013 06:42:38 GMT
Received: from userz7021.oracle.com (userz7021.oracle.com [156.151.31.85])
	by ucsinet22.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id r3F6gb9I022048
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=FAIL)
	for <linux-btrfs@vger.kernel.org>; Mon, 15 Apr 2013 06:42:38 GMT
Received: from abhmt110.oracle.com (abhmt110.oracle.com [141.146.116.62])
	by userz7021.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id r3F6gbdj025336
	for <linux-btrfs@vger.kernel.org>; Mon, 15 Apr 2013 06:42:37 GMT
Message-ID: <516BA1C6.2040003@oracle.com>
Date: Mon, 15 Apr 2013 14:44:22 +0800
From: Anand Jain <Anand.Jain@oracle.com>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 02/11, v2] btrfs-progs: no pending balance is not an error
References: <1365141303-10571-1-git-send-email-anand.jain@oracle.com> <1366007897-26567-1-git-send-email-anand.jain@oracle.com> <1366007897-26567-3-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1366007897-26567-3-git-send-email-anand.jain@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



Oh. this title prefix should be v2 not RESEND.

v1->v2
  Accepts David review comments

Thanks,  Anand

On 04/15/2013 02:38 PM, Anand Jain wrote:
> Having no balance running/ paused/completed is a normal
> situation, so the current output message should be positive
> with return val zero.
>
> Signed-off-by: Anand Jain <anand.jain@oracle.com>
> ---
>   cmds-balance.c | 16 +++++++++++++---
>   1 file changed, 13 insertions(+), 3 deletions(-)
>
> diff --git a/cmds-balance.c b/cmds-balance.c
> index f5dc317..a968e0d 100644
> --- a/cmds-balance.c
> +++ b/cmds-balance.c
> @@ -616,6 +616,12 @@ static const char * const cmd_balance_status_usage[] = {
>   	NULL
>   };
>
> +/* Checks the status of the balance if any
> + * return codes:
> + *  -1 : Error failed to know if there is any pending balance
> + *   1 : Successful to know status of a pending balance
> + *   0 : When there is no pending balance or completed
> + */
>   static int cmd_balance_status(int argc, char **argv)
>   {
>   	struct btrfs_ioctl_balance_args args;
> @@ -662,9 +668,13 @@ static int cmd_balance_status(int argc, char **argv)
>   	close(fd);
>
>   	if (ret < 0) {
> +		if (e == ENOTCONN) {
> +			printf("No balance found on '%s'\n", path);
> +			return 0;
> +		}
>   		fprintf(stderr, "ERROR: balance status on '%s' failed - %s\n",
> -			path, (e == ENOTCONN) ? "Not in progress" : strerror(e));
> -		return 19;
> +			path, strerror(e));
> +		return -1;
>   	}
>
>   	if (args.state & BTRFS_BALANCE_STATE_RUNNING) {
> @@ -688,7 +698,7 @@ static int cmd_balance_status(int argc, char **argv)
>   	if (verbose)
>   		dump_ioctl_balance_args(&args);
>
> -	return 0;
> +	return 1;
>   }
>
>   const struct cmd_group balance_cmd_group = {
>
