Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:17657 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757167Ab3AIHOW (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 9 Jan 2013 02:14:22 -0500
Received: from ucsinet21.oracle.com (ucsinet21.oracle.com [156.151.31.93])
	by userp1040.oracle.com (Sentrion-MTA-4.2.2/Sentrion-MTA-4.2.2) with ESMTP id r097ELqs015597
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Wed, 9 Jan 2013 07:14:22 GMT
Received: from acsmt356.oracle.com (acsmt356.oracle.com [141.146.40.156])
	by ucsinet21.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id r097EKA9022080
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Wed, 9 Jan 2013 07:14:21 GMT
Received: from abhmt105.oracle.com (abhmt105.oracle.com [141.146.116.57])
	by acsmt356.oracle.com (8.12.11.20060308/8.12.11) with ESMTP id r097EJPI002587
	for <linux-btrfs@vger.kernel.org>; Wed, 9 Jan 2013 01:14:19 -0600
Message-ID: <50ED18C5.8000107@oracle.com>
Date: Wed, 09 Jan 2013 15:14:13 +0800
From: Jeff Liu <jeff.liu@oracle.com>
MIME-Version: 1.0
To: Simon Xu <xu.simon@oracle.com>
CC: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] remove "device show" from btrfs man page
References: <1357713972-1581-1-git-send-email-xu.simon@oracle.com>
In-Reply-To: <1357713972-1581-1-git-send-email-xu.simon@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Simon,

For the next time when you post btrfs-progs related patches, please
indicate it with a suffix "Btrfs-progs: " on the subject.

Thanks,
-Jeff
On 01/09/2013 02:46 PM, Simon Xu wrote:
> Remove "device show" from btrfs man page as it's not supported by the
> btrfs utility.
> ---
>  man/btrfs.8.in | 2 --
>  1 file changed, 2 deletions(-)
> 
> diff --git a/man/btrfs.8.in b/man/btrfs.8.in
> index 9222580..e663da2 100644
> --- a/man/btrfs.8.in
> +++ b/man/btrfs.8.in
> @@ -33,8 +33,6 @@ btrfs \- control a btrfs filesystem
>  .PP
>  \fBbtrfs\fP \fBdevice scan\fP\fI [--all-devices|<device> [<device>...]]\fP
>  .PP
> -\fBbtrfs\fP \fBdevice show\fP\fI [--all-devices|<uuid>|<label>]\fP
> -.PP
>  \fBbtrfs\fP \fBdevice add\fP\fI <device> [<device>...] <path> \fP
>  .PP
>  \fBbtrfs\fP \fBdevice delete\fP\fI <device> [<device>...] <path> \fP
> 

