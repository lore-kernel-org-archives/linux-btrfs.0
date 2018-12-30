Return-Path: <SRS0=9xGW=PH=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4B5F4C43387
	for <linux-btrfs@archiver.kernel.org>; Sun, 30 Dec 2018 22:06:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B0AE320828
	for <linux-btrfs@archiver.kernel.org>; Sun, 30 Dec 2018 22:06:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=inv.alid.pw header.i=@inv.alid.pw header.b="nrBUN8du";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="U043Cits"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726773AbeL3WG0 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sun, 30 Dec 2018 17:06:26 -0500
Received: from wout1-smtp.messagingengine.com ([64.147.123.24]:49025 "EHLO
        wout1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726321AbeL3WGZ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 30 Dec 2018 17:06:25 -0500
X-Greylist: delayed 541 seconds by postgrey-1.27 at vger.kernel.org; Sun, 30 Dec 2018 17:06:24 EST
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.west.internal (Postfix) with ESMTP id E90EAC3D;
        Sun, 30 Dec 2018 16:57:22 -0500 (EST)
Received: from web1 ([10.202.2.211])
  by compute4.internal (MEProxy); Sun, 30 Dec 2018 16:57:23 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=inv.alid.pw; h=
        message-id:from:to:mime-version:content-transfer-encoding
        :content-type:references:date:in-reply-to:subject; s=mesmtp; bh=
        9wigt14QfBT9sxJHlR4lSXpWNYBu9i/WFJMY+4ErZS4=; b=nrBUN8duTIzKUcy+
        DNFJLN7aMYVFeS8KPg8pglWu01muG73iCSFZVVNwSAa/RBevo5SA5XA2TNnVtcR/
        CUe/qa7QNxZMWs42lwqNVXgWhahGWPohlBXfBglQst+03ZYvwHXRJc7EHTabibDK
        TdBtxqb9KGYuvYuj7a7FZ0VyBuU=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=content-transfer-encoding:content-type
        :date:from:in-reply-to:message-id:mime-version:references
        :subject:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm1; bh=9wigt14QfBT9sxJHlR4lSXpWNYBu9i/WFJMY+4ErZ
        S4=; b=U043Citsn47gdlgQduNuW8w7s/kCVox5AE99UPYbAq52vZVrhe9m46xuk
        +iW19GYt4SgglkuHHT8384PWw7RDzqMzcNW8UlfDKX4RjNN5j4ziAxvl5FZK0mmG
        nXXdC0bdMXqNL6HfHf+Gn3ZvU3IacaUvgEkYzxve8krFSxHavaCftaoFYek405ZD
        EQ6Pj2vQglOrunt3SsRU++944IZKBc7qzxnqMnn4B0iEhX4kYTIy4OVH9ji5zVNL
        xKZBs2e3P8fnNsxSC75ySUZJiqGOTEvV+rF57QbamFpdSGWGlxzo9L1ZaEHLTt3X
        DwLbjV+6Cem+0mGxcXlG+x55fzb0w==
X-ME-Sender: <xms:Qj8pXLgU9EIJCcg0eRMDZw37VC3tSI7_KpbX2JABQJ_N557iy4tGiw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedtledruddtgdduheehucdltddurdegtdekrddttd
    dmucetufdoteggodetrfdotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfquhht
    necuuegrihhlohhuthemuceftddtnecufghrlhcuvffnffculdduhedmnecujfgurhepkf
    fhvfgggfgtofhfffgjufesthejredtredtjeenucfhrhhomheplfhoshhhucfjohhllhgr
    nhguuceojhhoshhhsehinhhvrdgrlhhiugdrphifqeenucffohhmrghinhepshhmrghrth
    hmohhnthhoohhlshdrohhrghenucfrrghrrghmpehmrghilhhfrhhomhepjhhoshhhsehi
    nhhvrdgrlhhiugdrphifnecuvehluhhsthgvrhfuihiivgeptd
X-ME-Proxy: <xmx:Qj8pXLgH7Nz_fu9O0VeE1J8iyDl7MhuHmb-6v_Lkt6KIono6lIBEUg>
    <xmx:Qj8pXDlAIJMmB0UKqnazjTXKh2mYLodZPB4Lkko16xoVuK2LcZZZIA>
    <xmx:Qj8pXLEq9Q5SH0ib6gX8oEpLS4tWlgkk1XKRzBvQtUTdLC0sIYM9oQ>
    <xmx:Qj8pXGJNU_buo21NbadkUlApLTkGo53dYX7GxnIn5b8kexRYZO4ogA>
Received: by mailuser.nyi.internal (Postfix, from userid 99)
        id F3E459420A; Sun, 30 Dec 2018 16:57:21 -0500 (EST)
Message-Id: <1546207041.3838954.1621431160.664E52D0@webmail.messagingengine.com>
From:   Josh Holland <josh@inv.alid.pw>
To:     Qu Wenruo <quwenruo.btrfs@gmx.com>, linux-btrfs@vger.kernel.org
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="utf-8"
X-Mailer: MessagingEngine.com Webmail Interface - ajax-2f590f9a
References: <1546127794.2573034.1620895648.01F06240@webmail.messagingengine.com>
 <67b0235e-d79d-e0ff-fba6-310ad637ff98@gmx.com>
Date:   Sun, 30 Dec 2018 21:57:21 +0000
In-Reply-To: <67b0235e-d79d-e0ff-fba6-310ad637ff98@gmx.com>
Subject: Re: Checksum errors
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Thanks for the response. I've got network back now, and I'm working from a separate partition without having wiped the old one yet. I also seem to get a few errors on another LVM volume (root partition); not sure if that was happening before too, but it's mounting and (mostly) running OK now. This all started after a hard power-off after a freeze: I'm not sure if the freeze was a symptom of a disk error, or whether something got corrupted when I powered-off.

$ dmesg | grep -i btrfs
[    2.072920] Btrfs loaded, crc32c=crc32c-intel
[    2.073890] BTRFS: device fsid 5469fc4c-2798-40c6-9bc1-a05b0c0f8c34 devid 1 transid 8023 /dev/dm-0
[    2.074050] BTRFS: device fsid 846d42c9-f083-4ef7-b838-d6670a7110de devid 1 transid 20612 /dev/dm-1
[    2.077586] BTRFS: device fsid db95f600-d96a-413c-b444-aa9b9912140d devid 1 transid 5 /dev/dm-3
[    2.155875] BTRFS info (device dm-0): disk space caching is enabled
[    2.155876] BTRFS info (device dm-0): has skinny extents
[    2.157070] BTRFS info (device dm-0): bdev /dev/mapper/localdisk-root errs: wr 0, rd 7, flush 0, corrupt 0, gen 0
[    2.160266] BTRFS info (device dm-0): enabling ssd optimizations
[    2.400508] BTRFS info (device dm-0): disk space caching is enabled
[    2.955318] BTRFS info (device dm-3): enabling ssd optimizations
[    2.955323] BTRFS info (device dm-3): disk space caching is enabled
[    2.955325] BTRFS info (device dm-3): has skinny extents
[    2.955326] BTRFS info (device dm-3): flagging fs with big metadata feature
[    3.057332] BTRFS info (device dm-3): checking UUID tree
[    3.444095] BTRFS warning (device dm-0): dm-0 checksum verify failed on 272318464 wanted 959628B3 found 1E89226E level 0
[    3.465714] BTRFS warning (device dm-0): dm-0 checksum verify failed on 8921661440 wanted E49BF9B0 found C8B44432 level 0
[    3.465903] BTRFS warning (device dm-0): dm-0 checksum verify failed on 8921661440 wanted E49BF9B0 found C8B44432 level 0
[    3.466091] BTRFS warning (device dm-0): dm-0 checksum verify failed on 8921661440 wanted E49BF9B0 found C8B44432 level 0
[    3.466258] BTRFS warning (device dm-0): dm-0 checksum verify failed on 8921661440 wanted E49BF9B0 found C8B44432 level 0
[    3.466441] BTRFS warning (device dm-0): dm-0 checksum verify failed on 8921661440 wanted E49BF9B0 found C8B44432 level 0
[    3.466621] BTRFS warning (device dm-0): dm-0 checksum verify failed on 8921661440 wanted E49BF9B0 found C8B44432 level 0
[    3.466815] BTRFS warning (device dm-0): dm-0 checksum verify failed on 8921661440 wanted E49BF9B0 found C8B44432 level 0
[    3.466996] BTRFS warning (device dm-0): dm-0 checksum verify failed on 8921661440 wanted E49BF9B0 found C8B44432 level 0
[    3.467164] BTRFS warning (device dm-0): dm-0 checksum verify failed on 8921661440 wanted E49BF9B0 found C8B44432 level 0
[17381.330883] BTRFS warning (device dm-0): dm-0 checksum verify failed on 272318464 wanted 959628B3 found 1E89226E level 0
[17381.331204] BTRFS warning (device dm-0): dm-0 checksum verify failed on 272318464 wanted 959628B3 found 1E89226E level 0
[17381.331514] BTRFS warning (device dm-0): dm-0 checksum verify failed on 272318464 wanted 959628B3 found 1E89226E level 0
[17381.331824] BTRFS warning (device dm-0): dm-0 checksum verify failed on 272318464 wanted 959628B3 found 1E89226E level 0
[17381.332153] BTRFS warning (device dm-0): dm-0 checksum verify failed on 272318464 wanted 959628B3 found 1E89226E level 0
[17381.332467] BTRFS warning (device dm-0): dm-0 checksum verify failed on 272318464 wanted 959628B3 found 1E89226E level 0
[17381.332777] BTRFS warning (device dm-0): dm-0 checksum verify failed on 272318464 wanted 959628B3 found 1E89226E level 0
[17381.333086] BTRFS warning (device dm-0): dm-0 checksum verify failed on 272318464 wanted 959628B3 found 1E89226E level 0
[17381.333394] BTRFS warning (device dm-0): dm-0 checksum verify failed on 272318464 wanted 959628B3 found 1E89226E level 0
[17381.333701] BTRFS warning (device dm-0): dm-0 checksum verify failed on 272318464 wanted 959628B3 found 1E89226E level 0
[17500.459577] BTRFS warning (device dm-1): 'recovery' is deprecated, use 'usebackuproot' instead
[17500.459578] BTRFS info (device dm-1): trying to use backup root at mount time
[17500.459579] BTRFS info (device dm-1): disk space caching is enabled
[17500.459580] BTRFS info (device dm-1): has skinny extents
[17500.460612] BTRFS warning (device dm-1): dm-1 checksum verify failed on 843366400 wanted 41CCBAB1 found CAC59BAB level 0
[17500.460619] BTRFS warning (device dm-1): failed to read tree root
[17500.460751] BTRFS warning (device dm-1): dm-1 checksum verify failed on 843366400 wanted 41CCBAB1 found CAC59BAB level 0
[17500.460757] BTRFS warning (device dm-1): failed to read tree root
[17500.463210] BTRFS warning (device dm-1): dm-1 checksum verify failed on 840679424 wanted CC682A11 found 468165B5 level 0
[17500.463219] BTRFS error (device dm-1): failed to read block groups: -5
[17500.479842] BTRFS error (device dm-1): open_ctree failed
[20420.752154] BTRFS warning (device dm-0): dm-0 checksum verify failed on 272318464 wanted 959628B3 found 1E89226E level 0
[20420.752700] BTRFS warning (device dm-0): dm-0 checksum verify failed on 272318464 wanted 959628B3 found 1E89226E level 0
[20420.753217] BTRFS warning (device dm-0): dm-0 checksum verify failed on 272318464 wanted 959628B3 found 1E89226E level 0
[20420.753660] BTRFS warning (device dm-0): dm-0 checksum verify failed on 272318464 wanted 959628B3 found 1E89226E level 0
[20420.754115] BTRFS warning (device dm-0): dm-0 checksum verify failed on 272318464 wanted 959628B3 found 1E89226E level 0
[20420.754547] BTRFS warning (device dm-0): dm-0 checksum verify failed on 272318464 wanted 959628B3 found 1E89226E level 0
[20420.754955] BTRFS warning (device dm-0): dm-0 checksum verify failed on 272318464 wanted 959628B3 found 1E89226E level 0
[20420.755388] BTRFS warning (device dm-0): dm-0 checksum verify failed on 272318464 wanted 959628B3 found 1E89226E level 0
[20420.755807] BTRFS warning (device dm-0): dm-0 checksum verify failed on 272318464 wanted 959628B3 found 1E89226E level 0
[20420.756453] BTRFS warning (device dm-0): dm-0 checksum verify failed on 272318464 wanted 959628B3 found 1E89226E level 0
[20437.090564] BTRFS warning (device dm-0): dm-0 checksum verify failed on 272318464 wanted 959628B3 found 1E89226E level 0
[20437.091043] BTRFS warning (device dm-0): dm-0 checksum verify failed on 272318464 wanted 959628B3 found 1E89226E level 0
[20437.091495] BTRFS warning (device dm-0): dm-0 checksum verify failed on 272318464 wanted 959628B3 found 1E89226E level 0
[20437.091898] BTRFS warning (device dm-0): dm-0 checksum verify failed on 272318464 wanted 959628B3 found 1E89226E level 0
[20437.092337] BTRFS warning (device dm-0): dm-0 checksum verify failed on 272318464 wanted 959628B3 found 1E89226E level 0
[20437.092721] BTRFS warning (device dm-0): dm-0 checksum verify failed on 272318464 wanted 959628B3 found 1E89226E level 0
[20437.093163] BTRFS warning (device dm-0): dm-0 checksum verify failed on 272318464 wanted 959628B3 found 1E89226E level 0
[20437.093578] BTRFS warning (device dm-0): dm-0 checksum verify failed on 272318464 wanted 959628B3 found 1E89226E level 0
[20437.093982] BTRFS warning (device dm-0): dm-0 checksum verify failed on 272318464 wanted 959628B3 found 1E89226E level 0
[20437.094405] BTRFS warning (device dm-0): dm-0 checksum verify failed on 272318464 wanted 959628B3 found 1E89226E level 0
[20516.497344] BTRFS warning (device dm-0): dm-0 checksum verify failed on 272318464 wanted 959628B3 found 1E89226E level 0
[20516.497772] BTRFS warning (device dm-0): dm-0 checksum verify failed on 272318464 wanted 959628B3 found 1E89226E level 0
[20516.498212] BTRFS warning (device dm-0): dm-0 checksum verify failed on 272318464 wanted 959628B3 found 1E89226E level 0
[20516.498617] BTRFS warning (device dm-0): dm-0 checksum verify failed on 272318464 wanted 959628B3 found 1E89226E level 0
[20516.499029] BTRFS warning (device dm-0): dm-0 checksum verify failed on 272318464 wanted 959628B3 found 1E89226E level 0
[20516.499435] BTRFS warning (device dm-0): dm-0 checksum verify failed on 272318464 wanted 959628B3 found 1E89226E level 0
[20516.499782] BTRFS warning (device dm-0): dm-0 checksum verify failed on 272318464 wanted 959628B3 found 1E89226E level 0
[20516.500110] BTRFS warning (device dm-0): dm-0 checksum verify failed on 272318464 wanted 959628B3 found 1E89226E level 0
[20516.500430] BTRFS warning (device dm-0): dm-0 checksum verify failed on 272318464 wanted 959628B3 found 1E89226E level 0
[20516.500782] BTRFS warning (device dm-0): dm-0 checksum verify failed on 272318464 wanted 959628B3 found 1E89226E level 0


On Sun, 30 Dec 2018, at 12:36 AM, Qu Wenruo wrote:
> It's really recommended to check the SMART info or check if your
> underlying dm devices doesn't have something wrong.

$ sudo smartctl -a /dev/sda
smartctl 6.6 2017-11-05 r4594 [x86_64-linux-4.19.12-arch1-1-ARCH] (local build)
Copyright (C) 2002-17, Bruce Allen, Christian Franke, www.smartmontools.org

=== START OF INFORMATION SECTION ===
Model Family:     Samsung based SSDs
Device Model:     SAMSUNG MZHPV256HDGL-000L1
Serial Number:    S1WTNYAG308188
LU WWN Device Id: 5 002538 900000000
Firmware Version: BXW22L0Q
User Capacity:    256,060,514,304 bytes [256 GB]
Sector Size:      512 bytes logical/physical
Rotation Rate:    Solid State Device
Device is:        In smartctl database [for details use: -P show]
ATA Version is:   ACS-2, ATA8-ACS T13/1699-D revision 4c
SATA Version is:  SATA 3.1, 6.0 Gb/s (current: 6.0 Gb/s)
Local Time is:    Sun Dec 30 21:56:09 2018 GMT
SMART support is: Available - device has SMART capability.
SMART support is: Enabled

=== START OF READ SMART DATA SECTION ===
SMART overall-health self-assessment test result: PASSED

General SMART Values:
Offline data collection status:  (0x00)	Offline data collection activity
					was never started.
					Auto Offline Data Collection: Disabled.
Self-test execution status:      ( 121)	The previous self-test completed having
					the read element of the test failed.
Total time to complete Offline 
data collection: 		(    0) seconds.
Offline data collection
capabilities: 			 (0x53) SMART execute Offline immediate.
					Auto Offline data collection on/off support.
					Suspend Offline collection upon new
					command.
					No Offline surface scan supported.
					Self-test supported.
					No Conveyance Self-test supported.
					Selective Self-test supported.
SMART capabilities:            (0x0003)	Saves SMART data before entering
					power-saving mode.
					Supports SMART auto save timer.
Error logging capability:        (0x01)	Error logging supported.
					General Purpose Logging supported.
Short self-test routine 
recommended polling time: 	 (   2) minutes.
Extended self-test routine
recommended polling time: 	 (  20) minutes.
SCT capabilities: 	       (0x003d)	SCT Status supported.
					SCT Error Recovery Control supported.
					SCT Feature Control supported.
					SCT Data Table supported.

SMART Attributes Data Structure revision number: 1
Vendor Specific SMART Attributes with Thresholds:
ID# ATTRIBUTE_NAME          FLAG     VALUE WORST THRESH TYPE      UPDATED  WHEN_FAILED RAW_VALUE
  5 Reallocated_Sector_Ct   0x0033   067   067   010    Pre-fail  Always       -       435
  9 Power_On_Hours          0x0032   098   098   000    Old_age   Always       -       5858
 12 Power_Cycle_Count       0x0032   098   098   000    Old_age   Always       -       1791
170 Unused_Rsvd_Blk_Ct_Chip 0x0032   050   050   010    Old_age   Always       -       435
171 Program_Fail_Count_Chip 0x0032   053   053   010    Old_age   Always       -       406
172 Erase_Fail_Count_Chip   0x0032   100   100   010    Old_age   Always       -       0
173 Wear_Leveling_Count     0x0033   080   080   005    Pre-fail  Always       -       609
174 Unexpect_Power_Loss_Ct  0x0032   099   099   000    Old_age   Always       -       37
178 Used_Rsvd_Blk_Cnt_Chip  0x0013   050   050   010    Pre-fail  Always       -       435
180 Unused_Rsvd_Blk_Cnt_Tot 0x0013   050   050   010    Pre-fail  Always       -       431
184 End-to-End_Error        0x0033   100   100   097    Pre-fail  Always       -       0
187 Uncorrectable_Error_Cnt 0x0032   099   099   000    Old_age   Always       -       43
194 Temperature_Celsius     0x0032   069   035   000    Old_age   Always       -       31
199 CRC_Error_Count         0x003e   100   100   000    Old_age   Always       -       0
233 Media_Wearout_Indicator 0x0032   099   099   000    Old_age   Always       -       156032
241 Total_LBAs_Written      0x0032   099   099   000    Old_age   Always       -       14764
242 Total_LBAs_Read         0x0032   099   099   000    Old_age   Always       -       36217

Warning! SMART ATA Error Log Structure error: invalid SMART checksum.
SMART Error Log Version: 1
ATA Error Count: 43 (device log contains only the most recent five errors)
	CR = Command Register [HEX]
	FR = Features Register [HEX]
	SC = Sector Count Register [HEX]
	SN = Sector Number Register [HEX]
	CL = Cylinder Low Register [HEX]
	CH = Cylinder High Register [HEX]
	DH = Device/Head Register [HEX]
	DC = Device Command Register [HEX]
	ER = Error register [HEX]
	ST = Status register [HEX]
Powered_Up_Time is measured from power on, and printed as
DDd+hh:mm:SS.sss where DD=days, hh=hours, mm=minutes,
SS=sec, and sss=millisec. It "wraps" after 49.710 days.

Error 43 occurred at disk power-on lifetime: 5857 hours (244 days + 1 hours)
  When the command that caused the error occurred, the device was active or idle.

  After command completion occurred, registers were:
  ER ST SC SN CL CH DH
  -- -- -- -- -- -- --
  40 51 00 c0 5d 00 00  Error: 

  Commands leading to the command that caused the error were:
  CR FR SC SN CL CH DH DC   Powered_Up_Time  Command/Feature_Name
  -- -- -- -- -- -- -- --  ----------------  --------------------

Error 42 occurred at disk power-on lifetime: 5857 hours (244 days + 1 hours)
  When the command that caused the error occurred, the device was active or idle.

  After command completion occurred, registers were:
  ER ST SC SN CL CH DH
  -- -- -- -- -- -- --
  40 51 00 c0 5d 00 00  Error: 

  Commands leading to the command that caused the error were:
  CR FR SC SN CL CH DH DC   Powered_Up_Time  Command/Feature_Name
  -- -- -- -- -- -- -- --  ----------------  --------------------
  ea 00 00 00 00 00 00 00      00:00:48.163  FLUSH CACHE EXT
  ea 00 00 00 00 00 00 00      00:00:48.163  FLUSH CACHE EXT

Error 41 occurred at disk power-on lifetime: 5857 hours (244 days + 1 hours)
  When the command that caused the error occurred, the device was active or idle.

  After command completion occurred, registers were:
  ER ST SC SN CL CH DH
  -- -- -- -- -- -- --
  40 51 00 c0 5d 00 00  Error: 

  Commands leading to the command that caused the error were:
  CR FR SC SN CL CH DH DC   Powered_Up_Time  Command/Feature_Name
  -- -- -- -- -- -- -- --  ----------------  --------------------

Error 40 occurred at disk power-on lifetime: 5857 hours (244 days + 1 hours)
  When the command that caused the error occurred, the device was active or idle.

  After command completion occurred, registers were:
  ER ST SC SN CL CH DH
  -- -- -- -- -- -- --
  40 51 00 c0 5d 00 00  Error: 

  Commands leading to the command that caused the error were:
  CR FR SC SN CL CH DH DC   Powered_Up_Time  Command/Feature_Name
  -- -- -- -- -- -- -- --  ----------------  --------------------

Error 39 occurred at disk power-on lifetime: 5857 hours (244 days + 1 hours)
  When the command that caused the error occurred, the device was active or idle.

  After command completion occurred, registers were:
  ER ST SC SN CL CH DH
  -- -- -- -- -- -- --
  40 51 00 c0 5d 00 00  Error: 

  Commands leading to the command that caused the error were:
  CR FR SC SN CL CH DH DC   Powered_Up_Time  Command/Feature_Name
  -- -- -- -- -- -- -- --  ----------------  --------------------

Warning! SMART Self-Test Log Structure error: invalid SMART checksum.
SMART Self-test log structure revision number 1
Num  Test_Description    Status                  Remaining  LifeTime(hours)  LBA_of_first_error
# 1  Extended offline    Completed: read failure       90%      5857         18047792
# 2  Extended offline    Completed: read failure       90%      5857         18047792
# 3  Short offline       Completed without error       00%      5857         -

Warning! SMART Selective Self-Test Log Structure error: invalid SMART checksum.
SMART Selective self-test log data structure revision number 1
 SPAN   MIN_LBA   MAX_LBA  CURRENT_TEST_STATUS
    1         0         0  Not_testing
    2         0         0  Not_testing
    3         0         0  Not_testing
    4         0         0  Not_testing
    5         0         0  Not_testing
  255  18047792  18113327  Read_scanning was never started
Selective self-test flags (0x0):
  After scanning selected spans, do NOT read-scan remainder of disk.
If Selective self-test is pending on power-up, resume after 0 minute delay.


> You could user dump-super -f to show backup roots like:
> $ btrfs ins dump-super -f <device> | grep backup_tree_root

		backup_tree_root:	841973760	gen: 20611	level: 0
		backup_tree_root:	843366400	gen: 20612	level: 0
		backup_tree_root:	838418432	gen: 20609	level: 0
		backup_tree_root:	841203712	gen: 20610	level: 0



> Then try "btrfs check -r <number> <device>" to see if any of them has a
> better result.

The 3rd of these is the only one not to immediately error out with "cannot open file system":

parent transid verify failed on 838418432 wanted 20612 found 20609
parent transid verify failed on 838418432 wanted 20612 found 20609
Ignoring transid failure
[1/7] checking root items
[2/7] checking extents
bad tree block 976977920, bytenr mismatch, want=976977920, have=0
checksum verify failed on 788742144 found 42A844E1 wanted 01890B94
checksum verify failed on 788742144 found 42A844E1 wanted 01890B94
Csum didn't match
owner ref check failed [788742144 16384]
owner ref check failed [976977920 16384]
ERROR: errors found in extent allocation tree or chunk allocation
[3/7] checking free space cache
btrfs: csum mismatch on free space cache
failed to load free space cache for block group 22020096
btrfs: space cache generation (20611) does not match inode (20609)
failed to load free space cache for block group 1095761920
btrfs: space cache generation (20611) does not match inode (20609)
failed to load free space cache for block group 2169503744
btrfs: space cache generation (20612) does not match inode (20609)
failed to load free space cache for block group 5390729216
btrfs: space cache generation (20612) does not match inode (20609)
failed to load free space cache for block group 6464471040
btrfs: space cache generation (20612) does not match inode (20609)
failed to load free space cache for block group 7538212864
btrfs: space cache generation (20612) does not match inode (20609)
failed to load free space cache for block group 12906921984
btrfs: space cache generation (20612) does not match inode (20609)
failed to load free space cache for block group 16128147456
btrfs: space cache generation (20612) does not match inode (20609)
failed to load free space cache for block group 19349372928
btrfs: space cache generation (20612) does not match inode (20609)
failed to load free space cache for block group 23644340224
btrfs: csum mismatch on free space cache
failed to load free space cache for block group 24718082048
btrfs: csum mismatch on free space cache
failed to load free space cache for block group 26865565696
[4/7] checking fs roots
checksum verify failed on 788742144 found 42A844E1 wanted 01890B94
checksum verify failed on 788742144 found 42A844E1 wanted 01890B94
Csum didn't match
bad tree block 976977920, bytenr mismatch, want=976977920, have=0
root 5 inode 701555 errors 200, dir isize wrong
root 5 inode 701636 errors 2001, no inode item, link count wrong
        unresolved ref dir 701555 index 0 namelen 18 name 4dqcmdubjg0n6z4v.o filetype 1 errors 6, no dir index, no inode ref
root 5 inode 701664 errors 2001, no inode item, link count wrong
        unresolved ref dir 701555 index 0 namelen 13 name dep-graph.bin filetype 1 errors 6, no dir index, no inode ref
root 5 inode 701666 errors 2001, no inode item, link count wrong
        unresolved ref dir 219700 index 254 namelen 12 name libdria.rlib filetype 1 errors 4, no inode ref
        unresolved ref dir 219702 index 5429 namelen 29 name libdria-c46d210ccb7afe68.rlib filetype 1 errors 4, no inode ref
root 5 inode 701667 errors 2001, no inode item, link count wrong
        unresolved ref dir 700713 index 5 namelen 24 name s-f7pmszxh00-d4qwz3.lock filetype 1 errors 4, no inode ref
root 5 inode 701668 errors 2001, no inode item, link count wrong
        unresolved ref dir 700713 index 7 namelen 32 name s-f7pmszxh00-d4qwz3-7ms1gxgykr3x filetype 2 errors 4, no inode ref
root 5 inode 701684 errors 2001, no inode item, link count wrong
        unresolved ref dir 219700 index 255 namelen 4 name dria filetype 1 errors 4, no inode ref
        unresolved ref dir 219702 index 5442 namelen 21 name dria-21e88d4426553608 filetype 1 errors 4, no inode ref
root 5 inode 701711 errors 2001, no inode item, link count wrong
        unresolved ref dir 219672 index 405 namelen 8 name util.rs~ filetype 1 errors 4, no inode ref
root 5 inode 701715 errors 2001, no inode item, link count wrong
        unresolved ref dir 219672 index 406 namelen 7 name util.rs filetype 1 errors 4, no inode ref
root 5 inode 701758 errors 2001, no inode item, link count wrong
        unresolved ref dir 219672 index 412 namelen 6 name lib.rs filetype 1 errors 4, no inode ref
root 5 inode 701908 errors 2001, no inode item, link count wrong
        unresolved ref dir 270004 index 12 namelen 9 name util.rs.i filetype 1 errors 4, no inode ref
root 5 inode 701914 errors 2001, no inode item, link count wrong
        unresolved ref dir 219666 index 225 namelen 12 name strip-backup filetype 2 errors 4, no inode ref
root 5 inode 701923 errors 2001, no inode item, link count wrong
        unresolved ref dir 219667 index 173 namelen 19 name undo.backup.fncache filetype 1 errors 4, no inode ref
root 5 inode 701932 errors 2001, no inode item, link count wrong
        unresolved ref dir 219667 index 171 namelen 7 name fncache filetype 1 errors 4, no inode ref
root 5 inode 701940 errors 2001, no inode item, link count wrong
        unresolved ref dir 219666 index 247 namelen 9 name bookmarks filetype 1 errors 4, no inode ref
root 5 inode 701942 errors 2001, no inode item, link count wrong
        unresolved ref dir 270017 index 53 namelen 12 name branch2-base filetype 1 errors 4, no inode ref
root 5 inode 702084 errors 2001, no inode item, link count wrong
        unresolved ref dir 518530 index 7 namelen 12 name util.rs.html filetype 1 errors 4, no inode ref
root 5 inode 702113 errors 2001, no inode item, link count wrong
        unresolved ref dir 518536 index 9 namelen 4 name util filetype 2 errors 4, no inode ref
root 5 inode 702306 errors 2001, no inode item, link count wrong
        unresolved ref dir 13753 index 49 namelen 28 name error-sync-1545157735834.txt filetype 1 errors 4, no inode ref
root 5 inode 702319 errors 2001, no inode item, link count wrong
        unresolved ref dir 219665 index 43 namelen 7 name TODO.md filetype 1 errors 4, no inode ref
<snip thousands more similar lines>
root 5 inode 1037806 errors 2001, no inode item, link count wrong
        unresolved ref dir 120479 index 883 namelen 15 name localconfig.vdf filetype 1 errors 4, no inode ref
root 5 inode 1037809 errors 2001, no inode item, link count wrong
        unresolved ref dir 9757 index 195411 namelen 40 name 760533067AA7A58C05A4A0372243D7D484C1F909 filetype 1 errors 4, no inode ref
root 5 inode 1037810 errors 2001, no inode item, link count wrong
        unresolved ref dir 9744 index 1576 namelen 12 name safebrowsing filetype 2 errors 4, no inode ref
root 5 inode 1037854 errors 2001, no inode item, link count wrong
        unresolved ref dir 9743 index 47643 namelen 8 name prefs.js filetype 1 errors 4, no inode ref
root 5 inode 1037857 errors 2001, no inode item, link count wrong
        unresolved ref dir 118662 index 3 namelen 81 name 41b47e4922451c3a34b4e70b22b54cbc4b200803_da39a3ee5e6b4b0d3255bfef95601890afd80709 filetype 1 errors 4, no inode ref
ERROR: errors found in fs roots
Opening filesystem to check...
Checking filesystem on /dev/dm-1
UUID: 846d42c9-f083-4ef7-b838-d6670a7110de
The following tree block(s) is corrupted in tree 5:
        tree block bytenr: 345817088, level: 1, node key: (701555, 84, 103522844)
found 35325345792 bytes used, error(s) found
total csum bytes: 34207356
total tree bytes: 270155776
total fs tree bytes: 216743936
total extent tree bytes: 11993088
btree space waste bytes: 40122636
file data blocks allocated: 42766196736
 referenced 34885287936
