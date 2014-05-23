Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:48015 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750990AbaEWCiF (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 22 May 2014 22:38:05 -0400
Message-ID: <537EB543.6080000@oracle.com>
Date: Fri, 23 May 2014 10:41:07 +0800
From: Anand Jain <Anand.Jain@oracle.com>
MIME-Version: 1.0
To: Koen Kooi <koen@dominion.thruhere.net>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 2/2 v3] btrfs: usage error should not be logged into system
 log
References: <1400519071-5580-1-git-send-email-anand.jain@oracle.com> <1400755272-22590-1-git-send-email-anand.jain@oracle.com> <1400755272-22590-2-git-send-email-anand.jain@oracle.com> <llkmj4$9r5$1@ger.gmane.org>
In-Reply-To: <llkmj4$9r5$1@ger.gmane.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 22/05/14 19:21, Koen Kooi wrote:
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
>
> Anand Jain schreef op 22-05-14 12:41:
>> From: Anand Jain <Anand.Jain@oracle.com>
>>
>> I have an opinion that system logs /var/log/messages are valuable info to
>> investigate the real system issues at the data center. People handling
>> data center issues do spend a lot time and efforts analyzing messages
>> files. Having usage error logged into /var/log/messages is something we
>> should avoid.
>
> Do you mean 'syslog' when you say '/var/log/messages'? There's no
> /var/log/messages on my machines..

yes indeed, depending on whats configured.
sorry to confuse you. Will update the commit
Thanks, Anand

> regards,
>
> Koen


