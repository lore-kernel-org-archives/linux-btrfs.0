Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:57361 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752286Ab2KHMuU (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 8 Nov 2012 07:50:20 -0500
Received: by mail-ee0-f46.google.com with SMTP id b15so1518243eek.19
        for <linux-btrfs@vger.kernel.org>; Thu, 08 Nov 2012 04:50:19 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <509A5E4F.7090408@giantdisaster.de>
References: <cover.1352214751.git.sbehrens@giantdisaster.de>
	<5099C40C.6030003@jp.fujitsu.com>
	<509A5E4F.7090408@giantdisaster.de>
Date: Thu, 8 Nov 2012 13:50:19 +0100
Message-ID: <CAJHuE_AD+EkAwKdMbLQwkRNzc+6qc9=xNziQfREV--GLUcz7Sw@mail.gmail.com>
Subject: Re: [PATCH 00/26] Btrfs: Add device replace code
From: Goffredo Baroncelli <kreijack@gmail.com>
To: Stefan Behrens <sbehrens@giantdisaster.de>
Cc: Tsutomu Itoh <t-itoh@jp.fujitsu.com>, linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Stefan,

great work. However I have a suggestion: what about putting all the
command under 'device' sub commands: something like:

- btrfs device replace <old> <new> </path>

- btrfs device status </path>

Where "btrfs device status" would show only the status of the
"replacing" operation; but in the future it could show also the status
of the "delete" command (which it is the only other "device
sub-command" which needs time to complete).

Of course I am not asking to complete the "btrfs device status" part
for the "btrfs device delete" command. This could be implemented in a
second time.

I think that so "replace" would be the natral extension to the "add"
and "delete" subcommands.

BR
G.Baroncelli


On Wed, Nov 7, 2012 at 2:12 PM, Stefan Behrens
<sbehrens@giantdisaster.de> wrote:
> On Wed, 07 Nov 2012 11:14:36 +0900, Tsutomu Itoh wrote:
>> (2012/11/07 1:38), Stefan Behrens wrote:
>>> replace start [-Bfr] <path> <srcdev>|<devid> <targetdev>
>>
>> I think that
>>  "btrfs replace start [-Bfr] <srcdev>|<devid> <targetdev> <path>"
>> of the same synopsis as other subcommands is better.
>
> You are right. 'btrfs device add' and 'btrfs device delete' have the
> path at the end and the device in front, and there is no good reason to
> not make it look equally. I will change it accordingly and post a V2 of
> the Btrfs-progs patch within the next few days.
>
> Thanks!
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
