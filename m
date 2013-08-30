Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:44245 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755756Ab3H3OOl (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 30 Aug 2013 10:14:41 -0400
Date: Fri, 30 Aug 2013 16:14:35 +0200
From: David Sterba <dsterba@suse.cz>
To: Filipe David Borba Manana <fdmanana@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v4] Btrfs: optimize key searches in btrfs_search_slot
Message-ID: <20130830141435.GK23113@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1377780253-17826-1-git-send-email-fdmanana@gmail.com>
 <1377804111-15247-1-git-send-email-fdmanana@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1377804111-15247-1-git-send-email-fdmanana@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Aug 29, 2013 at 08:21:51PM +0100, Filipe David Borba Manana wrote:
> Count: 5013
> Range: 25.000 - 497.000; Mean: 82.767; Median: 64.000; Stddev: 49.972
> Percentiles:  90th: 141.000; 95th: 182.000; 99th: 287.000
>   25.000 -   33.930:   211 ######
>   33.930 -   45.927:   277 ########
>   45.927 -   62.045:  1834 #####################################################
>   62.045 -   83.699:  1203 ###################################
>   83.699 -  112.789:   609 ##################
>  112.789 -  151.872:   450 #############
>  151.872 -  204.377:   246 #######
>  204.377 -  274.917:   124 ####
>  274.917 -  369.684:    48 #
>  369.684 -  497.000:    11 |
> 
> Approach proposed by this patch:
> 
> Count: 5013
> Range: 10.000 - 8303.000; Mean: 28.505; Median: 18.000; Stddev: 119.147
> Percentiles:  90th: 49.000; 95th: 74.000; 99th: 115.000
>  10.000 -   20.339:  3160 #####################################################
>  20.339 -   40.397:  1131 ###################
>  40.397 -   79.308:   507 #########
>  79.308 -  154.794:   199 ###
> 154.794 -  301.232:    14 |
> 301.232 -  585.313:     1 |
> 585.313 - 8303.000:     1 |

The statistics do not change from patch to patch+1 but you're doing
changes that may affect performance, can you please update them as well?

thanks,
david
