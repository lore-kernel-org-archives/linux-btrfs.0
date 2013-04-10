Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:33468 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750738Ab3DJDGY (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 9 Apr 2013 23:06:24 -0400
Message-ID: <5164D75B.1060402@oracle.com>
Date: Wed, 10 Apr 2013 11:07:07 +0800
From: Anand Jain <Anand.Jain@oracle.com>
MIME-Version: 1.0
To: dsterba@suse.cz, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs-progs: make btrfs dev scan multi path aware
References: <1363867004-22912-1-git-send-email-anand.jain@oracle.com> <20130408152238.GE18193@twin.jikos.cz> <20130409111208.GF18193@twin.jikos.cz>
In-Reply-To: <20130409111208.GF18193@twin.jikos.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 04/09/2013 07:12 PM, David Sterba wrote:
> On Mon, Apr 08, 2013 at 05:22:38PM +0200, David Sterba wrote:
>>> +	fd = open("/dev/btrfs-control", O_RDWR);
>>> +	e = errno;
>>> +	if (fd < 0) {
>>> +		FILE *mfd = popen("lsmod | grep btrfs", "r");
>> Please transform this into C.
>
> Actually, what if btrfs is not built as a module? There should be another
> way to detect that btrfs is compiled in, like opening the control device
> and reading something back.

yeah sorry i missed it. Thanks. Let me followup in the latest
patch of this.

Thanks, Anand


