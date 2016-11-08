Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f49.google.com ([209.85.214.49]:35371 "EHLO
        mail-it0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751180AbcKHN0P (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 8 Nov 2016 08:26:15 -0500
Received: by mail-it0-f49.google.com with SMTP id e187so154968785itc.0
        for <linux-btrfs@vger.kernel.org>; Tue, 08 Nov 2016 05:26:14 -0800 (PST)
Subject: Re: Announcing btrfs-dedupe
To: Christoph Anton Mitterer <calestyo@scientia.net>, dsterba@suse.cz,
        James Pharaoh <james@wellbehavedsoftware.com>
References: <2855552b-714c-d1de-08f9-89153c293772@wellbehavedsoftware.com>
 <20161107140200.GM12522@suse.cz> <1478572812.28957.4.camel@scientia.net>
Cc: linux-btrfs@vger.kernel.org, mark@fasheh.com
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <d32c6f44-970f-615d-cb01-6ef48cd8d1f6@gmail.com>
Date: Tue, 8 Nov 2016 08:26:02 -0500
MIME-Version: 1.0
In-Reply-To: <1478572812.28957.4.camel@scientia.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2016-11-07 21:40, Christoph Anton Mitterer wrote:
> On Mon, 2016-11-07 at 15:02 +0100, David Sterba wrote:
>> I think adding a whole-file dedup mode to duperemove would be better
>> (from user's POV) than writing a whole new tool
>
> What would IMO be really good from a user's POV was, if one of the
> tools, deemed to be the "best", would be added to the btrfs-progs and
> simply become "the official" one.

The problem is that for deduplication, most tools won't work well for 
everything.  For example the cases I use it in are very specific and 
have horrible performance using pretty much any available tool (I have a 
couple cases where I have disjoint subsets of the same directory tree 
with different prefixes, so I can tell exactly which files are 
duplicated, and that any duplicate file is 100% duplicate, as well as a 
couple of cases where changes are small, scattered, and highly 
predictable (and thus it's easier to find what's changed and dedupe 
everything else instead of finding what's the same), and none of the 
existing options do well in either situation).

I'd argue at minimum for having the extent-same tool from duperemove in 
btrfs-progs, as that lets people do deduplication how they want without 
having to write C code.  Something equivalent that would let you call 
any BTRFS ioctl with (reasonably) arbitrary arguments might actually be 
even better (I can see such a tool being wonderful for debugging).
