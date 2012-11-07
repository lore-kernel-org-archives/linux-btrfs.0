Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mo-p00-ob.rzone.de ([81.169.146.160]:18984 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750761Ab2KGNMt (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 7 Nov 2012 08:12:49 -0500
Message-ID: <509A5E4F.7090408@giantdisaster.de>
Date: Wed, 07 Nov 2012 14:12:47 +0100
From: Stefan Behrens <sbehrens@giantdisaster.de>
MIME-Version: 1.0
To: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
CC: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 00/26] Btrfs: Add device replace code
References: <cover.1352214751.git.sbehrens@giantdisaster.de> <5099C40C.6030003@jp.fujitsu.com>
In-Reply-To: <5099C40C.6030003@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-2022-JP
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, 07 Nov 2012 11:14:36 +0900, Tsutomu Itoh wrote:
> (2012/11/07 1:38), Stefan Behrens wrote:
>> replace start [-Bfr] <path> <srcdev>|<devid> <targetdev>
> 
> I think that
>  "btrfs replace start [-Bfr] <srcdev>|<devid> <targetdev> <path>"
> of the same synopsis as other subcommands is better.

You are right. 'btrfs device add' and 'btrfs device delete' have the
path at the end and the device in front, and there is no good reason to
not make it look equally. I will change it accordingly and post a V2 of
the Btrfs-progs patch within the next few days.

Thanks!

