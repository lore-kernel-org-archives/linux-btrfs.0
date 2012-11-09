Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from loup.kjorling.se ([87.237.208.114]:57414 "EHLO loup.kjorling.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750976Ab2KIKC4 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 9 Nov 2012 05:02:56 -0500
Date: Fri, 9 Nov 2012 10:02:27 +0000
From: Michael =?utf-8?B?S2rDtnJsaW5n?= <michael@kjorling.se>
To: Stefan Behrens <sbehrens@giantdisaster.de>
Cc: Goffredo Baroncelli <kreijack@gmail.com>,
        Tsutomu Itoh <t-itoh@jp.fujitsu.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 00/26] Btrfs: Add device replace code
Message-ID: <20121109100227.GF9133@yeono.kjorling.se>
References: <cover.1352214751.git.sbehrens@giantdisaster.de>
 <5099C40C.6030003@jp.fujitsu.com>
 <509A5E4F.7090408@giantdisaster.de>
 <CAJHuE_AD+EkAwKdMbLQwkRNzc+6qc9=xNziQfREV--GLUcz7Sw@mail.gmail.com>
 <509BEC60.9080200@giantdisaster.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <509BEC60.9080200@giantdisaster.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 8 Nov 2012 18:31 +0100, from sbehrens@giantdisaster.de (Stefan Behrens):
> "btrfs device replace cancel <path>"
> was the point when I gave up putting it below the "device" commands. IMO
> that's just too long, too much to type.

How often is one going to type that? I like the idea of consistency
with add/delete, here, since it really amounts to largely the same
thing.

-- 
Michael Kjörling • http://michael.kjorling.se • michael@kjorling.se
                “People who think they know everything really annoy
                those of us who know we don’t.” (Bjarne Stroustrup)
