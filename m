Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ph.de-nserver.de ([85.158.179.214]:52988 "EHLO
	mail-ph.de-nserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753362Ab3CRUcq (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 18 Mar 2013 16:32:46 -0400
Message-ID: <514779EB.8010307@profihost.ag>
Date: Mon, 18 Mar 2013 21:32:43 +0100
From: Stefan Priebe <s.priebe@profihost.ag>
MIME-Version: 1.0
To: Josef Bacik <jbacik@fusionio.com>
CC: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: vanilla 3.8.3: btrfs: block rsv returned -28
References: <51476EA7.9060607@profihost.ag> <20130318200035.GA25655@localhost.localdomain>
In-Reply-To: <20130318200035.GA25655@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,
Am 18.03.2013 21:00, schrieb Josef Bacik:
> On Mon, Mar 18, 2013 at 01:44:39PM -0600, Stefan Priebe wrote:
>> Hello list,
>>
>> while testing btrfs with 3.8.3 i'm seeing this one several times. Is it
>> known?
>>
>
> Yup, it's fine, I'm fixing it for 3.10.  Thanks,

Thanks, is it save to ignore it? No backport for 3.8 and 3.9?

Greets,
Stefan
