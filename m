Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:46960 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932130AbcCPJ2t (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 16 Mar 2016 05:28:49 -0400
Date: Wed, 16 Mar 2016 10:28:24 +0100
From: David Sterba <dsterba@suse.cz>
To: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH 2/2 v2] btrfs-progs: Fix a regression that "property"
 with -t option doesn't work
Message-ID: <20160316092824.GF21722@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <56E8BE67.6030802@jp.fujitsu.com>
 <56E8C0BB.1050307@jp.fujitsu.com>
 <56E8C1CE.7060806@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <56E8C1CE.7060806@jp.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Mar 16, 2016 at 11:15:42AM +0900, Satoru Takeuchi wrote:
> Sorry, I forgot to add "btrfs-progs: " in the subject line.
> ---
> "property" is considered as working without any options
> from the following commit.
> 
> commit 176aeca9a148 ("btrfs-progs: add getopt stubs where needed")
> 
> However, we can pass -t option to this command.
> 
> * actual result
> 
>   ==================================================
>   $ ./btrfs prop list -t f /btrfs
>   btrfs property list: invalid option -- 't'
>   usage: btrfs property list [-t <type>] <object>
> 
>       Lists available properties with their descriptions for the given object.
> 
>       Please see the help of 'btrfs property get' for a description of
>       objects and object types.
> 
>   ==================================================
> 
> * expected result
> 
>   ==================================================
>   $ ./btrfs prop list -t f /btrfs
>   label               Set/get label of device.
>   ==================================================
> 
> Signed-off-by: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com

Applied, thanks.
