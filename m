Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from kiara-balancer-1.wellbehavedsoftware.com ([138.201.134.108]:59936
        "EHLO kiara-balancer-1.wellbehavedsoftware.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753137AbcKHGL5 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 8 Nov 2016 01:11:57 -0500
Subject: Re: Announcing btrfs-dedupe
To: Christoph Anton Mitterer <calestyo@scientia.net>, dsterba@suse.cz
References: <2855552b-714c-d1de-08f9-89153c293772@wellbehavedsoftware.com>
 <20161107140200.GM12522@suse.cz> <1478572812.28957.4.camel@scientia.net>
Cc: linux-btrfs@vger.kernel.org, mark@fasheh.com
From: James Pharaoh <james@wellbehavedsoftware.com>
Message-ID: <4382e152-9984-fd31-5aa2-cf0a721517b0@wellbehavedsoftware.com>
Date: Tue, 8 Nov 2016 07:11:51 +0100
MIME-Version: 1.0
In-Reply-To: <1478572812.28957.4.camel@scientia.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Perhaps the complexity of doing this efficiently makes it inappropriate 
for inclusion in the tool itself, whereas I believe the core 
implementation's focus is on in-band deduplication, automatic and behind 
the scenes.

On 08/11/16 03:40, Christoph Anton Mitterer wrote:
> On Mon, 2016-11-07 at 15:02 +0100, David Sterba wrote:
>> I think adding a whole-file dedup mode to duperemove would be better
>> (from user's POV) than writing a whole new tool
>
> What would IMO be really good from a user's POV was, if one of the
> tools, deemed to be the "best", would be added to the btrfs-progs and
> simply become "the official" one.
>
> Cheers,
> Chris.
>
