Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:51686 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756613Ab2KHSkJ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 8 Nov 2012 13:40:09 -0500
Received: by mail-bk0-f46.google.com with SMTP id jk13so1350349bkc.19
        for <linux-btrfs@vger.kernel.org>; Thu, 08 Nov 2012 10:40:07 -0800 (PST)
Message-ID: <509BFCBF.4070300@gmail.com>
Date: Thu, 08 Nov 2012 19:41:03 +0100
From: Goffredo Baroncelli <kreijack@gmail.com>
Reply-To: kreijack@inwind.it
MIME-Version: 1.0
To: Stefan Behrens <sbehrens@giantdisaster.de>
CC: Tsutomu Itoh <t-itoh@jp.fujitsu.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 00/26] Btrfs: Add device replace code
References: <cover.1352214751.git.sbehrens@giantdisaster.de> <5099C40C.6030003@jp.fujitsu.com> <509A5E4F.7090408@giantdisaster.de> <CAJHuE_AD+EkAwKdMbLQwkRNzc+6qc9=xNziQfREV--GLUcz7Sw@mail.gmail.com> <509BEC60.9080200@giantdisaster.de>
In-Reply-To: <509BEC60.9080200@giantdisaster.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 11/08/2012 06:31 PM, Stefan Behrens wrote:
> On Thu, 8 Nov 2012 13:50:19 +0100, Goffredo Baroncelli wrote:
[...]
>> I think that so "replace" would be the natural extension to the "add"
>> and "delete" subcommands.
> 
> "btrfs device replace <old> <new> <path>"
> was also my first idea. It used to be like this initially.
> 
> "btrfs device replace cancel <path>"
> was the point when I gave up putting it below the "device" commands. IMO
> that's just too long, too much to type.

> 
> Now it has the same look and feel as the "scrub" commands ("scrub
> start", "scrub status" and "scrub cancel").

Yes, but scrub was a a new command. Instead I see "replace" as an
extension of "btrfs device add/del" (from an user interface POV).

If someone would extend the "btrfs device delete" command to support
status/pause/resume, how could do it ?
May be we need a new series of command which handle the "background
process" (like btrfs replace, btrfs device delete, btrfs subvolume
delete....) to status/stop/suspend/resume these processes ?

I am doing a bit of brain-storming...







> 
> 


-- 
gpg @keyserver.linux.it: Goffredo Baroncelli (kreijackATinwind.it>
Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5
