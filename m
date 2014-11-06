Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from postler.lichtfels.com ([78.46.92.195]:58962 "EHLO
	postler.lichtfels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751054AbaKFQQP (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 6 Nov 2014 11:16:15 -0500
Received: from localhost (localhost [127.0.0.1])
	by postler.lichtfels.com (Postfix) with ESMTP id CBA6F123E0
	for <linux-btrfs@vger.kernel.org>; Thu,  6 Nov 2014 17:16:13 +0100 (CET)
Received: from postler.lichtfels.com ([127.0.0.1])
 by localhost (postler.lichtfels.com [127.0.0.1]) (amavisd-maia, port 10024)
 with LMTP id 26194-06 for <linux-btrfs@vger.kernel.org>;
 Thu,  6 Nov 2014 17:16:12 +0100 (CET)
Received: from [172.32.99.66] (mail.oops.co.at [213.129.238.225])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by postler.lichtfels.com (Postfix) with ESMTPSA id F2B64123CE
	for <linux-btrfs@vger.kernel.org>; Thu,  6 Nov 2014 17:16:11 +0100 (CET)
Message-ID: <545B9ECB.1040903@xunil.at>
Date: Thu, 06 Nov 2014 17:16:11 +0100
From: "Stefan G. Weichinger" <lists@xunil.at>
Reply-To: lists@xunil.at
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: Re: "corrupt leaf" on kernel 3.17.2, w/ btrfs-progs 3.17
References: <545B8981.2010603@xunil.at> <545B9D97.3040206@xunil.at>
In-Reply-To: <545B9D97.3040206@xunil.at>
Content-Type: text/plain; charset=windows-1252
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am 06.11.2014 um 17:11 schrieb Stefan G. Weichinger:
> Am 06.11.2014 um 15:45 schrieb Stefan G. Weichinger:
> 
>> Pls advise how to proceed.
>>
>> Should I do some repair or btrfsck from a live-medium?
> 
> ... had some hefty kernel crashes ...
> 
> Now I am on latest sysresccd.
> 
> btrfsck v 3.16 ... fails as well
> 
> Backing up.

While I am rsyncing I get this again in dmesg:

btrfs: corrupt leaf, slot offset bad: block ...
btrfs no csum found for inode ...

Can I determine which subvol this relates to?

As far as I understand it is likely the one currently synced?

Maybe I could only recreate that one subvolume and restore?

Or do I have to recreate the whole btrfs?

S

