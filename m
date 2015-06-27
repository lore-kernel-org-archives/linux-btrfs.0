Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from h218.18.88.75.static.ip.windstream.net ([75.88.18.218]:40547
	"EHLO suse102.ad.techspace.cc" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751217AbbF0Pp2 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 27 Jun 2015 11:45:28 -0400
Received: from esilinux2.ad.techspace.cc (esilinux2.ad.techspace.cc [192.168.10.56])
	(authenticated bits=0)
	by suse102.ad.techspace.cc (8.14.9/8.14.4/SuSE Linux 0.8) with ESMTP id t5RFj4QA002593
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES128-SHA bits=128 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Sat, 27 Jun 2015 10:45:05 -0500
Reply-To: moby@mobsternet.com
Subject: Re: kernel 4.1: no space left on device
References: <558EC1F4.1050301@profihost.ag>
To: linux-btrfs@vger.kernel.org
From: Moby <moby@mobsternet.com>
Message-ID: <558EC500.9080907@mobsternet.com>
Date: Sat, 27 Jun 2015 10:45:04 -0500
MIME-Version: 1.0
In-Reply-To: <558EC1F4.1050301@profihost.ag>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 06/27/2015 10:32 AM, Stefan Priebe wrote:
> Hi,
>
> while having some big btrfs volumes (44TB + 37TB).
>
> I see on a regular basis the "no space left on device" message. I'm 
> only able to "fix" this. By running btrfs balance AND unmounting and 
> remounting the btrfs volume.
>
> Is there any way to debug / workaround this one?
>
> Greets,
> Stefan
> -- 
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>
Assuming you ruled out accumulation of snapshots?

-- 
--Moby


First they came for the Jews and I did not speak out because I was not a Jew.
Then they came for the Communists and I did not speak out because I was not a Communist.
Then they came for the trade unionists and I did not speak out because I was not a trade unionist.
Then they came for me and there was no one left to speak out for me.  --  Pastor Martin Niemöller

