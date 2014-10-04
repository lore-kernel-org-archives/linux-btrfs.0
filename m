Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from srv2.trombetti.net ([65.254.53.252]:2471 "EHLO
	srv2.trombetti.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751795AbaJDKgu (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sat, 4 Oct 2014 06:36:50 -0400
Received: from localhost (localhost [127.0.0.1])
	(using TLSv1 with cipher DHE-RSA-AES128-SHA (128/128 bits))
	(No client certificate requested)
	(Authenticated sender: SASL)
	by srv2.trombetti.net (Postfix) with ESMTPSA id 62C1F313AF
	for <linux-btrfs@vger.kernel.org>; Sat,  4 Oct 2014 06:48:54 -0400 (EDT)
Message-ID: <542FCDBA.2020408@shiftmail.org>
Date: Sat, 04 Oct 2014 12:36:42 +0200
From: Bob Marley <bobmarley@shiftmail.org>
MIME-Version: 1.0
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: Performance reduces with nodatasum
References: <542FCB53.1070201@shiftmail.org>
In-Reply-To: <542FCB53.1070201@shiftmail.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 04/10/2014 12:26, Bob Marley wrote:
> Hello,
> apparently I have found an issue with btrfs

Sorry I forgot to mention the kernel version:  3.14.19
not tested with higher versions

