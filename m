Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qk0-f181.google.com ([209.85.220.181]:35847 "EHLO
        mail-qk0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751951AbcIBWNR (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 2 Sep 2016 18:13:17 -0400
Received: by mail-qk0-f181.google.com with SMTP id l2so135070111qkf.3
        for <linux-btrfs@vger.kernel.org>; Fri, 02 Sep 2016 15:13:17 -0700 (PDT)
Message-ID: <1472854386.9717.7.camel@gmail.com>
Subject: Re: BTRFS constantly reports "No space left on device" even with a
 huge unallocated space
From: Ronan Arraes Jardim Chagas <ronisbr@gmail.com>
To: Chris Murphy <lists@colorremedies.com>
Cc: Jeff Mahoney <jeffm@suse.com>,
        "Austin S. Hemmelgarn" <ahferroin7@gmail.com>,
        Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>,
        Qu Wenruo <quwenruo@cn.fujitsu.com>
Date: Fri, 02 Sep 2016 19:13:06 -0300
In-Reply-To: <CAJCQCtQDmhU92-Jw=QFALzuKpGL1VdEo5XbJ3ipKbambNqtaFg@mail.gmail.com>
References: <1471023419.16857.9.camel@gmail.com>
         <1472676550.8145.1.camel@gmail.com>
         <CAJCQCtR8EKENcy0ApONzDTX0RNZb8Dh-+_au4cMkyK24RzDoNw@mail.gmail.com>
         <CAJCQCtTWJMigkeLUP0+aTFPwdpuJtMa3C4isercAfE_Wh3b=PQ@mail.gmail.com>
         <52290114-3b37-2de5-9c9f-ceda6dff955b@suse.com>
         <CAJCQCtSPLw5Kwunm6WdhDCiE8Kc7BcfZy6W9veuns7kBmgyivw@mail.gmail.com>
         <a61878b9-7b88-7aee-40cf-05368cd01d78@suse.com>
         <CAJCQCtTBfhXOLg3URfreG29NVfujPjEc0O_cnDFCzDQm0iRtaA@mail.gmail.com>
         <1472734635.3137.4.camel@gmail.com>
         <0778dff0-cb43-d279-adb2-0e314b61110d@gmail.com>
         <1472747695.3137.7.camel@gmail.com>
         <b0ec9154-16a5-5293-952a-0d5a988488e8@gmail.com>
         <ab83503e-58c5-e1b4-b1ba-1e1ea8313607@suse.com>
         <b9bd0a3d-0ae0-a30c-c14d-c85434134890@gmail.com>
         <CAJCQCtT1RptgW-_esKmm2_5eRTxd10wHNxwgNWHSD86LZJ7edQ@mail.gmail.com>
         <d1319d2e-3016-7eef-5f3f-87677600e13c@suse.com>
         <1472827395.3713.6.camel@gmail.com>
         <9dee919a-0e81-5ba7-ddc6-7dcdb3a6b873@suse.com>
         <1472829630.3713.8.camel@gmail.com>
         <506f2875-8cea-2d99-3664-52ee546adcfd@suse.com>
         <1472846181.13263.2.camel@gmail.com>
         <CAJCQCtQDmhU92-Jw=QFALzuKpGL1VdEo5XbJ3ipKbambNqtaFg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi!

Em Sex, 2016-09-02 às 15:34 -0600, Chris Murphy escreveu:
> Except for your software build case, I have about the same workload
> you have with two machines, one SSD one HDD, using 4.7.0 for a month,
> and then 4.7.2 for the last week. I haven't had any enospc on these
> two systems.
> 
> I think for you the path of least resistance that also permits
> further
> testing is to see if you can track down the leap 42.2 beta kernel
> which is 4.4.19-1-default. I'm not easily finding that particular
> one,
> but I did find something a bit more recent:
> http://download.opensuse.org/repositories/Kernel:/openSUSE-42.2/stand
> ard/x86_64/

Unfortunately, it will not be possible since my actual hardware depends
on kernel >= 4.6 :(

Just now, I saw the problem again. For the first time, it happened
twice in a small period. I was copying the e-mail from one IMAP server
to my local HD. I use offlineimap, but this time it changed the backend
to sqlite and started to create tons of database files, I think. My HDD
IO stayed at 60/70% for a very long period.

Hence, let's do a review of situations in which I saw the problem:

1) Local builds using `osc`;
2) During `zypper dup`;
3) When offlineimap created tons of database files;
4) During rsync-ing /home;
4) During usage of a virtual machine (the disk image was in an EXT4
partition).

I think we can conclude that this problem is tightly coupled with
actions that require a lot of writing to the HDD. Here is the
specification of my HDD:

hdparm -I /dev/sda

/dev/sda:

ATA device, with non-removable media
	Model Number:       ST2000DM001-1CH164                      
	Serial Number:      W1E73CF5            
	Firmware Revision:  HP34    
	Transport:          Serial, SATA 1.0a, SATA II Extensions, SATA
Rev 2.5, SATA Rev 2.6, SATA Rev 3.0
Standards:
	Used: unknown (minor revision code 0x001f) 
	Supported: 9 8 7 6 5 
	Likely used: 9
Configuration:
	Logical		max	current
	cylinders	16383	16383
	heads		16	16
	sectors/track	63	63
	--
	CHS current addressable sectors:   16514064
	LBA    user addressable sectors:  268435455
	LBA48  user addressable sectors: 3907029168
	Logical  Sector size:                   512 bytes
	Physical Sector size:                  4096 bytes
	Logical Sector-0 offset:                  0 bytes
	device size with M = 1024*1024:     1907729 MBytes
	device size with M = 1000*1000:     2000398 MBytes (2000 GB)
	cache/buffer size  = unknown
	Form Factor: 3.5 inch
	Nominal Media Rotation Rate: 7200
Capabilities:
	LBA, IORDY(can be disabled)
	Queue depth: 32
	Standby timer values: spec'd by Standard, no device specific
minimum
	R/W multiple sector transfer: Max = 16	Current = ?
	Advanced power management level: 128
	Recommended acoustic management value: 208, current value: 0
	DMA: mdma0 mdma1 mdma2 udma0 udma1 udma2 udma3 udma4 *udma5 
	     Cycle time: min=120ns recommended=120ns
	PIO: pio0 pio1 pio2 pio3 pio4 
	     Cycle time: no flow control=120ns  IORDY flow
control=120ns
Commands/features:
	Enabled	Supported:
	   *	SMART feature set
	    	Security Mode feature set
	   *	Power Management feature set
	   *	Write cache
	   *	Look-ahead
	   *	WRITE_BUFFER command
	   *	READ_BUFFER command
	   *	DOWNLOAD_MICROCODE
	   *	Advanced Power Management feature set
	    	Power-Up In Standby feature set
	   *	SET_FEATURES required to spinup after power up
	   *	48-bit Address feature set
	   *	Device Configuration Overlay feature set
	   *	Mandatory FLUSH_CACHE
	   *	FLUSH_CACHE_EXT
	   *	SMART error logging
	   *	SMART self-test
	   *	General Purpose Logging feature set
	   *	64-bit World wide name
	   *	WRITE_UNCORRECTABLE_EXT command
	   *	{READ,WRITE}_DMA_EXT_GPL commands
	   *	Segmented DOWNLOAD_MICROCODE
	   *	Gen1 signaling speed (1.5Gb/s)
	   *	Gen2 signaling speed (3.0Gb/s)
	   *	Gen3 signaling speed (6.0Gb/s)
	   *	Native Command Queueing (NCQ)
	   *	Phy event counters
	   *	READ_LOG_DMA_EXT equivalent to READ_LOG_EXT
	   *	DMA Setup Auto-Activate optimization
	    	Device-initiated interface power management
	   *	Software settings preservation
	   *	SMART Command Transport (SCT) feature set
	   *	SCT Read/Write Long (AC1), obsolete
	   *	SCT Error Recovery Control (AC3)
	   *	SCT Features Control (AC4)
	   *	SCT Data Tables (AC5)
	    	unknown 206[12] (vendor specific)
	    	unknown 206[13] (vendor specific)
Security: 
	Master password revision code = 65534
		supported
	not	enabled
	not	locked
	not	frozen
	not	expired: security count
		supported: enhanced erase
	212min for SECURITY ERASE UNIT. 212min for ENHANCED SECURITY
ERASE UNIT. 
Logical Unit WWN Device Identifier: 5000c50072f7ce86
	NAA		: 5
	IEEE OUI	: 000c50
	Unique ID	: 072f7ce86
Checksum: correct

Best regards,
Ronan Arraes
