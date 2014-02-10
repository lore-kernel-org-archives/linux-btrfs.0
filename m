Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:61392 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752367AbaBJVNu (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 10 Feb 2014 16:13:50 -0500
Message-ID: <52F94104.4030201@fb.com>
Date: Mon, 10 Feb 2014 16:13:40 -0500
From: Josef Bacik <jbacik@fb.com>
MIME-Version: 1.0
To: Pavel Volkov <negaipub@gmail.com>, <linux-btrfs@vger.kernel.org>
Subject: Re: Error: could not do orphan cleanup -22
References: <2047669.QmpNhlvBGM@melforce> <2047838.eX9UXPvc1f@melforce>
In-Reply-To: <2047838.eX9UXPvc1f@melforce>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 02/10/2014 03:53 PM, Pavel Volkov wrote:
> Some more update.
> I checked the FS with btrfsck:

Build a kernel with this patch applied

http://ur1.ca/glslj

and re-run the mount and when it fails attach dmesg to this email.  Thanks,

Josef
