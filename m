Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ph.de-nserver.de ([85.158.179.214]:39058 "EHLO
	mail-ph.de-nserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751698Ab3CVMMH (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 22 Mar 2013 08:12:07 -0400
Message-ID: <514C4A8C.90607@profihost.ag>
Date: Fri, 22 Mar 2013 13:11:56 +0100
From: Stefan Priebe - Profihost AG <s.priebe@profihost.ag>
MIME-Version: 1.0
To: Chris Mason <clmason@fusionio.com>
CC: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: No space left on device (28)
References: <514ABEB8.3090104@profihost.ag> <20130321180020.30044.84729@localhost.localdomain> <967ED686-7E9C-4158-80A0-D58D18818BA2@profihost.ag> <20130321190249.30044.79438@localhost.localdomain> <514B62A4.1030201@profihost.ag> <5F36F35C-39BE-4244-B8FB-A80EC2B06D48@profihost.ag>
In-Reply-To: <5F36F35C-39BE-4244-B8FB-A80EC2B06D48@profihost.ag>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Chris,

>>>>> Which kernel are you running?
>>>>>
>>>>> -chris
>>>>
>>>> vanilla 3.8.3.
>>>
>>> Ok, with the 3.9 merge window Josef changed how we do the reservations.
>>> Are you able to try a slightly more experimental kernel?

any ideas what i can check? 3.9-rc3 gives me same results.

Greets,
Stefan
