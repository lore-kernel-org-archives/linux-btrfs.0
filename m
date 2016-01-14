Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cc-smtpout2.netcologne.de ([89.1.8.212]:48562 "EHLO
	cc-smtpout2.netcologne.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754035AbcANQLT (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 14 Jan 2016 11:11:19 -0500
Subject: Re: [PATCH 2/3] btrfs: add balance filter for stripes
To: David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org
References: <cover.1445360598.git.dsterba@suse.com>
 <aa6771ad37b6cd5370bccebfe525bd654f0d8a30.1445360598.git.dsterba@suse.com>
Cc: =?UTF-8?B?R2FicsOtZWwgQXJ0aMO6ciBQw6l0dXJzc29u?=
	<gabriel@system.is>
From: Christian Rohmann <crohmann@netcologne.de>
Message-ID: <5697C69B.1000308@netcologne.de>
Date: Thu, 14 Jan 2016 17:02:35 +0100
MIME-Version: 1.0
In-Reply-To: <aa6771ad37b6cd5370bccebfe525bd654f0d8a30.1445360598.git.dsterba@suse.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 10/20/2015 07:13 PM, David Sterba wrote:
> Balance block groups which have the given number of stripes, defined by
> a range min..max. This is useful to selectively rebalance only chunks
> that do not span enough devices, applies to RAID0/10/5/6.

This sounds like an awesome improvement to re-balance a filesystem with
newly added devices which don't have any data chunks yet. So in theory
for RAID6 I would simple need to execute

 btrfs balance start -dstripes=0..$devicecount-1 /filesystem


to have btrfs balance those chunks which are not spread across all
devices yet?



Regards

Christian
