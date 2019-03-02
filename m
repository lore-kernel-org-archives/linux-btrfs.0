Return-Path: <SRS0=BAu1=RF=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.7 required=3.0 tests=DKIM_ADSP_ALL,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CF86DC43381
	for <linux-btrfs@archiver.kernel.org>; Sat,  2 Mar 2019 19:12:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 76F7620838
	for <linux-btrfs@archiver.kernel.org>; Sat,  2 Mar 2019 19:12:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=lesimple.fr header.i=@lesimple.fr header.b="qt2zevKd"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726827AbfCBTMS (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sat, 2 Mar 2019 14:12:18 -0500
Received: from ns211617.ip-188-165-215.eu ([188.165.215.42]:57356 "EHLO
        mx.speed47.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726434AbfCBTMR (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Sat, 2 Mar 2019 14:12:17 -0500
X-Greylist: delayed 363 seconds by postgrey-1.27 at vger.kernel.org; Sat, 02 Mar 2019 14:12:16 EST
Received: from rc.speed47.net (nginx [192.168.80.2])
        by box.speed47.net (Postfix) with ESMTP id 3EC10F27
        for <linux-btrfs@vger.kernel.org>; Sat,  2 Mar 2019 20:06:09 +0100 (CET)
Authentication-Results: box.speed47.net; dmarc=fail (p=none dis=none) header.from=lesimple.fr
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=lesimple.fr; s=mail01;
        t=1551553569; bh=uZXZwN+GOl4wroF7EfrXi0lAt1hwZt80boWGcRdQ3Ko=;
        h=Date:From:To:Subject;
        b=qt2zevKdP56E/BsVId0i2etBLi3grriVZCyrQaubcSXIIpe9mGGpGwwVK1OUJrqcb
         7ulzy8YsQo0jvtw8ClnxYSWTaIusmq4Mb/8FiiCEicphfkEYH3uEscWdNRw2NWpfhL
         F/K2Q7dXWdpBUZLL76uzbKtcpvcx+pqxsHj5r7+U=
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8bit
Date:   Sat, 02 Mar 2019 20:06:09 +0100
From:   =?UTF-8?Q?St=C3=A9phane_Lesimple?= <stephane_btrfs@lesimple.fr>
To:     linux-btrfs@vger.kernel.org
Subject: Announcing the btrfs-list tool
Message-ID: <535a7ce9be6696815eb4413fd0f2ed17@lesimple.fr>
X-Sender: stephane_btrfs@lesimple.fr
User-Agent: Roundcube Webmail/1.2.4
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Hi!

I've been using btrfs as my main NAS filesystem for a bunch of years 
now, and I always found that managing dozens of subvolumes having dozens 
of snapshots each was not really straightforward, especially when trying 
to get an overview of "what's taking space on my filesystem". I was 
missing the niceness of the "zfs list" command, which does that quite 
well.

So I've started to write a wrapper around btrfs qgroup show and btrfs fi 
df (then btrfs fi usage when it got out), to implement this broad 
overview of my filesystem I was missing so much.
Adding some features along the way, I thought that after all it might 
also be useful to others than me!

As stdout is better than a thousand words, here's for example how it can 
show you a complex hierarchy of intricated snapshots:

root@nas:~# btrfs-list /mnt/a
NAME                                       TYPE     REFER      USED 
MOUNTPOINT
4582dacf                                     fs         -     0.00  
(1002.88M free)
    [main]                               mainvol    16.00k    16.00k 
/mnt/a
    sub1                                  subvol    16.00k    16.00k
       sub1/.snap1                          snap    16.00k    16.00k
       sub1/.snap2                          snap    16.00k    16.00k
       sub1/subsub1                         snap    16.00k    16.00k
          sub1/subsub1/.snap3               snap    16.00k    16.00k
          sub1/subsub1/subsubsub1           snap    16.00k    16.00k
             sub1/subsub1/subsubsubsub1     snap    16.00k    16.00k


Or how it can help you find big snapshots that you might want to get rid 
of if you're running out of space:

root@nas:~# btrfs-list --snap-min-used 4G --snap-only /tank
NAME                                                          TYPE     
REFER      USED MOUNTPOINT
       backups/.snaps/skyline/20130213_231649_lastskyline    rosnap    
22.52G    19.58G
       backups/.snaps/box/20171231_221207_monthly.12         rosnap    
88.73G     4.96G
       backups/.snaps/box/20180130_221209_monthly.11         rosnap    
91.25G     4.90G
       backups/.snaps/box/20180307_154215_monthly.10         rosnap    
96.28G    10.72G
       backups/.snaps/box/20190120_193004_weekly.3           rosnap    
56.45G     4.25G
       backups/.snaps/nasroot/20180122_091325_monthly.12     rosnap    
34.65G    10.79G
       backups/.snaps/nasroot/20180221_092311_monthly.11     rosnap    
31.96G     4.98G
       backups/.snaps/nasroot/20180323_092734_monthly.10     rosnap    
33.69G     7.05G
       backups/.snaps/nasroot/20180820_205559_monthly.5      rosnap    
31.74G     5.37G
       .syncthing-bkp                                        rosnap    
40.48G     8.15G

Want to give it a try? Here you are:
https://github.com/speed47/btrfs-list

There are a couple snapshots there too, to give you a rough idea of how 
it looks like (yes, it also has nice colors)

Happy btrfs weekend!

-- 
Stéphane.
