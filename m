Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:43811 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752310Ab2JGWrA (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 7 Oct 2012 18:47:00 -0400
Received: by mail-wg0-f44.google.com with SMTP id dr13so3208354wgb.1
        for <linux-btrfs@vger.kernel.org>; Sun, 07 Oct 2012 15:46:59 -0700 (PDT)
Message-ID: <5072066B.4020604@gmail.com>
Date: Mon, 08 Oct 2012 00:47:07 +0200
From: Goffredo Baroncelli <kreijack@gmail.com>
MIME-Version: 1.0
To: Martin Steigerwald <Martin@lichtvoll.de>
CC: linux-btrfs@vger.kernel.org,
        =?UTF-8?B?U3fDom1pIFBldGFyYW1lc2g=?= <swami@petaramesh.org>,
        Alex <alex@bpmit.com>, Liu Bo <bo.li.liu@oracle.com>
Subject: Re: BTRFS, getting darn slower everyday
References: <50714AC8.4010100@petaramesh.org> <loom.20121007T141248-114@post.gmane.org> <50718151.8090506@petaramesh.org> (sfid-20121007_163445_311645_DBA4D8EF) <201210071644.19815.Martin@lichtvoll.de>
In-Reply-To: <201210071644.19815.Martin@lichtvoll.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 10/07/2012 04:44 PM, Martin Steigerwald wrote:
>> Plus, with respect to snapshots, isn't this going to increase a lot my
>> >  used disk space ?
> I don´t think so, but I will leave this to a developer to answer.
>
IIRC the defrag is not [fully] snapshot aware, so de-frag-ging a 
snapshot-ted file should break the COW link.
Liu Bo is working to patch on that: see " Btrfs: use flag EXTENT_DEFRAG 
for snapshot-aware defrag" dated 2012/09/17.

Please could you clarify if you are using the "autodefrag" options when 
you have the performance problem ? Are you in position to to reduce the 
number of snapshot from hundreds to few  ?

