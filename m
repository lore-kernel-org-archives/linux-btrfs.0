Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from ns.bouton.name ([109.74.195.142]:40852 "EHLO mail.bouton.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965148AbbLHPqe (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 8 Dec 2015 10:46:34 -0500
Subject: Re: Scrub: no spae left on device
To: =?UTF-8?Q?Holger_Hoffst=c3=a4tte?=
	<holger.hoffstaette@googlemail.com>,
        Marc MERLIN <marc@merlins.org>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
References: <20151208150638.GL27889@merlins.org>
 <5666F947.5010902@googlemail.com>
From: Lionel Bouton <lionel-subscription@bouton.name>
Message-ID: <5666FB58.2040900@bouton.name>
Date: Tue, 8 Dec 2015 16:46:32 +0100
MIME-Version: 1.0
In-Reply-To: <5666F947.5010902@googlemail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Le 08/12/2015 16:37, Holger Hoffstätte a écrit :
> On 12/08/15 16:06, Marc MERLIN wrote:
>> Howdy,
>>
>> Why would scrub need space and why would it cancel if there isn't enough of
>> it?
>> (kernel 4.3)
>>
>> /etc/cron.daily/btrfs-scrub:
>> btrfs scrub start -Bd /dev/mapper/cryptroot
>> scrub device /dev/mapper/cryptroot (id 1) done
>> 	scrub started at Mon Dec  7 01:35:08 2015 and finished after 258 seconds
>> 	total bytes scrubbed: 130.84GiB with 0 errors
>> btrfs scrub start -Bd /dev/mapper/pool1
>> ERROR: scrubbing /dev/mapper/pool1 failed for device id 1 (No space left on device)
>> scrub device /dev/mapper/pool1 (id 1) canceled
> Scrub rewrites metadata (apparently even in -r aka readonly mode), and that
> can lead to temporary metadata expansion (stuff gets COWed around); it's
> a bit surprising but makes sense if you think about it.

How long must I think about it until it makes sense? :-)

Sorry I'm not sure why metadata is rewritten if no error is detected.
I've several theories but lack information: is the fact that no error
has been detected stored somewhere? is scrub using some kind of internal
temporary snapshot(s) to avoid interfering with other operations? other
reason I didn't think about?

Lionel
