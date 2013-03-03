Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from fw10a-124.wadns.net ([196.220.39.124]:40066 "EHLO
	fw10a.wadns.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753721Ab3CCQsE (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 3 Mar 2013 11:48:04 -0500
Message-ID: <51337EB2.7090607@swiftspirit.co.za>
Date: Sun, 03 Mar 2013 18:47:46 +0200
From: Brendan Hide <brendan@swiftspirit.co.za>
MIME-Version: 1.0
To: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
CC: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v3] Btrfs-progs: check out if the swap device
References: <201302140753.AA00021@FM-323941448.jp.fujitsu.com>
In-Reply-To: <201302140753.AA00021@FM-323941448.jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2013/02/14 09:53 AM, Tsutomu Itoh wrote:
> +		if (ret < 0) {
> +			fprintf(stderr, "error checking %s status: %s\n", file,
> +				strerror(-ret));
> +			exit(1);
> +		}
>
> ...
>
> +		/* check if the device is busy */
> +		fd = open(file, O_RDWR|O_EXCL);
> +		if (fd < 0) {
> +			fprintf(stderr, "unable to open %s: %s\n", file,
> +				strerror(errno));
> +			exit(1);
> +		}
This is fine and works (as tested by David) - but I'm not sure if the 
below suggestions from Zach were taken into account.

1. If the check with "open(file, O_RDWR|O_EXCL)" shows that the device 
is available, there's no point in checking if it is mounted as a swap 
device. A preliminary check using this could precede all other checks 
which should be skipped if it shows success.

2. If there's an error checking the status (for example lets say 
/proc/swaps is deprecated), we should print the informational message 
but not error out.

On 2013/02/13 11:58 AM, Zach Brown wrote:
> - First always open with O_EXCL.  If it succeeds then there's no reason
>    to check /proc/swaps at all.  (Maybe it doesn't need to try
>    check_mounted() there either?  Not sure if it's protecting against
>    accidentally mounting mounted shared storage or not.)
>
> ...
>
> - At no point is failure of any of the /proc/swaps parsing fatal.  It'd
>    carry on ignoring errors until it doesnt have work to do.  It'd only
>    ever print the nice message when it finds a match.


-- 
__________
Brendan Hide
http://swiftspirit.co.za/
http://www.webafrica.co.za/?AFF1E97

