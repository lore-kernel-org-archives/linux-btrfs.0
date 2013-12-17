Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:47881 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752009Ab3LQCb7 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 16 Dec 2013 21:31:59 -0500
Message-ID: <52AFB990.8030707@oracle.com>
Date: Tue, 17 Dec 2013 10:40:16 +0800
From: Anand Jain <Anand.Jain@oracle.com>
MIME-Version: 1.0
To: Wang Shilong <wangshilong1991@gmail.com>
CC: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 3/3] btrfs_progs: handle error in the btrfs_prepare_device
References: <1387197239-29893-1-git-send-email-anand.jain@oracle.com> <1387197239-29893-3-git-send-email-anand.jain@oracle.com> <93924585-F0F1-4BA8-880D-E9D27EF2C2CD@gmail.com>
In-Reply-To: <93924585-F0F1-4BA8-880D-E9D27EF2C2CD@gmail.com>
Content-Type: text/plain; charset=GB2312
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


 Thanks Wang.

> s/btrfs_progs/btrfs-progs?

 yeah. updated my script.

>> +
>> +zero_dev_error:
>> +	if (ret) {
>> +		ret < 0 ?
>> +		fprintf(stderr, "ERROR: failed to zero device start '%s' - %s\n",
>> +			file, strerror(-ret)) :
>> +		fprintf(stderr, "ERROR: failed to zero device start '%s' - %d\n",
>> +			file, ret);
> 
> Why we output message twice here¡­.

 Not really. there is "ret < 0 ?"

-Anand
