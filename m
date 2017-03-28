Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:58774 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932192AbdC1Lhd (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 28 Mar 2017 07:37:33 -0400
Date: Tue, 28 Mar 2017 13:36:43 +0200
From: David Sterba <dsterba@suse.cz>
To: ednadolski@gmail.com
Cc: linux-btrfs@vger.kernel.org, Edmund Nadolski <enadolski@suse.com>
Subject: Re: [PATCH v2 0/2] Cleanup for some hardcoded constants
Message-ID: <20170328113643.GW4781@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20170316160434.8126-1-enadolski@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170316160434.8126-1-enadolski@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Mar 16, 2017 at 10:04:32AM -0600, ednadolski@gmail.com wrote:
> From: Edmund Nadolski <enadolski@suse.com>
> 
> This series replaces several hard-coded values with descriptive
> symbols.
> 
> ---
> v2:
>  + rename SEQ_NONE to SEQ_LAST and move definition to ctree.h
>  + clarify comment at __merge_refs()
> 
> Edmund Nadolski (2):
>   btrfs: provide enumeration for __merge_refs mode argument
>   btrfs: replace hardcoded value with SEQ_LAST macro

Added to 4.12 queue, thanks.
