Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from outrelay06.libero.it ([212.52.84.110]:39670 "EHLO
	outrelay06.libero.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752619AbaCJS6c (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 10 Mar 2014 14:58:32 -0400
Message-ID: <531E0B8B.7060504@libero.it>
Date: Mon, 10 Mar 2014 19:59:23 +0100
From: Goffredo Baroncelli <kreijack@libero.it>
Reply-To: kreijack@inwind.it
MIME-Version: 1.0
To: Kay Sievers <kay@vrfy.org>
CC: systemd-devel@lists.freedesktop.org,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [systemd-devel] [HEADS-UP] Discoverable Partitions Spec
References: <20140307182603.GA22874@tango.0pointer.de> <531E059B.1010509@libero.it> <CAPXgP13GbpRtxfOMjKgXcdxzOwE+phhNY+F=g8OCb_MLm4EOqQ@mail.gmail.com>
In-Reply-To: <CAPXgP13GbpRtxfOMjKgXcdxzOwE+phhNY+F=g8OCb_MLm4EOqQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Kay
On 03/10/2014 07:53 PM, Kay Sievers wrote:
[...]
>>
>> Instead of relying on the subvolume UUID, why not relying to the subvolume name: it would be more simple and flexible to manage them.
> 
> As a general rule: human-readable names should be left to the
> administrator, provide an identifier for humans, and should not be
> overloaded with magic machine behavior.

In general I agree with you. 
But using "a name" you can manage multiple system on the same filesystem. This is impossible with the UUID.

> 
> KayGoffredo-- 
gpg @keyserver.linux.it: Goffredo Baroncelli (kreijackATinwind.it>
Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5
