Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:47140 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750936Ab3AVFl5 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 22 Jan 2013 00:41:57 -0500
Received: from ucsinet22.oracle.com (ucsinet22.oracle.com [156.151.31.94])
	by aserp1040.oracle.com (Sentrion-MTA-4.2.2/Sentrion-MTA-4.2.2) with ESMTP id r0M5fulJ023539
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Tue, 22 Jan 2013 05:41:57 GMT
Received: from acsmt357.oracle.com (acsmt357.oracle.com [141.146.40.157])
	by ucsinet22.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id r0M5ft0A019623
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Tue, 22 Jan 2013 05:41:56 GMT
Received: from abhmt104.oracle.com (abhmt104.oracle.com [141.146.116.56])
	by acsmt357.oracle.com (8.12.11.20060308/8.12.11) with ESMTP id r0M5ftPo027684
	for <linux-btrfs@vger.kernel.org>; Mon, 21 Jan 2013 23:41:55 -0600
Message-ID: <50FE26A3.5000405@oracle.com>
Date: Tue, 22 Jan 2013 13:41:55 +0800
From: XU Simon <xu.simon@oracle.com>
MIME-Version: 1.0
To: Simon Xu <xu.simon@oracle.com>
CC: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH V2] btrfs-progs: remove "device show" from btrfs man page
References: <50ED18C5.8000107@oracle.com> <1357716667-1673-1-git-send-email-xu.simon@oracle.com>
In-Reply-To: <1357716667-1673-1-git-send-email-xu.simon@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Add SOB line:

Signed-off-by: Simon Xu <xu.simon@oracle.com>

Thanks David for pointing this out.

Simon

On 2013/1/9 15:31, Simon Xu wrote:
> Remove "device show" from btrfs man page as it's not supported by the
> btrfs utility.
> ---
>   man/btrfs.8.in | 2 --
>   1 file changed, 2 deletions(-)
>
> diff --git a/man/btrfs.8.in b/man/btrfs.8.in
> index 9222580..e663da2 100644
> --- a/man/btrfs.8.in
> +++ b/man/btrfs.8.in
> @@ -33,8 +33,6 @@ btrfs \- control a btrfs filesystem
>   .PP
>   \fBbtrfs\fP \fBdevice scan\fP\fI [--all-devices|<device> [<device>...]]\fP
>   .PP
> -\fBbtrfs\fP \fBdevice show\fP\fI [--all-devices|<uuid>|<label>]\fP
> -.PP
>   \fBbtrfs\fP \fBdevice add\fP\fI <device> [<device>...] <path> \fP
>   .PP
>   \fBbtrfs\fP \fBdevice delete\fP\fI <device> [<device>...] <path> \fP
