Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mondschein.lichtvoll.de ([194.150.191.11]:60272 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751150Ab3CJNUB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 10 Mar 2013 09:20:01 -0400
From: Martin Steigerwald <Martin@lichtvoll.de>
To: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH V3][BTRFS-PROGS] Enhance btrfs fi df with raid5/6 support
Date: Sun, 10 Mar 2013 14:19:58 +0100
Cc: Goffredo Baroncelli <goffredo.baroncelli@yahoo.com>,
        Hugo Mills <hugo@carfax.org.uk>,
        Michael =?utf-8?q?Kj=C3=B6rling?= <michael@kjorling.se>,
        cwillu <cwillu@cwillu.com>, Chris Murphy <lists@colorremedies.com>,
        David Sterba <dsterba@suse.cz>, Zach Brown <zab@zabbo.net>
References: <1362917859-18824-1-git-send-email-goffredo.baroncelli@yahoo.com> <201303101416.02781.Martin@lichtvoll.de> (sfid-20130310_141704_372282_58A3CDC6)
In-Reply-To: <201303101416.02781.Martin@lichtvoll.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Message-Id: <201303101419.59585.Martin@lichtvoll.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am Sonntag, 10. März 2013 schrieb Martin Steigerwald:
> Am Sonntag, 10. März 2013 schrieb Goffredo Baroncelli:
> > Hi all,
> 
> Hi Goffredo,
> 
> > This is the third attempt of my patches related to show how the data
> > are stored in a btrfs filesystem. I rebased all the patches on the
> > latest mason git. I tried to address the Zach concern abou the using
> > of the string_list_add() in the df_pretty_sizes(): string_list_add()
> > is removed from the df_pretty_sizes() and I created the new function
> > sla_pretty_sizes() which calls df_pretty_sizes() and
> > string_list_add().
> 
> Thanks for your new round of patches.

My MTA returned on my first answer to you:

<goffredo.baroncelli@yahoo.com>: host mta5.am0.yahoodns.net[74.6.136.244] 
said:
    554 delivery error: dd This user doesn't have a yahoo.com account
    (goffredo.baroncelli@yahoo.com) [-5] - mta1233.mail.sk1.yahoo.com (in 
reply
    to end of DATA command)

Replying to list cause obviously I cannot reach your personal mail address 
right now.

Thanks,
-- 
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
