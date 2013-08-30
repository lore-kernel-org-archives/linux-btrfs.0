Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-bk0-f54.google.com ([209.85.214.54]:56220 "EHLO
	mail-bk0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756214Ab3H3OrX (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 30 Aug 2013 10:47:23 -0400
Received: by mail-bk0-f54.google.com with SMTP id mz12so724212bkb.27
        for <linux-btrfs@vger.kernel.org>; Fri, 30 Aug 2013 07:47:22 -0700 (PDT)
MIME-Version: 1.0
Reply-To: fdmanana@gmail.com
In-Reply-To: <20130830141435.GK23113@twin.jikos.cz>
References: <1377780253-17826-1-git-send-email-fdmanana@gmail.com>
	<1377804111-15247-1-git-send-email-fdmanana@gmail.com>
	<20130830141435.GK23113@twin.jikos.cz>
Date: Fri, 30 Aug 2013 15:47:21 +0100
Message-ID: <CAL3q7H4s4OrCkgws8Q4qZXezk-_WGGucc3C84Ud3Xy5d0zFgKQ@mail.gmail.com>
Subject: Re: [PATCH v4] Btrfs: optimize key searches in btrfs_search_slot
From: Filipe David Manana <fdmanana@gmail.com>
To: "dsterba@suse.cz" <dsterba@suse.cz>,
        Filipe David Borba Manana <fdmanana@gmail.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Aug 30, 2013 at 3:14 PM, David Sterba <dsterba@suse.cz> wrote:
> On Thu, Aug 29, 2013 at 08:21:51PM +0100, Filipe David Borba Manana wrote:
>> Count: 5013
>> Range: 25.000 - 497.000; Mean: 82.767; Median: 64.000; Stddev: 49.972
>> Percentiles:  90th: 141.000; 95th: 182.000; 99th: 287.000
>>   25.000 -   33.930:   211 ######
>>   33.930 -   45.927:   277 ########
>>   45.927 -   62.045:  1834 #####################################################
>>   62.045 -   83.699:  1203 ###################################
>>   83.699 -  112.789:   609 ##################
>>  112.789 -  151.872:   450 #############
>>  151.872 -  204.377:   246 #######
>>  204.377 -  274.917:   124 ####
>>  274.917 -  369.684:    48 #
>>  369.684 -  497.000:    11 |
>>
>> Approach proposed by this patch:
>>
>> Count: 5013
>> Range: 10.000 - 8303.000; Mean: 28.505; Median: 18.000; Stddev: 119.147
>> Percentiles:  90th: 49.000; 95th: 74.000; 99th: 115.000
>>  10.000 -   20.339:  3160 #####################################################
>>  20.339 -   40.397:  1131 ###################
>>  40.397 -   79.308:   507 #########
>>  79.308 -  154.794:   199 ###
>> 154.794 -  301.232:    14 |
>> 301.232 -  585.313:     1 |
>> 585.313 - 8303.000:     1 |
>
> The statistics do not change from patch to patch+1 but you're doing
> changes that may affect performance, can you please update them as well?

Sure.
They're actually better now :)
Patch following with updated histograms.

>
> thanks,
> david



-- 
Filipe David Manana,

"Reasonable men adapt themselves to the world.
 Unreasonable men adapt the world to themselves.
 That's why all progress depends on unreasonable men."
