Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-we0-f179.google.com ([74.125.82.179]:57685 "EHLO
	mail-we0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751327Ab3CJP6E (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 10 Mar 2013 11:58:04 -0400
Received: by mail-we0-f179.google.com with SMTP id p43so2709959wea.24
        for <linux-btrfs@vger.kernel.org>; Sun, 10 Mar 2013 08:58:01 -0700 (PDT)
Message-ID: <513CADEA.2080202@gmail.com>
Date: Sun, 10 Mar 2013 16:59:38 +0100
From: Goffredo Baroncelli <kreijack@gmail.com>
Reply-To: kreijack@inwind.it
MIME-Version: 1.0
To: Martin Steigerwald <Martin@lichtvoll.de>
CC: linux-btrfs@vger.kernel.org,
        Goffredo Baroncelli <goffredo.baroncelli@yahoo.com>,
        Hugo Mills <hugo@carfax.org.uk>,
        =?UTF-8?B?TWljaGFlbCBLasO2cmxpbmc=?= <michael@kjorling.se>,
        cwillu <cwillu@cwillu.com>, Chris Murphy <lists@colorremedies.com>,
        David Sterba <dsterba@suse.cz>, Zach Brown <zab@zabbo.net>
Subject: Re: [PATCH V3][BTRFS-PROGS] Enhance btrfs fi df with raid5/6 support
References: <1362917859-18824-1-git-send-email-goffredo.baroncelli@yahoo.com> <201303101416.02781.Martin@lichtvoll.de> (sfid-20130310_141704_372282_58A3CDC6) <201303101419.59585.Martin@lichtvoll.de>
In-Reply-To: <201303101419.59585.Martin@lichtvoll.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 03/10/2013 02:19 PM, Martin Steigerwald wrote:
> Am Sonntag, 10. März 2013 schrieb Martin Steigerwald:
>> Am Sonntag, 10. März 2013 schrieb Goffredo Baroncelli:
>>> Hi all,
>>
>> Hi Goffredo,
>>
>>> This is the third attempt of my patches related to show how the data
>>> are stored in a btrfs filesystem. I rebased all the patches on the
>>> latest mason git. I tried to address the Zach concern abou the using
>>> of the string_list_add() in the df_pretty_sizes(): string_list_add()
>>> is removed from the df_pretty_sizes() and I created the new function
>>> sla_pretty_sizes() which calls df_pretty_sizes() and
>>> string_list_add().
>>
>> Thanks for your new round of patches.
> 
> My MTA returned on my first answer to you:
> 
> <goffredo.baroncelli@yahoo.com>: host mta5.am0.yahoodns.net[74.6.136.244] 
> said:
>     554 delivery error: dd This user doesn't have a yahoo.com account
>     (goffredo.baroncelli@yahoo.com) [-5] - mta1233.mail.sk1.yahoo.com (in 
> reply
>     to end of DATA command)
> 
> Replying to list cause obviously I cannot reach your personal mail address 
> right now.

It seems that yahoo doesn't recognise my email
"goffredo.baroncelli@yahoo.com"; the strange thing is that I use this
user for the authentication !

> 
> Thanks,

GB


-- 
gpg @keyserver.linux.it: Goffredo Baroncelli (kreijackATinwind.it>
Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5
