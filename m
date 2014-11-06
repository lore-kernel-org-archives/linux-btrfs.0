Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from postler.lichtfels.com ([78.46.92.195]:58705 "EHLO
	postler.lichtfels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751151AbaKFQLH (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 6 Nov 2014 11:11:07 -0500
Received: from localhost (localhost [127.0.0.1])
	by postler.lichtfels.com (Postfix) with ESMTP id A6641123D7
	for <linux-btrfs@vger.kernel.org>; Thu,  6 Nov 2014 17:11:05 +0100 (CET)
Received: from postler.lichtfels.com ([127.0.0.1])
 by localhost (postler.lichtfels.com [127.0.0.1]) (amavisd-maia, port 10024)
 with LMTP id 25414-09 for <linux-btrfs@vger.kernel.org>;
 Thu,  6 Nov 2014 17:11:04 +0100 (CET)
Received: from [172.32.99.66] (mail.oops.co.at [213.129.238.225])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by postler.lichtfels.com (Postfix) with ESMTPSA id D73E2123CE
	for <linux-btrfs@vger.kernel.org>; Thu,  6 Nov 2014 17:11:03 +0100 (CET)
Message-ID: <545B9D97.3040206@xunil.at>
Date: Thu, 06 Nov 2014 17:11:03 +0100
From: "Stefan G. Weichinger" <lists@xunil.at>
Reply-To: lists@xunil.at
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: Re: "corrupt leaf" on kernel 3.17.2, w/ btrfs-progs 3.17
References: <545B8981.2010603@xunil.at>
In-Reply-To: <545B8981.2010603@xunil.at>
Content-Type: text/plain; charset=windows-1252
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am 06.11.2014 um 15:45 schrieb Stefan G. Weichinger:

> Pls advise how to proceed.
> 
> Should I do some repair or btrfsck from a live-medium?

... had some hefty kernel crashes ...

Now I am on latest sysresccd.

btrfsck v 3.16 ... fails as well

Backing up.

Seems I have to recreate the btrfs (with 3.16?) and all its subvolumes
... *sigh*

Maybe the SSD dies?

S
