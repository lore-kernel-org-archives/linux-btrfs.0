Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from static.68.134.40.188.clients.your-server.de ([188.40.134.68]:48681
	"EHLO mail02.iobjects.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756905AbbLHQCR (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 8 Dec 2015 11:02:17 -0500
Subject: Re: Scrub: no spae left on device
To: Lionel Bouton <lionel-subscription@bouton.name>,
        Marc MERLIN <marc@merlins.org>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
References: <20151208150638.GL27889@merlins.org>
 <5666F947.5010902@googlemail.com> <5666FB58.2040900@bouton.name>
From: =?UTF-8?Q?Holger_Hoffst=c3=a4tte?=
	<holger.hoffstaette@googlemail.com>
Message-ID: <5666FF07.5060902@googlemail.com>
Date: Tue, 8 Dec 2015 17:02:15 +0100
MIME-Version: 1.0
In-Reply-To: <5666FB58.2040900@bouton.name>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 12/08/15 16:46, Lionel Bouton wrote:
> Le 08/12/2015 16:37, Holger Hoffstätte a écrit :
>> On 12/08/15 16:06, Marc MERLIN wrote:
>>> Howdy,
>>>
>>> Why would scrub need space and why would it cancel if there isn't enough of
>>> it?
>>> (kernel 4.3)
>>>
>>> /etc/cron.daily/btrfs-scrub:
>>> btrfs scrub start -Bd /dev/mapper/cryptroot
>>> scrub device /dev/mapper/cryptroot (id 1) done
>>> 	scrub started at Mon Dec  7 01:35:08 2015 and finished after 258 seconds
>>> 	total bytes scrubbed: 130.84GiB with 0 errors
>>> btrfs scrub start -Bd /dev/mapper/pool1
>>> ERROR: scrubbing /dev/mapper/pool1 failed for device id 1 (No space left on device)
>>> scrub device /dev/mapper/pool1 (id 1) canceled
>> Scrub rewrites metadata (apparently even in -r aka readonly mode), and that
>> can lead to temporary metadata expansion (stuff gets COWed around); it's
>> a bit surprising but makes sense if you think about it.
> 
> How long must I think about it until it makes sense? :-)
> 
> Sorry I'm not sure why metadata is rewritten if no error is detected.
> I've several theories but lack information: is the fact that no error
> has been detected stored somewhere? is scrub using some kind of internal
> temporary snapshot(s) to avoid interfering with other operations? other
> reason I didn't think about?

Well..I have no idea what the historical motivation for this behaviour was,
even though I can make up at least two: rewriting known-good checksums
generally (since you know they are good this very moment), and in case of
error avoiding the area where the block error occurred (read errors on rust
are often clustered and affect entire tracks).

That's really all I know. I agree it's surprising, especially since it
happens by default and also in -r mode, which might be considered a bug.

-h

